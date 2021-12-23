part of 'pos_barcode.dart';

class _PosBarcode implements PosBarcode {
  const _PosBarcode(
    this.barcode, {
    this.width,
    this.height,
    this.font,
    this.textPosition = BarcodeText.below,
    this.align = PosAlign.center,
  });

  final Barcode barcode;
  final int? width;
  final int? height;
  final BarcodeFont? font;
  final BarcodeText textPosition;
  final PosAlign align;

  @override
  List<int> generate(Generator generator) {
    final List<int> bytes = <int>[];
    // Set alignment
    bytes.addAll(
      generator.getStyles(const PosStyles().copyWith(align: align)).bytes,
    );

    // Set text position
    bytes.addAll(
      cBarcodeSelectPos.codeUnits + <int>[textPosition.value],
    );

    // Set font
    if (font != null) {
      bytes.addAll(
        cBarcodeSelectFont.codeUnits + <int>[font!.value],
      );
    }

    // Set width
    if (width != null && width! >= 0) {
      bytes.addAll(
        cBarcodeSetW.codeUnits + <int>[width!],
      );
    }
    // Set height
    if (height != null && height! >= 1 && height! <= 255) {
      bytes.addAll(
        cBarcodeSetH.codeUnits + <int>[height!],
      );
    }

    // Print barcode
    final List<int> header = cBarcodePrint.codeUnits +
        <int>[
          barcode.type!.value,
        ];
    if (barcode.type!.value <= 6) {
      // Function A
      bytes.addAll(
        header + barcode.data! + const <int>[0],
      );
    } else {
      // Function B
      bytes.addAll(
        header + <int>[barcode.data!.length] + barcode.data!,
      );
    }
    return bytes;
  }
}
