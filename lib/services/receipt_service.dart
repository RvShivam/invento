import 'dart:typed_data';
import 'package:flutter/services.dart'; // Needed for font loading
import 'package:pdf/widgets.dart' as pw;
import '../models/sales_transaction.dart';

class ReceiptService {
  Future<Uint8List> generateReceipt(SalesTransaction transaction) async {
    final pdf = pw.Document();

    // Load the custom font from your assets
    final fontData = await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    // Create a text style that uses your new font
    final pw.TextStyle customStyle = pw.TextStyle(font: ttf);
    final pw.TextStyle boldStyle = pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Receipt for Order ${transaction.orderId}',
                style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold, fontSize: 20),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Customer: ${transaction.customerName}', style: customStyle),
              pw.Text('Date: ${transaction.date}', style: customStyle),
              pw.Divider(height: 30),
              pw.Text('Items Sold:', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold, fontSize: 16)),
              pw.SizedBox(height: 10),
              // Apply the custom font style to the table
              pw.TableHelper.fromTextArray(
                headerStyle: boldStyle,
                cellStyle: customStyle,
                headers: ['Item', 'Qty', 'Price', 'Total'],
                data: transaction.items.map((item) => [
                  item.name,
                  item.quantity.toString(),
                  '₹${item.price.toStringAsFixed(2)}', // This will now render correctly
                  '₹${(item.quantity * item.price).toStringAsFixed(2)}',
                ]).toList(),
              ),
              pw.Divider(height: 30),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total Amount: ₹${transaction.totalAmount.toStringAsFixed(2)}', // This will now render correctly
                  style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}