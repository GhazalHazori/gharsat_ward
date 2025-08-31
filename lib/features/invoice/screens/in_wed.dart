import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gharsat_ward/features/invoice/controllers/invoice_controller.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

Widget buildInvoiceStatus(PreInvoiceController controller) {
  if (controller.isLoading) {
    return Center(child: CircularProgressIndicator());
  }
  if (controller.error != null) {
    return Text(controller.error!, style: TextStyle(color: Colors.red));
  }
  if (controller.preInvoice != null) {
    return Center(
      child: Text(
        controller.preInvoice!.id ?? '',
        style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Color(0xFFE48405),
            fontSize: 10),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
  return SizedBox.shrink();
}

class PdfItem {
  final String name;
  final int quantity;
  final double price;
  PdfItem({required this.name, required this.quantity, required this.price});
} 

pw.Widget buildInvoice({
  required String invoiceNumber,
  required String currentDate,
  required List<PdfItem> items,
  required double shippingFee,
  required double totalPrice,
  required String customerName,
  required String customerEmail,
  required pw.Font arabicFont,
}) {
  return pw.Directionality(
    textDirection: pw.TextDirection.ltr,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
     pw.Row(children: [
    pw.  Column(children: [

      ],)
     ]),
        // pw.Text('Purchase Invoice',
        //     style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Text('Invoice No: $invoiceNumber'),
        pw.Text('Date: $currentDate'),
        pw.SizedBox(height: 20),
        pw.Text('Customer Information:',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Text('Name: $customerName'),
        pw.Text('Email: $customerEmail'),
        pw.SizedBox(height: 20),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                pw.Padding(
                    padding: pw.EdgeInsets.all(8), child: pw.Text('Product')),
                pw.Padding(
                    padding: pw.EdgeInsets.all(8), child: pw.Text('Qty')),
                pw.Padding(
                    padding: pw.EdgeInsets.all(8), child: pw.Text('Price')),
                pw.Padding(
                    padding: pw.EdgeInsets.all(8), child: pw.Text('Total')),
              ],
            ),
            ...items
                .map((it) => pw.TableRow(children: [
                      pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(it.name,  textDirection: pw.TextDirection.rtl,
  style: pw.TextStyle(font: arabicFont),
)),
                      pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text('${it.quantity}')),
                      pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text('${it.price.toStringAsFixed(2)} EGP')),
                      pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                              '${(it.price * it.quantity).toStringAsFixed(2)} EGP')),
                    ]))
                .toList(),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Text('Shipping Fee: ${shippingFee.toStringAsFixed(2)} EGP'),
        pw.SizedBox(height: 10),
        pw.Text('Grand Total: ${totalPrice.toStringAsFixed(2)} EGP',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 20),
        pw.Text('Thank you for choosing our store'),
        pw.Text('For inquiries: 0123456789'),
        pw.Text('This e-invoice is considered original.'),
      ],
    ),
  );
}
