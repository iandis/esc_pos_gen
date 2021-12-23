import '../enums.dart';
import '../generator.dart';
import '../pos_styles.dart';
import '../qrcode.dart';
import 'pos_component.dart';

part 'pos_qr_code_impl.dart';

abstract class PosQRCode implements PosComponent {
  /// Creates a ESC/POS commands for printing a QR code
  ///
  /// * [align] defaults to [PosAlign.center]
  ///
  /// * [size] defaults to [QRSize.size4]
  ///
  /// * [correctionLevel] defaults to [QRCorrection.L]
  const factory PosQRCode(
    String text, {
    PosAlign align,
    QRSize size,
    QRCorrection correctionLevel,
  }) = _PosQRCode;
}
