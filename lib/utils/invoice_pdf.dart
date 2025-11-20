import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class InvoicePdf {
  static Future<Uint8List> fromImage(Uint8List imageBytes) async {
    final pdf = pw.Document();

    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Center(
            child: pw.Image(
              image,
              width: PdfPageFormat.a4.width - 40,
              fit: pw.BoxFit.contain,
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}
