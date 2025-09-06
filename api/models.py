from django.db import models
from django.utils import timezone
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    otp = models.CharField(max_length=6, null=True, blank=True)
    otp_expires = models.DateTimeField(null=True, blank=True)
    name = models.CharField(max_length=255)
    email = models.EmailField(unique=True)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    groups = models.ManyToManyField(
        'auth.Group',
        related_name='api_user_set',  
        blank=True,
    )
    user_permissions = models.ManyToManyField(
        'auth.Permission',
        related_name='api_user_permissions_set', 
        blank=True,
    )

class Item(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='items')
    name = models.CharField(max_length=255)
    sku = models.CharField(max_length=100, unique=True)
    category = models.CharField(max_length=100)
    supplier = models.CharField(max_length=100)
    quantity = models.IntegerField(default=0)
    purchase_price = models.DecimalField(max_digits=10, decimal_places=2)
    selling_price = models.DecimalField(max_digits=10, decimal_places=2)
    date_added = models.DateTimeField(auto_now_add=True)
    stock_history = models.JSONField(default=list)

    def __str__(self):
        return self.name
    
class Sale(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sales')
    order_id = models.CharField(max_length=50, unique=True, blank=True)
    customer_name = models.CharField(max_length=255)
    date = models.DateTimeField(default=timezone.now)
    items_sold = models.JSONField(default=list)
    total_amount = models.DecimalField(max_digits=10, decimal_places=2)

    def save(self, *args, **kwargs):
        if not self.order_id:
            last_sale = Sale.objects.order_by('id').last()
            new_id = (last_sale.id + 1) if last_sale else 1
            self.order_id = f'S-{1000 + new_id}'
        super(Sale, self).save(*args, **kwargs)

    def __str__(self):
        return self.order_id