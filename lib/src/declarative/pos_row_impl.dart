part of 'pos_row.dart';

class _PosRow implements PosRow {
  const _PosRow(this.columns);

  final List<PosColumn> columns;

  @override
  List<int> generate(Generator generator) {
    final List<int> bytes = <int>[];
    final int totalColumn = columns.fold(
      0,
      (int sum, PosColumn col) => sum + col.width,
    );

    final bool isSumValid = totalColumn == 12;
    if (!isSumValid) {
      throw Exception('Total columns width must be equal to 12');
    }
    bool isNextRow = false;
    final List<PosColumn> nextRow = <PosColumn>[];

    for (int i = 0; i < columns.length; ++i) {
      final int colInd = columns.sublist(0, i).fold(
            0,
            (int sum, PosColumn col) => sum + col.width,
          );
      final double charWidth = helpers.getCharWidth(
        columns[i].styles,
        paperSize: generator.paperSize,
        defaultMaxCharsPerLine: generator.maxCharsPerLine,
        defaultFontType: generator.styles.fontType,
      );
      final double fromPos = helpers.colIndToPosition(
        colInd: colInd,
        paperSize: generator.paperSize,
      );
      final double toPos = helpers.colIndToPosition(
            colInd: colInd + columns[i].width,
            paperSize: generator.paperSize,
          ) -
          generator.spaceBetweenRows;
      final int maxCharactersNb = ((toPos - fromPos) / charWidth).floor();

      if (!columns[i].containsChinese) {
        // CASE 1: containsChinese = false
        Uint8List encodedToPrint = columns[i].textEncoded != null
            ? columns[i].textEncoded!
            : helpers.encode(columns[i].text);

        // If the col's content is too long, split it to the next row
        final int realCharactersNb = encodedToPrint.length;
        if (realCharactersNb > maxCharactersNb) {
          // Print max possible and split to the next row
          final Uint8List encodedToPrintNextRow = encodedToPrint.sublist(
            maxCharactersNb,
          );
          encodedToPrint = encodedToPrint.sublist(0, maxCharactersNb);
          isNextRow = true;
          nextRow.add(
            PosColumn(
              textEncoded: encodedToPrintNextRow,
              width: columns[i].width,
              styles: columns[i].styles,
            ),
          );
        } else {
          // Insert an empty col
          nextRow.add(
            PosColumn(
              width: columns[i].width,
              styles: columns[i].styles,
            ),
          );
        }
        // end rows splitting
        bytes.addAll(
          helpers.generateText(
            encodedToPrint,
            styles: columns[i].styles,
            colInd: colInd,
            colWidth: columns[i].width,
            defaultFontType: generator.styles.fontType,
            defaultMaxCharsPerLine: generator.maxCharsPerLine,
            spaceBetweenRows: generator.spaceBetweenRows,
            paperSize: generator.paperSize,
            getStylesFn: generator.getStyles,
          ),
        );
      } else {
        // CASE 1: containsChinese = true
        // Split text into multiple lines if it too long
        int counter = 0;
        int splitPos = 0;
        for (int p = 0; p < columns[i].text.length; ++p) {
          final int w = helpers.isChinese(columns[i].text[p]) ? 2 : 1;
          if (counter + w >= maxCharactersNb) {
            break;
          }
          counter += w;
          splitPos += 1;
        }
        final String toPrintNextRow = columns[i].text.substring(splitPos);
        final String toPrint = columns[i].text.substring(0, splitPos);

        if (toPrintNextRow.isNotEmpty) {
          isNextRow = true;
          nextRow.add(
            PosColumn(
              text: toPrintNextRow,
              containsChinese: true,
              width: columns[i].width,
              styles: columns[i].styles,
            ),
          );
        } else {
          // Insert an empty col
          nextRow.add(
            PosColumn(
              width: columns[i].width,
              styles: columns[i].styles,
            ),
          );
        }

        // Print current row
        final List<List<Object>> list = helpers.getLexemes(toPrint);
        final List<String> lexemes = list[0] as List<String>;
        final List<bool> isLexemeChinese = list[1] as List<bool>;

        // Print each lexeme using codetable OR kanji
        for (int j = 0; j < lexemes.length; ++j) {
          bytes.addAll(
            helpers.generateText(
              helpers.encode(lexemes[j], isKanji: isLexemeChinese[j]),
              styles: columns[i].styles,
              colInd: colInd,
              colWidth: columns[i].width,
              isKanji: isLexemeChinese[j],
              paperSize: generator.paperSize,
              spaceBetweenRows: generator.spaceBetweenRows,
              defaultMaxCharsPerLine: generator.maxCharsPerLine,
              defaultFontType: generator.styles.fontType,
              getStylesFn: generator.getStyles,
            ),
          );
          // Define the absolute position only once (we print one line only)
        }
      }
    }

    bytes.addAll(helpers.emptyLines(1));

    if (isNextRow) {
      bytes.addAll(PosRow(nextRow).generate(generator));
    }
    return bytes;
  }
}
