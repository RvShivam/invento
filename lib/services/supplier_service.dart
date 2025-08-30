// lib/services/supplier_service.dart

class SupplierService {
  Future<List<String>> fetchSuppliers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      'TechPro',
      'ViewMax',
      'StreamCo',
      'ConnectIt',
      'ErgoLife',
    ];
  }
}