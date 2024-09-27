import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';

class QrCodeGenerator extends StatefulWidget {
  final String backendAddress;
  final String tableName;

  const QrCodeGenerator({
    super.key,
    required this.backendAddress,
    required this.tableName,
  });

  @override
  _QrCodeGeneratorState createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  final GlobalKey _globalKey = GlobalKey();

  Future<void> _downloadQrCode() async {
    try {
      final url =
          'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=${widget.backendAddress}|${widget.tableName}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        String filePath = '${directory.path}/${widget.tableName}.png';
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR Code saved to $filePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to download QR Code')),
        );
      }
    } catch (e) {
      print("Error downloading QR code: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error downloading QR Code')),
      );
    }
  }

  Future<void> _captureAndSaveQrCodeWithImage() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/${widget.tableName}.png';
      File imgFile = File(filePath);
      await imgFile.writeAsBytes(pngBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR Code with image saved to $filePath')),
      );
    } catch (e) {
      print("Error saving QR code with image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save QR Code with image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          key: _globalKey,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // The QR code image
              Image.network(
                'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=${widget.backendAddress}|${widget.tableName}',
                width: 300,
                height: 300,
              ),
              // The circular overlay image (e.g., logo)
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://cloud.appwrite.io/v1/storage/buckets/66cc9e94000920bfb736/files/66cc9f4b003d0b240b47/view?project=66ca28ea003c2ddf0db8&project=66ca28ea003c2ddf0db8'), // Replace with your image URL
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: _captureAndSaveQrCodeWithImage,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
              elevation: WidgetStateProperty.all<double>(3),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Download QR with Image",
                  style: TextStyle(color: Colors.grey[800]!),
                ),
                Icon(Icons.download, color: Colors.grey[800]!),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: _downloadQrCode,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
              elevation: WidgetStateProperty.all<double>(3),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Download QR Code (Fallback)",
                  style: TextStyle(color: Colors.grey[800]!),
                ),
                Icon(Icons.download, color: Colors.grey[800]!),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
