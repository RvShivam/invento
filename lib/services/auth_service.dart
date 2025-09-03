import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Use 'localhost' or '127.0.0.1' for web/iOS simulator.
  // Use '10.0.2.2' for the Android Emulator.
  final String _baseUrl = "http://localhost:8000/api";

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/register/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    return {'statusCode': response.statusCode, 'data': json.decode(response.body)};
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access']);
    }
    return {'statusCode': response.statusCode, 'data': json.decode(response.body)};
  }
  
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  Future<Map<String, dynamic>> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/send-otp/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );
    return {'statusCode': response.statusCode, 'data': json.decode(response.body)};
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/verify-otp/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'otp': otp}),
    );
    return {'statusCode': response.statusCode, 'data': json.decode(response.body)};
  }

  Future<Map<String, dynamic>> resetPassword(String newPassword, String tempToken) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/reset-password/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tempToken',
      },
      body: json.encode({
        'new_password': newPassword,
      }),
    );
    return {'statusCode': response.statusCode, 'data': json.decode(response.body)};
  }
}