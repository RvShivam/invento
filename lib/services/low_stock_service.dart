// lib/services/low_stock_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invento_app/services/auth_service.dart';
import '../models/low_stock_report_data.dart';

class LowStockService {
  
  final String _baseUrl = "http://localhost:8000/api";
  final AuthService _authService = AuthService();

  Future<LowStockReportData> fetchLowStockReport() async {
    final token = await _authService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$_baseUrl/reports/low-stock/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return LowStockReportData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load low stock report');
    }
  }
}