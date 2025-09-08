// lib/services/dashboard_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invento_app/services/auth_service.dart';
import '../models/dashboard_data.dart';

class DashboardService {
  final String _baseUrl = "http://localhost:8000/api";
  final AuthService _authService = AuthService();

  Future<DashboardData> fetchDashboardData() async {
    final token = await _authService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$_baseUrl/dashboard/stats/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return DashboardData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load dashboard data');
    }
  }
}