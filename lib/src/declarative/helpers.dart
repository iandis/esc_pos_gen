import 'dart:convert';
import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:image/image.dart';

import '../commands.dart';
import '../enums.dart';
import '../gbk_codec/gbk_codec.dart';
import '../pos_styles.dart';

int getMaxCharsPerLine({
  required PaperSize paperSize,
  PosFontType? font,
}) {
  if (paperSize == PaperSize.mm58) {
    return (font == null || font == PosFontType.fontA) ? 32 : 42;
  } else {
    return (font == null || font == PosFontType.fontA) ? 48 : 64;
  }
}

// charWidth = default width * text size multiplier
double getCharWidth(
  PosStyles styles, {
  required PaperSize paperSize,
  required PosFontType? defaultFontType,
  required int? defaultMaxCharsPerLine,
  int? maxCharsPerLine,
}) {
  final int charsPerLine = getCharsPerLine(
    styles,
    maxCharsPerLine,
    paperSize: paperSize,
    defaultMaxCharsPerLine: defaultMaxCharsPerLine,
    defaultFontType: defaultFontType,
  );
  final double charWidth =
      (paperSize.width / charsPerLine) * styles.width.value;
  return charWidth;
}

double colIndToPosition({
  required int colInd,
  required PaperSize paperSize,
}) {
  final int width = paperSize.width;
  return colInd == 0 ? 0 : (width * colInd / 12 - 1);
}

int getCharsPerLine(
  PosStyles styles,
  int? maxCharsPerLine, {
  required PaperSize paperSize,
  required int? defaultMaxCharsPerLine,
  required PosFontType? defaultFontType,
}) {
  int charsPerLine;
  if (maxCharsPerLine != null) {
    charsPerLine = maxCharsPerLine;
  } else {
    if (styles.fontType != null) {
      charsPerLine = getMaxCharsPerLine(
        font: styles.fontType,
        paperSize: paperSize,
      );
    } else {
      charsPerLine = defaultMaxCharsPerLine ??
          getMaxCharsPerLine(
            font: defaultFontType,
            paperSize: paperSize,
          );
    }
  }
  return charsPerLine;
}

Uint8List encode(String value, {bool isKanji = false}) {
  // replace some non-ascii characters
  final String text = value
      .replaceAll('\u2019', "'")
      .replaceAll('\u00b4', "'")
      .replaceAll('»', '"')
      .replaceAll('\u00a0', ' ')
      .replaceAll('•', '.');
  if (!isKanji) {
    return latin1.encode(text);
  } else {
    return Uint8List.fromList(gbkBytes.encode(text));
  }
}

List<List<Object>> getLexemes(String text) {
  final List<String> lexemes = <String>[];
  final List<bool> isLexemeChinese = <bool>[];
  int start = 0;
  int end = 0;
  bool curLexemeChinese = isChinese(text[0]);
  for (int i = 1; i < text.length; ++i) {
    if (curLexemeChinese == isChinese(text[i])) {
      end += 1;
    } else {
      lexemes.add(text.substring(start, end + 1));
      isLexemeChinese.add(curLexemeChinese);
      start = i;
      end = i;
      curLexemeChinese = !curLexemeChinese;
    }
  }
  lexemes.add(text.substring(start, end + 1));
  isLexemeChinese.add(curLexemeChinese);

  return <List<Object>>[lexemes, isLexemeChinese];
}

/// Break text into chinese/non-chinese lexemes
bool isChinese(String ch) {
  return ch.codeUnitAt(0) > 255;
}

/// Generate multiple bytes for a number:
/// In lower and higher parts, or more parts as needed.
///
/// [value] Input number
/// [bytesNb] The number of bytes to output (1 - 4)
List<int> intLowHigh(int value, int bytesNb) {
  final int maxInput = 256 << (bytesNb * 8) - 1;

  if (bytesNb < 1 || bytesNb > 4) {
    throw Exception('Can only output 1-4 bytes');
  }
  if (value < 0 || value > maxInput) {
    throw Exception(
      'Number is too large. '
      'Can only output up to $maxInput in $bytesNb bytes',
    );
  }

  final List<int> res = <int>[];
  int buf = value;
  for (int i = 0; i < bytesNb; ++i) {
    res.add(buf % 256);
    buf = buf ~/ 256;
  }
  return res;
}

/// Extract slices of an image as equal-sized blobs of column-format data.
///
/// [image] Image to extract from
/// [lineHeight] Printed line height in dots
List<List<int>> toColumnFormat(Image imgSrc, int lineHeight) {
  final Image image = Image.from(imgSrc); // make a copy

  // Determine new width: closest integer that is divisible by lineHeight
  final int widthPx = (image.width + lineHeight) - (image.width % lineHeight);
  final int heightPx = image.height;

  // Create a black bottom layer
  final Image biggerImage = copyResize(image, width: widthPx, height: heightPx);
  fill(biggerImage, 0);
  // Insert source image into bigger one
  drawImage(biggerImage, image, dstX: 0, dstY: 0);

  int left = 0;
  final List<List<int>> blobs = <List<int>>[];

  while (left < widthPx) {
    final Image slice = copyCrop(biggerImage, left, 0, lineHeight, heightPx);
    final Uint8List bytes = slice.getBytes(format: Format.luminance);
    blobs.add(bytes);
    left += lineHeight;
  }

  return blobs;
}

/// Image rasterization
List<int> toRasterFormat(Image imgSrc) {
  final Image image = Image.from(imgSrc); // make a copy
  final int widthPx = image.width;
  final int heightPx = image.height;

  grayscale(image);
  invert(image);

  // R/G/B channels are same -> keep only one channel
  final List<int> oneChannelBytes = <int>[];
  final List<int> buffer = image.getBytes();
  for (int i = 0; i < buffer.length; i += 4) {
    oneChannelBytes.add(buffer[i]);
  }

  // Add some empty pixels at the end of each line
  // (to make the width divisible by 8)
  if (widthPx % 8 != 0) {
    final int targetWidth = (widthPx + 8) - (widthPx % 8);
    final int missingPx = targetWidth - widthPx;
    final Uint8List extra = Uint8List(missingPx);
    for (int i = 0; i < heightPx; i++) {
      final int pos = (i * widthPx + widthPx) + i * missingPx;
      oneChannelBytes.insertAll(pos, extra);
    }
  }

  // Pack bits into bytes
  return packBitsIntoBytes(oneChannelBytes);
}

/// Merges each 8 values (bits) into one byte
List<int> packBitsIntoBytes(List<int> bytes) {
  const int pxPerLine = 8;
  final List<int> res = <int>[];
  const int threshold = 127; // set the greyscale -> b/w threshold here
  for (int i = 0; i < bytes.length; i += pxPerLine) {
    int newVal = 0;
    for (int j = 0; j < pxPerLine; j++) {
      newVal = transformUint32Bool(
        newVal,
        pxPerLine - j,
        shouldAddNewValue: bytes[i + j] > threshold,
      );
    }
    res.add(newVal ~/ 2);
  }
  return res;
}

/// Replaces a single bit in a 32-bit unsigned integer.
int transformUint32Bool(
  int uint32,
  int shift, {
  required bool shouldAddNewValue,
}) {
  return ((0xFFFFFFFF ^ (0x1 << shift)) & uint32) |
      ((shouldAddNewValue ? 1 : 0) << shift);
}

List<int> generateText(
  Uint8List textBytes, {
  required PaperSize paperSize,
  required int spaceBetweenRows,
  PosStyles styles = const PosStyles(),
  int? colInd = 0,
  bool isKanji = false,
  int colWidth = 12,
  int? maxCharsPerLine,
  required List<int> Function(PosStyles styles, {bool isKanji}) getStylesFn,
  required int? defaultMaxCharsPerLine,
  required PosFontType? defaultFontType,
}) {
  final List<int> bytes = <int>[];
  if (colInd != null) {
    final double charWidth = getCharWidth(
      styles,
      maxCharsPerLine: maxCharsPerLine,
      defaultFontType: defaultFontType,
      defaultMaxCharsPerLine: defaultMaxCharsPerLine,
      paperSize: paperSize,
    );
    double fromPos = colIndToPosition(
      colInd: colInd,
      paperSize: paperSize,
    );

    // Align
    if (colWidth != 12) {
      // Update fromPos
      final double toPos = colIndToPosition(
            colInd: colInd + colWidth,
            paperSize: paperSize,
          ) -
          spaceBetweenRows;
      final double textLen = textBytes.length * charWidth;

      if (styles.align == PosAlign.right) {
        fromPos = toPos - textLen;
      } else if (styles.align == PosAlign.center) {
        fromPos = fromPos + (toPos - fromPos) / 2 - textLen / 2;
      }
      if (fromPos < 0) {
        fromPos = 0;
      }
    }

    final String hexStr = fromPos.round().toRadixString(16).padLeft(3, '0');
    final List<int> hexPair = HEX.decode(hexStr);

    // Position
    bytes.addAll(
      Uint8List.fromList(
        List<int>.from(cPos.codeUnits)
          ..addAll(
            <int>[
              hexPair[1],
              hexPair[0],
            ],
          ),
      ),
    );
  }

  bytes.addAll(
    getStylesFn(styles, isKanji: isKanji),
  );

  return bytes..addAll(textBytes);
}

/// Prints one line of styled mixed (chinese and latin symbols) text
List<int> generateMixedKanji(
  String text, {
  PosStyles styles = const PosStyles(),
  int linesAfter = 0,
  int? maxCharsPerLine,
  required int spaceBetweenRows,
  required PaperSize paperSize,
  required List<int> Function(PosStyles styles, {bool isKanji}) getStylesFn,
  required PosFontType? defaultFontType,
  required int? defaultMaxCharsPerLine,
}) {
  List<int> bytes = <int>[];
  final List<List<Object>> list = getLexemes(text);
  final List<String> lexemes = list[0] as List<String>;
  final List<bool> isLexemeChinese = list[1] as List<bool>;

  // Print each lexeme using codetable OR kanji
  int? colInd = 0;
  for (int i = 0; i < lexemes.length; ++i) {
    bytes += generateText(
      encode(lexemes[i], isKanji: isLexemeChinese[i]),
      styles: styles,
      colInd: colInd,
      isKanji: isLexemeChinese[i],
      maxCharsPerLine: maxCharsPerLine,
      spaceBetweenRows: spaceBetweenRows,
      paperSize: paperSize,
      getStylesFn: getStylesFn,
      defaultMaxCharsPerLine: defaultMaxCharsPerLine,
      defaultFontType: defaultFontType,
    );
    // Define the absolute position only once (we print one line only)
    colInd = null;
  }

  return bytes += emptyLines(linesAfter + 1);
}

List<int> emptyLines(int n) {
  final List<int> bytes = <int>[];
  if (n > 0) {
    bytes.addAll(
      List<String>.filled(n, '\n').join().codeUnits,
    );
  }
  return bytes;
}
