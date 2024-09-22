import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

Center generateQrCodeForTable(String backendAddress, String tableName) {
  print(backendAddress);
  return Center(
    child: Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: QrImageView(
        errorCorrectionLevel: QrErrorCorrectLevel.H,
        data: '$backendAddress|$tableName',
        version: QrVersions.auto,
        size: 300,
        gapless: false,
        embeddedImage: const NetworkImage(
          "https://cloud.appwrite.io/v1/storage/buckets/66cc9e94000920bfb736/files/66cc9f4b003d0b240b47/view?project=66ca28ea003c2ddf0db8&mode=admin",
        ),
        embeddedImageStyle: const QrEmbeddedImageStyle(
          size: Size(80, 80),
          embeddedImageShape: EmbeddedImageShape.circle,
        ),
        padding: const EdgeInsets.all(20),
      ),
    ),
  );
}
