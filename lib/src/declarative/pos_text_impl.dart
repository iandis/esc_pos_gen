part of 'pos_text.dart';

class _PosText implements PosText {
  const _PosText(
    this.data, {
    this.styles = const PosStyles.defaults(),
    this.linesAfter = 0,
    this.containsChinese = false,
    this.maxCharsPerLine,
  });

  const _PosText.bold(
    this.data, {
    this.styles = const PosStyles.defaults(bold: true),
    this.linesAfter = 0,
    this.containsChinese = false,
    this.maxCharsPerLine,
  });

  const _PosText.center(
    this.data, {
    this.styles = const PosStyles.defaults(align: PosAlign.center),
    this.linesAfter = 0,
    this.containsChinese = false,
    this.maxCharsPerLine,
  });

  const _PosText.right(
    this.data, {
    this.styles = const PosStyles.defaults(align: PosAlign.right),
    this.linesAfter = 0,
    this.containsChinese = false,
    this.maxCharsPerLine,
  });

  final String data;
  final PosStyles styles;
  final int linesAfter;
  final bool containsChinese;
  final int? maxCharsPerLine;

  @override
  List<int> generate(Generator generator) {
    final List<int> bytes = <int>[];
    if (!containsChinese) {
      bytes.addAll(
        helpers.generateText(
          helpers.encode(data, isKanji: containsChinese),
          styles: styles,
          isKanji: containsChinese,
          maxCharsPerLine: maxCharsPerLine,
          paperSize: generator.paperSize,
          spaceBetweenRows: generator.spaceBetweenRows,
          defaultFontType: generator.styles.fontType,
          defaultMaxCharsPerLine: generator.maxCharsPerLine,
          getStylesFn: generator.getStyles,
        ),
      );
      // Ensure at least one line break after the text
      bytes.addAll(helpers.emptyLines(linesAfter + 1));
    } else {
      bytes.addAll(
        helpers.generateMixedKanji(
          data,
          styles: styles,
          linesAfter: linesAfter,
          spaceBetweenRows: generator.spaceBetweenRows,
          defaultFontType: generator.styles.fontType,
          defaultMaxCharsPerLine: generator.maxCharsPerLine,
          paperSize: generator.paperSize,
          getStylesFn: generator.getStyles,
        ),
      );
    }
    return bytes;
  }
}
