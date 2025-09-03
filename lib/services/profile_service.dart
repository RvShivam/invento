import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  final String _baseUrl = "http://localhost:8000/api";

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<Map<String, dynamic>> getProfile() async {
    final token = await _getToken();
    if (token == null) return {'statusCode': 401, 'data': {'error': 'Not authenticated'}};

    final response = await http.get(
      Uri.parse('$_baseUrl/users/profile/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return {'statusCode': response.statusCode, 'data': json.decode(response.body)};
  }

  Future<Map<String, dynamic>> updateProfile(String name, String email) async {
    final token = await _getToken();
    if (token == null) return {'statusCode': 401, 'data': {'error': 'Not authenticated'}};

    final response = await http.put(
      Uri.parse('$_baseUrl/users/profile/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'name': name, 'email': email}),
    );
    return {'statusCode': response.statusCode, 'data': json.decode(response.body)};
  }

  Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword) async {
    final token = await _getToken();
    if (token == null) return {'statusCode': 401, 'data': {'error': 'Not authenticated'}};

    final response = await http.put(
      Uri.parse('$_baseUrl/users/change-password/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );
    return {'statusCode': response.statusCode, 'data': json.decode(response.body)};
  }
  
  Future<String?> getUserEmail() async {
    final result = await getProfile();
    if (result['statusCode'] == 200) {
      return result['data']['email'];
    }
    return null;
  }

  
  Future<Map<String, dynamic>> deleteAccount() async {
    final token = await _getToken();
    if (token == null) return {'statusCode': 401, 'data': {'error': 'Not authenticated'}};

    final response = await http.delete(
      Uri.parse('$_baseUrl/users/delete/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return {'statusCode': response.statusCode, 'data': {'success': response.statusCode == 204}};
  }
}