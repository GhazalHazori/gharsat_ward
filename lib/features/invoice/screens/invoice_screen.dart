// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:gharsat_ward/features/invoice/controllers/invoice_controller.dart';
// import 'package:gharsat_ward/features/invoice/domins/models/pre_invoice.dart';
// import 'package:gharsat_ward/helper/network_info.dart';
// import 'package:gharsat_ward/main.dart';
// import 'package:open_file/open_file.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';

// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class InvoiceScreen extends StatefulWidget {
//   @override
//   State<InvoiceScreen> createState() => _InvoiceScreenState();
// }

// class _InvoiceScreenState extends State<InvoiceScreen> {
//   // بيانات المنتج
//   final String productName = "ساعة ذكية متطورة";

//   final String productDescription = "ساعة ذكية بشاشة AMOLED، مقاومة للماء، تتبع اللياقة البدنية، بطارية تدوم 7 أيام";

//   final double productPrice = 1299.0;

//   final int productQuantity = 1;

//   final String invoiceNumber = "INV-${DateTime.now().millisecondsSinceEpoch}";

//   final String customerName = "محمد أحمد";

//   final String customerEmail = "mohamed@example.com";

//   // دالة لإنشاء الفاتورة PDF
//   Future<void> generateInvoice() async {
//     final pdf = pw.Document();
//     final dateFormat = DateFormat('yyyy/MM/dd HH:mm');
//     final currentDate = dateFormat.format(DateTime.now());

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Directionality(
//             textDirection: pw.TextDirection.rtl, // للنص العربي
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 // رأس الفاتورة
//                 _buildInvoiceHeader(currentDate),
//                 pw.SizedBox(height: 20),
                
//                 // معلومات العميل
//                 _buildCustomerInfo(),
//                 pw.SizedBox(height: 20),
                
//                 // تفاصيل المنتج
//                 _buildProductDetails(),
//                 pw.SizedBox(height: 20),
                
//                 // المجموع
//                 _buildInvoiceTotal(),
//                 pw.SizedBox(height: 30),
                
//                 // تذييل الفاتورة
//                 _buildInvoiceFooter(),
//               ],
//             ),
//           );
//         },
//       ),
//     );

//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final fileName = 'فاتورة_$invoiceNumber.pdf';
//       final file = File('${directory.path}/$fileName');
//       await file.writeAsBytes(await pdf.save());
      
//       await OpenFile.open(file.path);
//     } catch (e) {
//       print('Error saving PDF: $e');
//     }
//   }

//   // بناء رأس الفاتورة
//   pw.Widget _buildInvoiceHeader(String currentDate) {
//     return pw.Column(
//       children: [
//         pw.Text(
//           'فاتورة شراء',
//           style: pw.TextStyle(
//             fontSize: 24,
//             fontWeight: pw.FontWeight.bold,
//           ),
//         ),
//         pw.SizedBox(height: 10),
//         pw.Text(
//           'رقم الفاتورة: $invoiceNumber',
//           style: const pw.TextStyle(fontSize: 16),
//         ),
//         pw.Text(
//           'التاريخ: $currentDate',
//           style: const pw.TextStyle(fontSize: 16),
//         ),
//       ],
//     );
//   }

//   // بناء معلومات العميل
//   pw.Widget _buildCustomerInfo() {
//     return pw.Container(
//       decoration: pw.BoxDecoration(
//         border: pw.Border.all(),
//         borderRadius: pw.BorderRadius.circular(5),
//       ),
//       padding: const pw.EdgeInsets.all(10),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             'معلومات العميل',
//             style: pw.TextStyle(
//               fontSize: 18,
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//           pw.Divider(),
//           pw.Text('الاسم: $customerName'),
//           pw.Text('البريد الإلكتروني: $customerEmail'),
//         ],
//       ),
//     );
//   }

//   // بناء تفاصيل المنتج
//   pw.Widget _buildProductDetails() {
//     return pw.Table(
//       border: pw.TableBorder.all(),
//       columnWidths: {
//         0: const pw.FlexColumnWidth(3),
//         1: const pw.FlexColumnWidth(1),
//         2: const pw.FlexColumnWidth(1),
//         3: const pw.FlexColumnWidth(1),
//       },
//       children: [
//         pw.TableRow(
//           decoration: const pw.BoxDecoration(color: PdfColors.grey200),
//           children: [
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(8),
//               child: pw.Text('المنتج', textAlign: pw.TextAlign.center),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(8),
//               child: pw.Text('الكمية', textAlign: pw.TextAlign.center),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(8),
//               child: pw.Text('السعر', textAlign: pw.TextAlign.center),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(8),
//               child: pw.Text('المجموع', textAlign: pw.TextAlign.center),
//             ),
//           ],
//         ),
//         pw.TableRow(
//           children: [
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(8),
//               child: pw.Text(productName),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(8),
//               child: pw.Text(productQuantity.toString()),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(8),
//               child: pw.Text('${productPrice.toStringAsFixed(2)} ج.م'),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(8),
//               child: pw.Text('${(productPrice * productQuantity).toStringAsFixed(2)} ج.م'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   // بناء قسم المجموع
//   pw.Widget _buildInvoiceTotal() {
//     return pw.Row(
//       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//       children: [
//         pw.Text(
//           'المجموع الكلي:',
//           style: pw.TextStyle(
//             fontSize: 18,
//             fontWeight: pw.FontWeight.bold,
//           ),
//         ),
//         pw.Text(
//           '${(productPrice * productQuantity).toStringAsFixed(2)} ج.م',
//           style: pw.TextStyle(
//             fontSize: 18,
//             fontWeight: pw.FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   // بناء تذييل الفاتورة
//   pw.Widget _buildInvoiceFooter() {
//     return pw.Column(
//       children: [
//         pw.Text('شكراً لاختياركم متجرنا'),
//         pw.Text('للاستفسار: 0123456789'),
//         pw.SizedBox(height: 10),
//         pw.Text(
//           'هذه الفاتورة صادرة إلكترونياً وتعتبر نسخة أصلية',
//           style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
//         ),
//       ],
//     );
//   }

//       PreInvoice? appVersion =
//           Provider.of<PreInvoiceController>(Get.context!, listen: false)
//               .preInvoice;

//   @override  @override
//   void initState() {
//     super.initState();


//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     _initializeAsync(context); // يتم تمرير context هنا
//   });

//   }
  
//   Future<void> _initializeAsync(BuildContext context) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     NetworkInfo.checkConnectivity(context);
//     Provider.of<PreInvoiceController>(context, listen: false).generatePreInvoice();
//   }  
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("تفاصيل المنتج"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // صورة المنتج
//             Container(
//               height: 200,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(Icons.image, size: 50, color: Colors.grey[400]),
//             ),
//             const SizedBox(height: 20),
            
//             // اسم المنتج
//             Text(
//               productName,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
            
//             // وصف المنتج
//             Text(
//               productDescription,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 16),
            
//             // السعر
//             Text(
//               '${productPrice.toStringAsFixed(2)} ج.م',
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//               ),
//             ),
//             const SizedBox(height: 30),
//               const SizedBox(height: 16),
            
//             // السعر
//             Text(
//               '${appVersion!.id} ج.م',
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//               ),
//             ),
//             const SizedBox(height: 30),
            
//             // أزرار الإجراءات
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("تمت إضافة المنتج إلى السلة")),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: const Text("إضافة إلى السلة"),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: generateInvoice,
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       backgroundColor: Colors.green,
//                     ),
//                     child: const Text("تحميل الفاتورة"),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }