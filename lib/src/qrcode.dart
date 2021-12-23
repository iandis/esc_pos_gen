import 'dart:convert';
import 'commands.dart';

class QRSize {
  const QRSize(this.value);
  final int value;

  static const QRSize size1 = QRSize(0x01);
  static const QRSize size2 = QRSize(0x02);
  static const QRSize size3 = QRSize(0x03);
  static const QRSize size4 = QRSize(0x04);
  static const QRSize size5 = QRSize(0x05);
  static const QRSize size6 = QRSize(0x06);
  static const QRSize size7 = QRSize(0x07);
  static const QRSize size8 = QRSize(0x08);
}

/// QR Correction level
class QRCorrection {
  const QRCorrection._internal(this.value);
  final int value;

  /// Level L: Recovery Capacity 7%
  static const QRCorrection L = QRCorrection._internal(48);

  /// Level M: Recovery Capacity 15%
  static const QRCorrection M = QRCorrection._internal(49);

  /// Level Q: Recovery Capacity 25%
  static const QRCorrection Q = QRCorrection._internal(50);

  /// Level H: Recovery Capacity 30%
  static const QRCorrection H = QRCorrection._internal(51);
}

class QRCode {
  QRCode(
    String text,
    QRSize size,
    QRCorrection level,
  ) {
    List<int> bytes = <int>[];
    // FN 167. QR Code: Set the size of module
    // pL pH cn fn n
    bytes += cQrHeader.codeUnits +
        const <int>[0x03, 0x00, 0x31, 0x43] +
        <int>[size.value];

    // FN 169. QR Code: Select the error correction level
    // pL pH cn fn n
    bytes += cQrHeader.codeUnits +
        const <int>[0x03, 0x00, 0x31, 0x45] +
        <int>[level.value];

    // FN 180. QR Code: Store the data in the symbol storage area
    final List<int> textBytes = latin1.encode(text);
    // pL pH cn fn m
    bytes += cQrHeader.codeUnits +
        <int>[
          textBytes.length + 3,
          0x00,
          0x31,
          0x50,
          0x30,
        ];
    bytes += textBytes;

    // FN 182. QR Code: Transmit the size information of
    // the symbol data in the symbol storage area
    // pL pH cn fn m
    bytes += cQrHeader.codeUnits + const <int>[0x03, 0x00, 0x31, 0x52, 0x30];

    // FN 181. QR Code: Print the symbol data in the symbol storage area
    // pL pH cn fn m
    bytes += cQrHeader.codeUnits + const <int>[0x03, 0x00, 0x31, 0x51, 0x30];

    this.bytes = bytes;
  }

  late final List<int> bytes;
}
