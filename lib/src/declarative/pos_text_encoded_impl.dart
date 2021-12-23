part of 'pos_text.dart';

class _PosTextEncoded implements PosText {
  const _PosTextEncoded(
    this.textBytes, {
    this.styles = const PosStyles(),
    this.linesAfter = 0,
    this.maxCharsPerLine,
  });

  final Uint8List textBytes;
  final PosStyles styles;
  final int linesAfter;
  final int? maxCharsPerLine;

  @override
  List<int> generate(Generator generator) {
    final List<int> bytes = <int>[];
    bytes.addAll(
      helpers.generateText(
        textBytes,
        styles: styles,
        maxCharsPerLine: maxCharsPerLine,
        paperSize: generator.paperSize,
        defaultFontType: generator.styles.fontType,
        defaultMaxCharsPerLine: generator.maxCharsPerLine,
        spaceBetweenRows: generator.spaceBetweenRows,
        getStylesFn: generator.getStyles,
      ),
    );

    // Ensure at least one line break after the text
    bytes.addAll(
      helpers.emptyLines(linesAfter + 1),
    );
    return bytes;
  }
}
