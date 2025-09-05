// lib/services/inventory_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invento_app/services/auth_service.dart';
import '../models/inventory_item.dart';

class InventoryService {

  final String _baseUrl = "http://localhost:8000/api";
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<InventoryItem>> fetchInventoryItems() async {
    final headers = await _getAuthHeaders();
    final response = await http.get(Uri.parse('$_baseUrl/items/'), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => InventoryItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load inventory items');
    }
  }
  
  Future<InventoryItem> addItem(Map<String, dynamic> itemData) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/items/'),
      headers: headers,
      body: json.encode(itemData),
    );

    if (response.statusCode == 201) {
      return InventoryItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add item: ${response.body}');
    }
  }

  Future<InventoryItem> updateItem(int itemId, Map<String, dynamic> itemData) async {
    final headers = await _getAuthHeaders();
    final response = await http.put(
      Uri.parse('$_baseUrl/items/$itemId/'),
      headers: headers,
      body: json.encode(itemData),
    );

    if (response.statusCode == 200) {
      return InventoryItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update item: ${response.body}');
    }
  }

  Future<void> deleteItem(int itemId) async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$_baseUrl/items/$itemId/'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete item');
    }
  }
  
  Future<bool> adjustStock(int itemId, int quantityChange, String description) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/items/$itemId/adjust_stock/'),
      headers: headers,
      body: json.encode({
        'quantity_change': quantityChange,
        'description': description,
      }),
    );
    return response.statusCode == 200;
  }
}