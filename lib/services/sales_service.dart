import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invento_app/services/auth_service.dart';
import '../models/sales_transaction.dart';

class SalesService {
  final String _baseUrl = "http://localhost:8000/api";
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<SalesTransaction>> fetchSalesHistory() async {
    final headers = await _getAuthHeaders();
    final response = await http.get(Uri.parse('$_baseUrl/sales/'), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => SalesTransaction.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load sales history');
    }
  }

  Future<void> recordSale(Map<String, dynamic> saleData) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/sales/'),
      headers: headers,
      body: json.encode(saleData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to record sale: ${response.body}');
    }
  }
}