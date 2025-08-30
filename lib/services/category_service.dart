// lib/services/category_service.dart

class CategoryService {
  // This simulates fetching the list of all available categories
  Future<List<String>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    return [
      'Electronics',
      'Accessories',
      'Home Appliances',
      'Mobile Devices',
      'Sports',
      'Furniture',
      'Clothing',
    ];
  }
}