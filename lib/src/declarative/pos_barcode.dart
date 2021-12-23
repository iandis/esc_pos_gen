import '../barcode.dart';
import '../commands.dart';
import '../enums.dart';
import '../generator.dart';
import '../pos_styles.dart';
import 'pos_component.dart';

part 'pos_barcode_impl.dart';

abstract class PosBarcode implements PosComponent {
  /// Creates ESC/POS commands for printing a barcode
  /// 
  /// * [width] range and units are different depending on the printer model
  /// (some printers use 1..5)
  /// 
  /// * [height] range: 1 - 255. The units depend on the printer model.
  /// Width, height, font, text position settings are effective until
  /// performing of ESC @, reset or power-off
  /// 
  /// * [textPosition] defaults to [BarcodeText.below]
  /// 
  /// * [align] defaults to [PosAlign.center]
  const factory PosBarcode(
    Barcode barcode, {
    int? width,
    int? height,
    BarcodeFont? font,
    BarcodeText textPosition,
    PosAlign align,
  }) = _PosBarcode;

  /// Creates ESC/POS commands for printing a `CODABAR (NW-7)` barcode.
  factory PosBarcode.codabar(
    List<dynamic> data, {
    int? width,
    int? height,
    BarcodeFont? font,
    BarcodeText textPosition = BarcodeText.below,
    PosAlign align = PosAlign.center,
  }) {
    return _PosBarcode(
      Barcode.codabar(data),
      width: width,
      height: height,
      font: font,
      textPosition: textPosition,
      align: align,
    );
  }

  /// Creates ESC/POS commands for printing a `CODE39` barcode.
  factory PosBarcode.code39(
    List<dynamic> data, {
    int? width,
    int? height,
    BarcodeFont? font,
    BarcodeText textPosition = BarcodeText.below,
    PosAlign align = PosAlign.center,
  }) {
    return _PosBarcode(
      Barcode.code39(data),
      width: width,
      height: height,
      font: font,
      textPosition: textPosition,
      align: align,
    );
  }

  /// Creates ESC/POS commands for printing a `CODE128` barcode.
  factory PosBarcode.code128(
    List<dynamic> data, {
    int? width,
    int? height,
    BarcodeFont? font,
    BarcodeText textPosition = BarcodeText.below,
    PosAlign align = PosAlign.center,
  }) {
    return _PosBarcode(
      Barcode.code128(data),
      width: width,
      height: height,
      font: font,
      textPosition: textPosition,
      align: align,
    );
  }

  /// Creates ESC/POS commands for printing a `JAN8 (EAN8)` barcode.
  factory PosBarcode.ean8(
    List<dynamic> data, {
    int? width,
    int? height,
    BarcodeFont? font,
    BarcodeText textPosition = BarcodeText.below,
    PosAlign align = PosAlign.center,
  }) {
    return _PosBarcode(
      Barcode.ean8(data),
      width: width,
      height: height,
      font: font,
      textPosition: textPosition,
      align: align,
    );
  }

  /// Creates ESC/POS commands for printing a `JAN13 (EAN13)` barcode.
  factory PosBarcode.ean13(
    List<dynamic> data, {
    int? width,
    int? height,
    BarcodeFont? font,
    BarcodeText textPosition = BarcodeText.below,
    PosAlign align = PosAlign.center,
  }) {
    return _PosBarcode(
      Barcode.ean13(data),
      width: width,
      height: height,
      font: font,
      textPosition: textPosition,
      align: align,
    );
  }

  /// Creates ESC/POS commands for printing a `ITF (Interleaved 2 of 5)` barcode.
  factory PosBarcode.itf(
    List<dynamic> data, {
    int? width,
    int? height,
    BarcodeFont? font,
    BarcodeText textPosition = BarcodeText.below,
    PosAlign align = PosAlign.center,
  }) {
    return _PosBarcode(
      Barcode.itf(data),
      width: width,
      height: height,
      font: font,
      textPosition: textPosition,
      align: align,
    );
  }

  /// Creates ESC/POS commands for printing a `UPC-A` barcode.
  factory PosBarcode.upcA(
    List<dynamic> data, {
    int? width,
    int? height,
    BarcodeFont? font,
    BarcodeText textPosition = BarcodeText.below,
    PosAlign align = PosAlign.center,
  }) {
    return _PosBarcode(
      Barcode.upcA(data),
      width: width,
      height: height,
      font: font,
      textPosition: textPosition,
      align: align,
    );
  }

  /// Creates ESC/POS commands for printing a `UPC-E` barcode.
  factory PosBarcode.upcE(
    List<dynamic> data, {
    int? width,
    int? height,
    BarcodeFont? font,
    BarcodeText textPosition = BarcodeText.below,
    PosAlign align = PosAlign.center,
  }) {
    return _PosBarcode(
      Barcode.upcE(data),
      width: width,
      height: height,
      font: font,
      textPosition: textPosition,
      align: align,
    );
  }
}
