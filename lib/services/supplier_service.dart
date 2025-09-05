// lib/services/supplier_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invento_app/services/auth_service.dart';

class SupplierService {
  final String _baseUrl = "http://localhost:8000/api";
  final AuthService _authService = AuthService();

  Future<List<String>> fetchSuppliers() async {
    final token = await _authService.getToken();
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(Uri.parse('$_baseUrl/suppliers/'), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Failed to load suppliers');
    }
  }
}