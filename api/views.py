from django.utils import timezone
from datetime import timedelta
import random
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.postgres.search import TrigramSimilarity
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated
from .serializers import (
    UserRegistrationSerializer, 
    UserLoginSerializer, 
    UserProfileSerializer,
    ChangePasswordSerializer,
    ItemSerializer,
    SaleSerializer
)
import rest_framework.serializers as serializers
from .models import User, Item, Sale
from django.db import transaction,models
from django.db.models import Sum, Count , F, Q, DecimalField
# from .email_utils import send_otp_email # Uncomment for email sending

class UserRegistrationView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserRegistrationSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)
            return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
        
        email = request.data.get('email')
        if email and User.objects.filter(email=email).exists():
            return Response({"error": "An account with this email already exists."}, status=status.HTTP_400_BAD_REQUEST)
            
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class UserLoginView(generics.GenericAPIView):
    serializer_class = UserLoginSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        email = serializer.validated_data['email']
        password = serializer.validated_data['password']
        
        user = authenticate(request, email=email, password=password)
        
        if user is None:
            return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
        
        refresh = RefreshToken.for_user(user)
        
        return Response({
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'user': {
                'id': user.id,
                'name': user.name,
                'email': user.email
            }
        })
    
class SendOtpView(generics.GenericAPIView):
    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({'error': 'User with this email does not exist.'}, status=status.HTTP_404_NOT_FOUND)

        otp = str(random.randint(100000, 999999))
        user.otp = otp
        user.otp_expires = timezone.now() + timedelta(minutes=5)
        user.save()

        # send_otp_email(user.email, otp)
        print(f"OTP for {user.email} is: {otp}")

        return Response({'success': 'OTP sent successfully.'}, status=status.HTTP_200_OK)

class VerifyOtpView(generics.GenericAPIView):
    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        otp = request.data.get('otp')

        try:
            user = User.objects.get(email=email)
            if user.otp == otp and user.otp_expires and user.otp_expires > timezone.now():
                user.otp = None
                user.otp_expires = None
                user.save()
                
                refresh = RefreshToken.for_user(user)
                return Response({
                    'success': 'OTP verified.',
                    'access_token': str(refresh.access_token)
                })
            else:
                return Response({'error': 'Invalid or expired OTP.'}, status=status.HTTP_400_BAD_REQUEST)
        except User.DoesNotExist:
            return Response({'error': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)

class ResetPasswordView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        user = request.user
        new_password = request.data.get('new_password')
        
        if not new_password:
            return Response({'error': 'New password is required.'}, status=status.HTTP_400_BAD_REQUEST)

        user.set_password(new_password)
        user.save()
        return Response({'success': 'Password has been reset successfully.'}, status=status.HTTP_200_OK)


class ProfileView(generics.RetrieveUpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = UserProfileSerializer

    def get_object(self):
        return self.request.user

class ChangePasswordView(generics.UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = ChangePasswordSerializer

    def update(self, request, *args, **kwargs):
        user = self.request.user
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        if not user.check_password(serializer.data.get("old_password")):
            return Response({"error": "Wrong password."}, status=status.HTTP_400_BAD_REQUEST)

        user.set_password(serializer.data.get("new_password"))
        user.save()

        return Response({"success": "Password updated successfully."}, status=status.HTTP_200_OK)
    
class DeleteAccountView(generics.DestroyAPIView):
    permission_classes = [IsAuthenticated]

    def get_object(self):
        return self.request.user

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return Response({"success": "Account deleted successfully."}, status=status.HTTP_204_NO_CONTENT)
    
class ItemListCreateView(generics.ListCreateAPIView):
    serializer_class = ItemSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        queryset = Item.objects.filter(user=self.request.user)
        
        search_query = self.request.query_params.get('search', None)
        
        if search_query:
            queryset = queryset.annotate(
                name_similarity=TrigramSimilarity('name', search_query),
                sku_similarity=TrigramSimilarity('sku', search_query),
            ).filter(
                models.Q(name_similarity__gt=0.1) | models.Q(sku_similarity__gt=0.1)
            ).order_by('-name_similarity', '-sku_similarity') 
            
        return queryset

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class ItemDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = ItemSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Item.objects.filter(user=self.request.user)
    
class LowStockReportView(generics.ListAPIView):
    serializer_class = ItemSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Item.objects.filter(user=self.request.user, quantity__lte=10)

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        report_data = {
            'totalLowStockItems': queryset.count(),
            'items': serializer.data
        }
        return Response(report_data)
    
class ItemDetailBySkuView(generics.RetrieveAPIView):
    serializer_class = ItemSerializer
    permission_classes = [IsAuthenticated]
    lookup_field = 'sku' 

    def get_queryset(self):
        return Item.objects.filter(user=self.request.user)
    
class AdjustStockView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Item.objects.all()
    serializer_class = ItemSerializer

    def get_object(self):
        queryset = self.get_queryset()
        obj = generics.get_object_or_404(queryset, pk=self.kwargs['pk'], user=self.request.user)
        return obj

    def post(self, request, *args, **kwargs):
        item = self.get_object()
        quantity_change = request.data.get('quantity_change')
        description = request.data.get('description')

        if not all([isinstance(quantity_change, int), description]):
            return Response({'error': 'Invalid data provided.'}, status=status.HTTP_400_BAD_REQUEST)

        item.quantity += quantity_change
        
        history_entry = {
            'type': 'Stock In' if quantity_change > 0 else 'Stock Out',
            'change': quantity_change,
            'description': description,
            'date': timezone.now().strftime('%Y-%m-%d')
        }
        if not isinstance(item.stock_history, list):
            item.stock_history = []
        item.stock_history.append(history_entry)
        
        item.save()
        serializer = self.get_serializer(item)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
class CategoryListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        categories = Item.objects.filter(user=request.user).order_by('category').values_list('category', flat=True).distinct()
        return Response(list(categories))

class SupplierListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        suppliers = Item.objects.filter(user=request.user).order_by('supplier').values_list('supplier', flat=True).distinct()
        return Response(list(suppliers))
    
class SaleListCreateView(generics.ListCreateAPIView):
    serializer_class = SaleSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Sale.objects.filter(user=self.request.user).order_by('-date')

    def perform_create(self, serializer):
        items_data = self.request.data.get('items_sold', [])
        customer_name = self.request.data.get('customer_name', 'N/A') 

        with transaction.atomic():
            sale_instance = serializer.save(user=self.request.user)

            for item_data in items_data:
                try:
                    item = Item.objects.get(pk=item_data['id'], user=self.request.user)
                    sold_quantity = item_data['quantity']

                    if item.quantity < sold_quantity:
                        raise serializers.ValidationError(f"Not enough stock for {item.name}.")
                    
                    
                    item.quantity -= sold_quantity
                    
                    
                    history_entry = {
                        'type': 'Stock Out',
                        'change': -sold_quantity, 
                        'description': f'Sold to {customer_name} (Order #{sale_instance.order_id})',
                        'date': timezone.now().strftime('%Y-%m-%d')
                    }
                    if not isinstance(item.stock_history, list):
                        item.stock_history = []
                    item.stock_history.append(history_entry)
                    
                    
                    item.save()

                except Item.DoesNotExist:
                    raise serializers.ValidationError(f"Item with id {item_data['id']} not found.")
                
            serializer.save(user=self.request.user)

class SaleDetailView(generics.RetrieveAPIView):
    serializer_class = SaleSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Sale.objects.filter(user=self.request.user)
    
class SalesReportView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        date_range = request.query_params.get('range', 'last7days')
        
        today = timezone.localdate()

        if date_range == 'today':
            sales = Sale.objects.filter(user=request.user, date__date=today)
        elif date_range == 'last7days':
            start_date = today - timedelta(days=7)
            sales = Sale.objects.filter(user=request.user, date__date__gte=start_date)
        elif date_range == 'last30days':
            start_date = today - timedelta(days=30)
            sales = Sale.objects.filter(user=request.user, date__date__gte=start_date)
        else:
            return Response({'error': 'Invalid date range'}, status=status.HTTP_400_BAD_REQUEST)

        report = sales.aggregate(
            total_revenue=Sum('total_amount'),
            number_of_sales=Count('id')
        )
        
        product_sales = {}
        for sale in sales:
            for item in sale.items_sold:
                name = item['name']
                quantity = item['quantity']
                revenue = float(item['price']) * quantity
                if name in product_sales:
                    product_sales[name]['quantitySold'] += quantity
                    product_sales[name]['totalRevenue'] += revenue
                else:
                    product_sales[name] = {'quantitySold': quantity, 'totalRevenue': revenue}
        
        sorted_products = sorted(product_sales.items(), key=lambda x: x[1]['quantitySold'], reverse=True)
        top_products = [
            {'name': name, 'quantitySold': data['quantitySold'], 'totalRevenue': data['totalRevenue']}
            for name, data in sorted_products[:5]
        ]

        response_data = {
            'totalRevenue': report['total_revenue'] or 0,
            'numberOfSales': report['number_of_sales'] or 0,
            'topSellingProducts': top_products,
        }
        return Response(response_data)
    
class DashboardStatsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        user = request.user
        today_start = timezone.now().replace(hour=0, minute=0, second=0, microsecond=0)

        item_stats = Item.objects.filter(user=user).aggregate(
            total_inventory_value=Sum(F('quantity') * F('purchase_price'), output_field=DecimalField()),
            low_stock_items=Count('id', filter=Q(quantity__gt=0, quantity__lte=10))
        )

        sales_stats = Sale.objects.filter(user=user).aggregate(
            total_sales=Sum('total_amount'),
            number_of_sales=Count('id'),
            todays_sales=Sum('total_amount', filter=Q(date__gte=today_start))
        )

        recent_orders = Sale.objects.filter(user=user).order_by('-date')[:3]
        recent_orders_data = SaleSerializer(recent_orders, many=True).data
        
        total_sales = sales_stats['total_sales'] or 0
        number_of_sales = sales_stats['number_of_sales'] or 0
        average_order_value = (total_sales / number_of_sales) if number_of_sales > 0 else 0
        
        thirty_days_ago = timezone.now() - timedelta(days=30)
        sales_trend_query = Sale.objects.filter(user=user, date__gte=thirty_days_ago).order_by('date')
        sales_trend_data = [
            {'x': index, 'y': float(sale.total_amount), 'date': sale.date.strftime('%d %b')}
            for index, sale in enumerate(sales_trend_query)
        ]

        sixty_days_ago = timezone.now() - timedelta(days=60)

        sales_last_30_days = Sale.objects.filter(user=user, date__gte=thirty_days_ago).aggregate(total=Sum('total_amount'))['total'] or 0
        sales_prev_30_days = Sale.objects.filter(user=user, date__gte=sixty_days_ago, date__lt=thirty_days_ago).aggregate(total=Sum('total_amount'))['total'] or 0

        sales_trend_percentage = 0
        if sales_prev_30_days > 0:
            sales_trend_percentage = ((sales_last_30_days - sales_prev_30_days) / sales_prev_30_days) * 100
        elif sales_last_30_days > 0:
            sales_trend_percentage = 100.0

        stats = {
            'totalInventoryValue': item_stats['total_inventory_value'] or 0,
            'lowStockItems': item_stats['low_stock_items'] or 0,
            'todaysSales': sales_stats['todays_sales'] or 0,
            'totalSales': total_sales,
            'averageOrderValue': average_order_value,
            'recentOrders': recent_orders_data,
            'salesTrendData': sales_trend_data,
            'salesTrendPercentage': sales_trend_percentage,
        }

        return Response(stats)