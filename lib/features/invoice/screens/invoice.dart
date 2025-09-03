import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gharsat_ward/features/address/controllers/address_controller.dart';
import 'package:gharsat_ward/features/checkout/controllers/checkout_controller.dart';
import 'package:gharsat_ward/features/invoice/controllers/invoice_controller.dart';
import 'package:gharsat_ward/features/invoice/screens/in_wed.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:gharsat_ward/features/cart/controllers/cart_controller.dart';
import 'package:gharsat_ward/features/shipping/controllers/shipping_controller.dart';
import 'package:gharsat_ward/features/profile/controllers/profile_contrroller.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class InvoiceScreen extends StatefulWidget {
   final double shippingFee;

  const InvoiceScreen({super.key, required this.shippingFee});
  @override
  
  State<InvoiceScreen> createState() => _InvoiceScreenState();
 
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late final String invoiceNumber = "920"; // Fixed invoice number as in sample
  bool _requestedInvoice = false;
String getOrderDate() {
  DateTime now = DateTime.now();

  // 9:00 PM
  DateTime startTime = DateTime(now.year, now.month, now.day, 21, 0);
  // 11:59:59 PM (قبل منتصف الليل بثانية)
  DateTime endTime = DateTime(now.year, now.month, now.day, 23, 59, 59);

  if (now.isAfter(startTime) && now.isBefore(endTime)) {
    // اذا بين 9 و 12 المسا → التاريخ بكرة
    DateTime tomorrow = now.add(Duration(days: 1));
    return DateFormat('yyyy-MM-dd').format(tomorrow);
  } else {
    // باقي الأوقات → اليوم
    return DateFormat('yyyy-MM-dd').format(now);
  }
}

Future<pw.MemoryImage> _loadImage() async {
  try {
    final ByteData data = await rootBundle.load(Images.logoImage);
    return pw.MemoryImage(data.buffer.asUint8List());
  } catch (e) {
    print('Using fallback image due to error: $e');
    // صورة افتراضية من الأصول (أو إنشاء صورة فارغة)
    final ByteData fallbackData = await rootBundle.load('assets/images/placeholder.jpg');
    return pw.MemoryImage(fallbackData.buffer.asUint8List());
  }
}
  Future<void> generateInvoice() async {
    final cartCtrl = Provider.of<CartController>(context, listen: false);
    final profileCtrl = Provider.of<ProfileController>(context, listen: false);
final headerImage = await _loadImage();
 final addressCtrl = Provider.of<AddressController>(context, listen: false);
  final checkoutCtrl = Provider.of<CheckoutController>(context, listen: false);

  final deliveryAddress = (addressCtrl.addressList != null && checkoutCtrl.addressIndex != null)
      ? addressCtrl.addressList![checkoutCtrl.addressIndex!]
      : null;
    // Company information (should be moved to constants or config)
    const companyName = "GHARSAT WARD LLC";
    const companyVatNo = "311633375400003";
    const companyCrNo = "4030508007";
    const companyAddress = "Jaddah - Alsalama Area";
    const companyStreet = "Saqr Quraish street";
    const companyBuildingNo = "2391";
    const companyContact = "SA95000068204919615000";
    const companyEmail = "flurex.co@outlook.com";

    // Customer information
    final customerName = profileCtrl.userInfoModel?.fName ?? "Guest";
    final customerVatNo = "310410504800003"; // Should come from profile
    final customerAddress = "${deliveryAddress?.address??'please chose address'}";
  
    // Invoice items - using data from cart
    final items = cartCtrl.cartList.map((c) {
      final pricePerUnit = (c.price ?? 0) - (c.discount ?? 0);
      final vatRate=c.tax??0;    double pictax= (100* c.tax!)/(c.price!);
      return InvoiceItem(
        description: c.name ?? 'Item',
        quantity: c.quantity ?? 0,
        unit: 'pcs', // Default unit, should come from product data
        unitPrice: pricePerUnit,
       taxableAmount: pricePerUnit * (c.quantity ?? 0) ,  // Assuming 15% VAT
        discountRate: c.discount!, 
        vatRate: c.tax!*c.quantity!,
        vatAmount: c.tax! ,
        discount:c.discount??0, piceTax: pictax, totalAmountDue: c.price!*c.quantity!,
        
     
      );
    }).toList();

    // Calculate totals
    double totalTaxableAmount = items.fold(0, (sum, item) =>sum + (item.quantity*item.unitPrice));
    double totalVat = items.fold(0, (sum, item) => sum + item.vatAmount*item.quantity);
    double totalAmountDue = items.fold(0, (sum, item) => totalTaxableAmount+totalVat+widget.shippingFee);
    double toteldiscount=items.fold(0, (sum, item) => sum + item.discount);

  // final ByteData imageData = await rootBundle.load('assets/images/gharsat.jpg');
  //   final headerImage = pw.MemoryImage(imageData.buffer.asUint8List());
    final pdf = pw.Document();
    final arabicFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/ubuntu/Amiri Regular.ttf"),
    );
           // تحميل صورة الهيدر من الملف
 

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: arabicFont),
        build: (context) => _buildInvoicePdf(
          invoiceNumber: invoiceNumber,
     
         image:headerImage,
          dateOfSupply: '${  cartCtrl.cartList.last.productInfo?.shippingMethod?.id==1?getOrderDate():
            cartCtrl.cartList.last.productInfo?.shippingMethod?.deliveryDate}',
          customerName: customerName,
          customerVatNo: customerVatNo,
          customerAddress: customerAddress,
          note: "INVOICE $invoiceNumber",
          items: items,
          companyName: companyName,
          companyVatNo: companyVatNo,
          companyCrNo: companyCrNo,
          companyAddress: companyAddress,
          companyStreet: companyStreet,
          companyBuildingNo: companyBuildingNo,
          companyContact: companyContact,
          companyEmail: companyEmail,
          arabicFont: arabicFont,
          totalTaxableAmount: totalTaxableAmount,
          totalVat: totalVat,
          totalAmountDue: totalAmountDue, toteldiscount:toteldiscount ,

        ),
      ),
    );

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/Order_$invoiceNumber.pdf');
      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);
    } catch (e) {
      print('Error saving PDF: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeAsync());
  }

  Future<void> _initializeAsync() async {
    await Future.delayed(Duration(milliseconds: 500));
    Provider.of<PreInvoiceController>(context, listen: false)
        .generatePreInvoice();
  }

  @override
  Widget build(BuildContext context) {
    final cartCtrl = Provider.of<CartController>(context);
    final shippingCtrl = Provider.of<ShippingController>(context);
    final profileCtrl = Provider.of<ProfileController>(context);
      final addressCtrl = Provider.of<AddressController>(context, listen: false); final checkoutCtrl = Provider.of<CheckoutController>(context);
      final deliveryAddress =
        (addressCtrl.addressList != null && checkoutCtrl.addressIndex != null)
            ? addressCtrl.addressList![checkoutCtrl.addressIndex!]
            : null;
    final billingAddress = (addressCtrl.addressList != null &&
            checkoutCtrl.billingAddressIndex != null)
        ? addressCtrl.addressList![checkoutCtrl.billingAddressIndex!]
        : null;
        

 final items = cartCtrl.cartList.map((c) {
      final pricePerUnit = (c.price ?? 0) - (c.discount ?? 0); double pictax= (100* c.tax!)/(c.price!);
      
      return InvoiceItem(
        description: c.name ?? 'Item',
        quantity: c.quantity ?? 0,
        unit: 'pcs', // Default unit, should come from product data
        unitPrice: pricePerUnit,
        taxableAmount:  (pricePerUnit*c.quantity! ) , // Assuming 15% VAT
        discountRate: c.discount!, // Should come from product/cart data
        vatRate: c.tax!,totalAmountDue:c.quantity!*c.price!,
        vatAmount: c.tax!, discount: c.discount!, piceTax:  pictax,
      );
    }).toList();

    // Calculate totals
    double totalTaxableAmount = items.fold(0, (sum, item) => sum +   item.totalAmountDue);
    double totalVat = items.fold(0, (sum, item) => sum + (item.vatAmount * item.quantity));
    double totalAmountDue = items.fold(0, (sum, item) =>totalTaxableAmount+totalVat+widget.shippingFee);
       double totalDiscount = items.fold(0, (sum, item) => sum + item.discount);
    // Calculate dynamic values
    int totalItems = 0;
    double subTotal = 0;
    for (var c in cartCtrl.cartList) {
      totalItems += (c.quantity ?? 0).toInt();
      subTotal += ((c.price ?? 0) - (c.discount ?? 0)) * (c.quantity ?? 0);
    }

    double shippingFee = 0;
    for (var s in shippingCtrl.chosenShippingList) {
      shippingFee += s.shippingCost ?? 0;
    }

    double totalPrice = subTotal + shippingFee;

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated('invoice_details', context) ?? "Invoice Details"), 
        centerTitle: true
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Info Section
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  children: [
              
                    Text(
                      "GHARSAT WARD LLC",
                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                    SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(
                      "WHOLESALE & RETAIL SALE OF FLOWERS",
                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    SizedBox(height: Dimensions.paddingSizeSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text("VAT No:", style: titilliumRegular.copyWith(fontSize: 10,     fontWeight: FontWeight.w400,)),
           Consumer<PreInvoiceController>(
              builder: (context, controller, _) {
                if (!_requestedInvoice &&
                    !controller.isLoading &&
                    controller.preInvoice == null) {
                  controller.generatePreInvoice();
                  _requestedInvoice = true;
                }
                return buildInvoiceStatus(controller);
              },
            ),
                          ],
                        ),
                        // SizedBox(width: Dimensions.paddingSizeLarge),
                        // Text("CR: 4030508007", style: titilliumRegular),
                      ],
                    ),
                    Divider(),
                    Text(
                      "Jaddah - Alsalama Area",
                      style: titilliumSemiBold,
                    ),
                    Text("Saqr Quraish street", style: titilliumRegular),
                    Text("Building N.O: 2391", style: titilliumRegular),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: Dimensions.paddingSizeDefault),
            
            // Invoice Info Section
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1.5),
                    // 2: FlexColumnWidth(1),
                    // 3: FlexColumnWidth(1.5),
                    // 4: FlexColumnWidth(1),
                    // 5: FlexColumnWidth(1),
                  },
                  border: TableBorder(
                    horizontalInside: BorderSide(width: 1, color: Colors.grey.shade200),
                  ),
                  children: [
                    TableRow(
                      // decoration: BoxDecoration(color: Colors.grey.shade100),
                      children: [
                        // _buildBilingualTableCell('Pay Type', 'طريقة الدفع'),
                        // _buildBilingualTableCell('Invoice Number', 'رقم الفاتورة'),
                        // Center(child: Text(invoiceNumber, style: titilliumRegular)),
                        _buildBilingualTableCell('Date Of Supply', 'تاريخ التوريد'),
                        Center(child: Text('${cartCtrl.cartList.last.productInfo?.shippingMethod?.deliveryDate}', style: titilliumRegular)),
                        // _buildBilingualTableCell('Date', 'التاريخ'),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildBilingualTableCell('Customer', 'العميل'),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                          child: Text(profileCtrl.userInfoModel?.fName ?? "Guest", style: titilliumRegular),
                        ),
                        // SizedBox.shrink(),
                        // _buildBilingualTableCell('Customer Vat No', 'الرقم الضريبي للعميل',),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                        //   child: Text("${profileCtrl.userInfoModel!.referCode}", style: titilliumRegular.copyWith(fontSize: 7)),
                        // ),
                        // SizedBox.shrink(),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildBilingualTableCell('Customer Address', 'عنوان العميل'),
                        Padding(
                         padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                          child: Text("${deliveryAddress?.address??'please chose delivery address'}", 
                            style: titilliumRegular),
                        ),
                        // SizedBox.shrink(),
                        // _buildBilingualTableCell('Note', 'البيان'),
            //             Padding(
            //               padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            //               child: Column(
            //                 children: [
            //                   Text("INVOICE", style: titilliumRegular.copyWith(fontSize: 10)),
            //                    Consumer<PreInvoiceController>(
            //   builder: (context, controller, _) {
            //     if (!_requestedInvoice &&
            //         !controller.isLoading &&
            //         controller.preInvoice == null) {
            //       controller.generatePreInvoice();
            //       _requestedInvoice = true;
            //     }
            //     return buildInvoiceStatus(controller);
            //   },
            // ),
            //                 ],
            //               ),
            //             ),
                        // SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: Dimensions.paddingSizeDefault),
            
            // Line Items Section
            Text(
              "Line Items:",
              style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
            SizedBox(height: Dimensions.paddingSizeSmall),
            
            Card(
              elevation: 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: Dimensions.paddingSizeLarge,
                  columns: [
                    DataColumn(label: _buildBilingualTableHeader('Nature of goods', 'نوع البضاعة')),
                    DataColumn(label: _buildBilingualTableHeader('Qty', 'الكمية'), numeric: true),
                    DataColumn(label: _buildBilingualTableHeader('Unit', 'الوحدة')),
                    DataColumn(label: _buildBilingualTableHeader('Unit Price', 'سعر الوحدة'), numeric: true),
                    DataColumn(label: _buildBilingualTableHeader('Taxable', 'المبلغ الخاضع'), numeric: true),
                    DataColumn(label: _buildBilingualTableHeader('Discount', 'نسبة الخصم'), numeric: true),DataColumn(label: _buildBilingualTableHeader('VAT', 'نسبة الضريبة'), numeric: true),
                    DataColumn(label: _buildBilingualTableHeader('VAT', 'قيمة الضريبة'), numeric: true), 
                    DataColumn(label: _buildBilingualTableHeader('Subtotal', 'المجموع'), numeric: true),
                  ],
                  rows: cartCtrl.cartList.map((item) {
                    final pricePerUnit = (item.price ?? 0) - (item.discount ?? 0);
                    final taxableAmount = (pricePerUnit*item.quantity! ) ;
                    // final totalAmountDue=item.quantity!*item.price!;
                    // final vatAmount = (pricePerUnit * (item.quantity ?? 0)) - taxableAmount;
                     final vatAmount =item.tax!;
                         final items = cartCtrl.cartList.map((c) {
      final pricePerUnit = (c.price ?? 0) - (c.discount ?? 0); double pictax= (100* c.tax!)/(c.price!);
      final vatRate=c.tax??0;
      return InvoiceItem(
        description: c.name ?? 'Item',
        quantity: c.quantity ?? 0,
        unit: 'pcs', // Default unit, should come from product data
        unitPrice: pricePerUnit,
        taxableAmount:  (pricePerUnit*item.quantity! )  , // Assuming 15% VAT
        discountRate: c.discount!, // Should come from product/cart data
        vatRate: c.tax!*c.quantity!,
        vatAmount: c.tax!, discount: c.discount??0, piceTax: pictax, totalAmountDue: c.quantity!*c.price! ,
      );
    }).toList();

    // Calculate totals
    double totalTaxableAmount = items.fold(0, (sum, item) => sum + item.taxableAmount);
    double totalVat = items.fold(0, (sum, item) => sum + (item.vatAmount*item.quantity ));
    double totalAmountDue =items.fold(0, (sum, item) => sum +( item.unitPrice*item.quantity));
    double pictax=(100*vatAmount)/pricePerUnit;
  // final ByteData imageData = await rootBundle.load('assets/images/gharsat.jpg');
  //   final headerImage = pw.MemoryImage(imageData.buffer.asUint8List());
   
           // تحميل صورة الهيدر من الملف
 
 
                    return DataRow(
                      cells: [
                        DataCell(Text(item.name ?? 'Item', style: titilliumRegular)),
                        DataCell(Text('${item.quantity}', style: titilliumRegular)),
                        DataCell(Text('pcs', style: titilliumRegular)), // Should come from product data
                        DataCell(Text(pricePerUnit.toStringAsFixed(2), style: titilliumRegular)),
                        DataCell(Text(taxableAmount.toStringAsFixed(2), style: titilliumRegular)),
                        DataCell(Text('${item.discount}%', style: titilliumRegular)), // Should come from product/cart data
                        DataCell(Text('${pictax}%', style: titilliumRegular)), 
                              DataCell(Text('${item.tax}', style: titilliumRegular)),
                        DataCell(Text('${(item.quantity! * item.price!+item.quantity!*item.tax!)} SAR', 
                          style: titilliumRegular)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            
            SizedBox(height: Dimensions.paddingSizeDefault),
            
            // Totals Section
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  children: [
                    Text(
                      "Total (Excluding VAT)",
                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                    SizedBox(height: Dimensions.paddingSizeSmall),
                    _buildTotalRow('Total Discount', 'مجموع الخصومات', "${totalDiscount}"),
                    Divider(),
                    _buildTotalRow('Total Taxable Amount', 'الإجمالي الخاضع للضريبة', 
                      (totalTaxableAmount ).toStringAsFixed(2)),
                    Divider(),
                    _buildTotalRow('Total VAT', 'مجموع ضريبة القيمة المضافة', 
                      totalVat.toStringAsFixed(2)),
                        Divider(),
                    _buildTotalRow('Shipping price', 'سعر التوصيل', 
                      widget.shippingFee.toStringAsFixed(2)),
                    Divider(),
                    _buildTotalRow(
                      'Total Amount Due', 
                      'إجمالي المبلغ المستحق', 
                      totalAmountDue.toStringAsFixed(2) + ' SAR',
                      isTotal: true
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: Dimensions.paddingSizeLarge),
            
            // Signature Sections
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("Received By", style: titilliumSemiBold),
                    Text("المستلم", style: titilliumRegular),
                    SizedBox(height: Dimensions.paddingSizeLarge),
                     Text("${profileCtrl.userInfoModel!.name}", style: titilliumRegular),
                    Container(
                      width: 150,
                      height: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Sales Representative", style: titilliumSemiBold),
                    Text("مندوب المبيعات", style: titilliumRegular),
                    SizedBox(height: Dimensions.paddingSizeLarge),
Text("Gharsat ward", style: titilliumRegular),
                    Container(
                      width: 150,
                      height: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: Dimensions.paddingSizeLarge),
            
            // Footer
            Center(
              child: Consumer<PreInvoiceController>(
              builder: (context, controller, _) {
                if (!_requestedInvoice &&
                    !controller.isLoading &&
                    controller.preInvoice == null) {
                  controller.generatePreInvoice();
                  _requestedInvoice = true;
                }
                return buildInvoiceStatus(controller);
              },
            ),
            ),
            Center(
              child: Text(
                "Email: flurex.co@outlook.com",
                style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
            ),
            
            SizedBox(height: Dimensions.paddingSizeLarge),
            
            // Download Button
            OutlinedButton.icon(
              onPressed: generateInvoice,
              icon: Icon(Icons.download),
              label: Text(getTranslated('download_invoice', context) ?? "Download Invoice"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(color: Theme.of(context).primaryColor),
                padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                minimumSize: Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBilingualTableCell(String english, String arabic) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(english, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
          Text(arabic, style: titilliumRegular.copyWith(
            fontSize: Dimensions.fontSizeExtraSmall,
            fontFamily: 'Amiri'
          )),
        ],
      ),
    );
  }

  Widget _buildBilingualTableHeader(String english, String arabic) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Column(
        children: [
          Text(english, style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
          Text(arabic, style: titilliumSemiBold.copyWith(
            fontSize: Dimensions.fontSizeExtraSmall,
            fontFamily: 'Amiri'
          )),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String english, String arabic, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(english, style: titilliumRegular),
              Text(arabic, style: titilliumRegular.copyWith(
                fontFamily: 'Amiri',
                fontSize: Dimensions.fontSizeSmall
              )),
            ],
          ),
          Text(value,
            style: isTotal
                ? titilliumSemiBold.copyWith(
                    color: Colors.orangeAccent,
                    fontSize: Dimensions.fontSizeLarge
                  )
                : titilliumRegular,
          ),
        ],
      ),
    );
  }

 List< pw.Widget> _buildInvoicePdf({
    required String invoiceNumber,
    required String dateOfSupply,
    required String customerName,
    required String customerVatNo,
    required String customerAddress,
    required String note,
    required final image,
    required double toteldiscount,
    required List<InvoiceItem> items,
    required String companyName,
    required String companyVatNo,
    required String companyCrNo,
    required String companyAddress,
    required String companyStreet,
    required String companyBuildingNo,
    required String companyContact,
    required String companyEmail,
    required pw.Font arabicFont,
    required double totalTaxableAmount,
    required double totalVat,
    required double totalAmountDue,
  }) {
   
    return [ pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Company Header
          pw.Row(
            children: [
         pw.   Column(children: [
 pw.Center(
            child: pw.Text(
              companyName,
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Center(
            child: pw.Text(
              'WHOLESALE & RETAIL SALE OF FLOWERS',
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 12,
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'VAT No : $companyVatNo',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 10,
                ),
              ),
              pw.SizedBox(width: 20),
              pw.Text(
                'CR : $companyCrNo',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 10,
                ),
              ),
            ],
          ),
//  pw.SizedBox(width: 20),
//  pw.Container(child: pw.Image())

       
  
       
            ],),  pw.SizedBox(width: 20),
            pw.Center(child:pw.Container(child:  pw.Image(image, width: 40, height: 40,),decoration:pw. BoxDecoration(color:PdfColors.black,shape: pw.BoxShape.rectangle))   ),
             pw.SizedBox(width: 20),
            pw.   Column(children: [

          pw.Center(
            child: pw.Text(
              'شركة غرسة ورد للتجارةذ م م',
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 12,
              ),
            ),
          ),
             pw.Center(
            child: pw.Text(
              'بيع الزهور والورود بالجملة والتجزئة',
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 12,
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'الرقم الضريبي : $companyVatNo',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 10,
                ),
              ),
              pw.SizedBox(width: 20),
              pw.Text(
                'س .ت: $companyCrNo',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 10,
                ),
              ),
            ],
          ),
 
        //  pw.Image(image,),
       
            ],)
          ]),
         
          pw.Divider(),
          
          // Company Address
          pw.Center(
            child: pw.Text(
              companyAddress,
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Center(
            child: pw.Text(
              companyStreet,
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 10,
              ),
            ),
          ),
          pw.Center(
            child: pw.Text(
              'Building N.O : $companyBuildingNo',
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 10,
              ),
            ),
          ),
          pw.Divider(),
          
          // Invoice Info Table
          pw.Table( tableWidth: pw.TableWidth.min,
             border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FlexColumnWidth(1),
              1: pw.FlexColumnWidth(1),
          
           
           
          
            },
            children: [
              pw.TableRow(
                children: [
                
               
                  _buildBilingualCellPdf('Date Of Supply', 'تاريخ التوريد', arabicFont),
                  pw.Text(dateOfSupply, textAlign: pw.TextAlign.center),
                
                ],
              ),
              pw.TableRow(
                children: [
                  _buildBilingualCellPdf('Customer', 'العميل', arabicFont),
                  pw.Text(customerName, textAlign: pw.TextAlign.center,style: pw.TextStyle(font: arabicFont)),
          
              
                ],
              ),
              pw.TableRow(
                children: [
                  _buildBilingualCellPdf('Customer Address', 'عنوان العميل', arabicFont),
                  pw.Text(customerAddress, style: pw.TextStyle(font: arabicFont,),textAlign: pw.TextAlign.center),
            
               
                 
                ],
              ),
              pw.TableRow(children: [    _buildBilingualCellPdf('Customer Vat No', 'الرقم الضريبي للعميل', arabicFont),
                  pw.Text(customerVatNo, style: pw.TextStyle(font: arabicFont),textAlign: pw.TextAlign.center),
                  pw.Container(),])
            ],
          ),
          pw.Divider(),
          
          // Line Items Header
    pw.Align(child:    pw.Text(
              'Line Items :',
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),alignment: pw.Alignment.topLeft),
        
          pw.SizedBox(height: 10),
          
          // Items Table
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1),
              3: pw.FlexColumnWidth(1),
              4: pw.FlexColumnWidth(1),
              5: pw.FlexColumnWidth(1),
              6: pw.FlexColumnWidth(1), 7: pw.FlexColumnWidth(1),
             
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [  _buildHeaderCellPdf('item name', 'اسم المنتج', arabicFont),
                  // _buildHeaderCellPdf('Nature of goods or services', 'نوع البضاعة أو الخدمة', arabicFont),
                  _buildHeaderCellPdf('Quantity', 'الكمية', arabicFont),
                  _buildHeaderCellPdf('Unit Price', 'سعر الوحدة', arabicFont),
                  _buildHeaderCellPdf('Taxable Amount', 'المبلغ الخاضع للضريبة', arabicFont),
                  _buildHeaderCellPdf('Discount Rate', 'نسبة الخصم', arabicFont),
                  _buildHeaderCellPdf('VAT Rate', 'نسبة الضريبة', arabicFont), _buildHeaderCellPdf('VAT Rate', 'قيمة الضريبة', arabicFont),
                  _buildHeaderCellPdf('Item Subtotal', 'المجموع شامل الضريبة', arabicFont),
                ],
              ),
              ...items.map((item) => pw.TableRow(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(2),
                    child: pw.Text(item.description, style: pw.TextStyle(font: arabicFont)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(1),
                    child: pw.Text('${item.quantity}', textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(1),
                    child: pw.Text('${item.unitPrice.toStringAsFixed(2)}', textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(1),
                    child: pw.Text('${item.taxableAmount.toStringAsFixed(2)}', textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(1),
                    child: pw.Text('${item.discountRate}%', textAlign: pw.TextAlign.center),
                  ), pw.Padding(
                    padding: pw.EdgeInsets.all(1),
                    child: pw.Text('${item.piceTax}%', textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(1),
                    child: pw.Text('${item.vatAmount}', textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(1),
                    child: pw.Text('${(item.quantity * item.unitPrice+item.quantity *item.vatAmount)} SAR', 
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(font: arabicFont)),
                  ),
                ],
              )).toList(),
            ],
          ),
        
          
          // // Totals Section
          // pw.Center(
          //   child: pw.Text(
          //     'Total (Excluding VAT)',
          //     style: pw.TextStyle(
          //       font: arabicFont,
          //       fontSize: 12,
          //       fontWeight: pw.FontWeight.bold,
          //     ),
          //   ),
          // ),
      
          pw.SizedBox(height: 10),
          pw.Table(  border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(1),
            },
            children: [
              pw.TableRow(
                children: [
                  _buildBilingualCellPdf('Total Discount', 'مجموع الخصومات', arabicFont),
                  pw.Text('${toteldiscount}', textAlign: pw.TextAlign.center),
                ],
              ),
              pw.TableRow(
                children: [
                  _buildBilingualCellPdf('Total Taxable Amount (Excluding VAT)', 
                    'الإجمالي الخاضع للضريبة / غير شامل الضريبة المضافة', arabicFont),
                  pw.Text('${totalTaxableAmount.toStringAsFixed(2)}', textAlign: pw.TextAlign.center),
                ],
              ),
              pw.TableRow(
                children: [
                  _buildBilingualCellPdf('Total VAT', 'مجموع ضريبة القيمة المضافة', arabicFont),
                  pw.Text('${totalVat.toStringAsFixed(2)}', textAlign: pw.TextAlign.center),
                ],
              ),
                 pw.TableRow(
                children: [
                  _buildBilingualCellPdf('Shipping price', 'سعر التوصيل', arabicFont),
                  pw.Text('${widget.shippingFee.toStringAsFixed(2)}', textAlign: pw.TextAlign.center),
                ],
              ),
              pw.TableRow(
                children: [
                  _buildBilingualCellPdf('Total Amount Due', 'إجمالي المبلغ المستحق', arabicFont),
                  pw.Text('${totalAmountDue.toStringAsFixed(2)} SAR', 
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                    )),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          
          // Signature Sections
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Column(
                children: [
                  pw.Text('Received By', style: pw.TextStyle(font: arabicFont)),
                  pw.Text('المستلم', style: pw.TextStyle(font: arabicFont)),
                  pw.SizedBox(height: 30),
                ],
              ),
              pw.Column(
                children: [
                  pw.Text('Sales Representative', style: pw.TextStyle(font: arabicFont)),
                  pw.Text('مندوب المبيعات', style: pw.TextStyle(font: arabicFont)),
                  pw.SizedBox(height: 30),
                ],
              ),
            ],
          ),
          
          // Footer
          pw.Divider(),
          pw.Center(
            child: pw.Text(
              companyContact,
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 10,
              ),
            ),
          ),
          pw.Center(
            child: pw.Text(
              'Email: $companyEmail',
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    )];
  }

  pw.Widget _buildBilingualCellPdf(String english, String arabic, pw.Font arabicFont) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Text(english, style: pw.TextStyle(fontSize: 8)),
        pw.Text(arabic, style: pw.TextStyle(font: arabicFont, fontSize: 10)),
      ],
    );
  }

  pw.Widget _buildHeaderCellPdf(String english, String arabic, pw.Font arabicFont) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(4),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(english, style: pw.TextStyle(fontSize: 8)),
          pw.Text(arabic, style: pw.TextStyle(font: arabicFont, fontSize: 10)),
        ],
      ),
    );
  }
}

class InvoiceItem {
  final String description;
  final int quantity;
  final String unit;
  final double unitPrice;
  final double taxableAmount;
  final double discountRate;
  final double vatRate;
  final double vatAmount;
  final double discount;
  final double piceTax;
  final double totalAmountDue;

  InvoiceItem(  {
    required this.description,
    required this.quantity,
   required this.piceTax,
    required this.unit,
    required this.unitPrice,
    required this.taxableAmount,
    required this.discountRate,
    required this.vatRate,
    required this.vatAmount,
     required this.discount,
     required this.totalAmountDue,
  });
    Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(value,
            style:
                isTotal ? TextStyle(fontSize: 18, color: Colors.orangeAccent) : null),
      ],
    );
  }
}