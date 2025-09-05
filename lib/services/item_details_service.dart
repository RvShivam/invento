// lib/services/item_details_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invento_app/services/auth_service.dart';
import '../models/item_details.dart';

class ItemDetailsService {
  final String _baseUrl = "http://localhost:8000/api";
  final AuthService _authService = AuthService();

  Future<ItemDetails> fetchItemDetails(String sku) async {
    final token = await _authService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$_baseUrl/items/sku/$sku/'), // Use the new, direct SKU endpoint
      headers: headers,
    );

    if (response.statusCode == 200) {
      // The response is now a single item object, not a list
      return ItemDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load item details for SKU $sku');
    }
  }
}