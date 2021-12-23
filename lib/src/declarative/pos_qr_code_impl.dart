part of 'pos_qr_code.dart';

class _PosQRCode implements PosQRCode {
  const _PosQRCode(
    this.text, {
    this.align = PosAlign.center,
    this.size = QRSize.size4,
    this.correctionLevel = QRCorrection.L,
  });

  final String text;
  final PosAlign align;
  final QRSize size;
  final QRCorrection correctionLevel;

  @override
  List<int> generate(Generator generator) {
    final List<int> bytes = <int>[];

    // Set alignment
    bytes.addAll(
      generator
          .getStyles(
            const PosStyles().copyWith(align: align),
          )
          .bytes,
    );
    final QRCode qr = QRCode(text, size, correctionLevel);
    return bytes..addAll(qr.bytes);
  }
}
