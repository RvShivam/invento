// lib/services/report_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invento_app/services/auth_service.dart';
import '../models/sales_report_data.dart';
import '../screens/sales_report_screen.dart';

class ReportService {
  final String _baseUrl = "http://localhost:8000/api";
  final AuthService _authService = AuthService();

  Future<SalesReportData> fetchSalesReport({required DateRange range}) async {
    final token = await _authService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final rangeQuery = range.toString().split('.').last.toLowerCase();

    final response = await http.get(
      Uri.parse('$_baseUrl/reports/sales/?range=$rangeQuery'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return SalesReportData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load sales report');
    }
  }
}