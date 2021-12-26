part of 'generator.dart';

class _GeneratorImpl implements Generator {
  _GeneratorImpl(
    this.paperSize,
    this.profile, {
    this.spaceBetweenRows = 5,
  });

  /// Ticket config
  @override
  final PaperSize paperSize;

  @override
  final int spaceBetweenRows;

  @override
  final CapabilityProfile profile;

  int? _maxCharsPerLine;

  @override
  int? get maxCharsPerLine => _maxCharsPerLine;

  /// Global styles
  String? _codeTable;

  @override
  String? get codeTable => _codeTable;

  PosFontType? _font;

  @override
  PosFontType? get font => _font;

  /// Current styles
  PosStyles _styles = const PosStyles();

  @override
  PosStyles get styles => _styles;

  /// Clear the buffer and reset text styles
  @override
  List<int> reset() {
    final List<int> bytes = <int>[];
    bytes.addAll(cInit.codeUnits);
    _styles = const PosStyles();
    bytes.addAll(setGlobalCodeTable(_codeTable));
    bytes.addAll(setGlobalFont(_font));
    return bytes;
  }

  /// Set global code table which will be used
  /// instead of the default printer's code table
  /// (even after resetting)
  @override
  List<int> setGlobalCodeTable(String? codeTable) {
    final List<int> bytes = <int>[];
    _codeTable = codeTable;
    if (codeTable != null) {
      bytes.addAll(
        Uint8List.fromList(
          List<int>.from(cCodeTable.codeUnits)
            ..add(
              profile.getCodePageId(codeTable),
            ),
        ),
      );
      _styles = _styles.copyWith(codeTable: codeTable);
    }
    return bytes;
  }

  /// Set global font which will be used instead of the default printer's font
  /// (even after resetting)
  @override
  List<int> setGlobalFont(PosFontType? font, {int? maxCharsPerLine}) {
    final List<int> bytes = <int>[];
    _font = font;
    if (font != null) {
      _maxCharsPerLine = maxCharsPerLine ??
          helpers.getMaxCharsPerLine(
            paperSize: paperSize,
            font: font,
          );
      bytes.addAll(
        font == PosFontType.fontB ? cFontB.codeUnits : cFontA.codeUnits,
      );
      _styles = _styles.copyWith(fontType: font);
    }
    return bytes;
  }

  @override
  List<int> setGlobalStyles(PosStyles styles, {bool isKanji = false}) {
    final List<int> bytes = <int>[];
    if (styles.align != _styles.align) {
      bytes.addAll(
        latin1.encode(
          styles.align == PosAlign.left
              ? cAlignLeft
              : (styles.align == PosAlign.center ? cAlignCenter : cAlignRight),
        ),
      );
      _styles = _styles.copyWith(align: styles.align);
    }

    if (styles.bold != _styles.bold) {
      bytes.addAll(styles.bold ? cBoldOn.codeUnits : cBoldOff.codeUnits);
      _styles = _styles.copyWith(bold: styles.bold);
    }
    if (styles.turn90 != _styles.turn90) {
      bytes.addAll(styles.turn90 ? cTurn90On.codeUnits : cTurn90Off.codeUnits);
      _styles = _styles.copyWith(turn90: styles.turn90);
    }
    if (styles.reverse != _styles.reverse) {
      bytes.addAll(
        styles.reverse ? cReverseOn.codeUnits : cReverseOff.codeUnits,
      );
      _styles = _styles.copyWith(reverse: styles.reverse);
    }
    if (styles.underline != _styles.underline) {
      bytes.addAll(
        styles.underline ? cUnderline1dot.codeUnits : cUnderlineOff.codeUnits,
      );
      _styles = _styles.copyWith(underline: styles.underline);
    }

    // Set font
    if (styles.fontType != null && styles.fontType != _styles.fontType) {
      bytes.addAll(
        styles.fontType == PosFontType.fontB
            ? cFontB.codeUnits
            : cFontA.codeUnits,
      );
      _styles = _styles.copyWith(fontType: styles.fontType);
    } else if (_font != null && _font != _styles.fontType) {
      bytes.addAll(
        _font == PosFontType.fontB ? cFontB.codeUnits : cFontA.codeUnits,
      );
      _styles = _styles.copyWith(fontType: _font);
    }

    // Characters size
    if (styles.height.value != _styles.height.value ||
        styles.width.value != _styles.width.value) {
      bytes.addAll(
        Uint8List.fromList(
          List<int>.from(cSizeGSn.codeUnits)
            ..add(PosTextSize.decSize(styles.height, styles.width)),
        ),
      );
      _styles = _styles.copyWith(height: styles.height, width: styles.width);
    }

    // Set Kanji mode
    if (isKanji) {
      bytes.addAll(cKanjiOn.codeUnits);
    } else {
      bytes.addAll(cKanjiOff.codeUnits);
    }

    // Set local code table
    if (styles.codeTable != null) {
      bytes.addAll(
        Uint8List.fromList(
          List<int>.from(cCodeTable.codeUnits)
            ..add(profile.getCodePageId(styles.codeTable)),
        ),
      );
      _styles =
          _styles.copyWith(align: styles.align, codeTable: styles.codeTable);
    } else if (_codeTable != null) {
      bytes.addAll(
        Uint8List.fromList(
          List<int>.from(cCodeTable.codeUnits)
            ..add(profile.getCodePageId(_codeTable)),
        ),
      );
      _styles = _styles.copyWith(align: styles.align, codeTable: _codeTable);
    }

    return bytes;
  }

  @override
  List<int> getStyles(PosStyles styles, {bool isKanji = false}) {
    final List<int> bytes = <int>[];
    if (styles.align != _styles.align) {
      bytes.addAll(
        latin1.encode(
          styles.align == PosAlign.left
              ? cAlignLeft
              : (styles.align == PosAlign.center ? cAlignCenter : cAlignRight),
        ),
      );
    }

    if (styles.bold != _styles.bold) {
      bytes.addAll(styles.bold ? cBoldOn.codeUnits : cBoldOff.codeUnits);
    }
    if (styles.turn90 != _styles.turn90) {
      bytes.addAll(styles.turn90 ? cTurn90On.codeUnits : cTurn90Off.codeUnits);
    }
    if (styles.reverse != _styles.reverse) {
      bytes.addAll(
        styles.reverse ? cReverseOn.codeUnits : cReverseOff.codeUnits,
      );
    }
    if (styles.underline != _styles.underline) {
      bytes.addAll(
        styles.underline ? cUnderline1dot.codeUnits : cUnderlineOff.codeUnits,
      );
    }

    // Set font
    if (styles.fontType != null && styles.fontType != _styles.fontType) {
      bytes.addAll(
        styles.fontType == PosFontType.fontB
            ? cFontB.codeUnits
            : cFontA.codeUnits,
      );
    } else if (_font != null && _font != _styles.fontType) {
      bytes.addAll(
        _font == PosFontType.fontB ? cFontB.codeUnits : cFontA.codeUnits,
      );
    }

    // Characters size
    if (styles.height.value != _styles.height.value ||
        styles.width.value != _styles.width.value) {
      bytes.addAll(
        Uint8List.fromList(
          List<int>.from(cSizeGSn.codeUnits)
            ..add(PosTextSize.decSize(styles.height, styles.width)),
        ),
      );
    }

    // Set Kanji mode
    if (isKanji) {
      bytes.addAll(cKanjiOn.codeUnits);
    } else {
      bytes.addAll(cKanjiOff.codeUnits);
    }

    // Set local code table
    if (styles.codeTable != null) {
      bytes.addAll(
        Uint8List.fromList(
          List<int>.from(cCodeTable.codeUnits)
            ..add(profile.getCodePageId(styles.codeTable)),
        ),
      );
    } else if (_codeTable != null) {
      bytes.addAll(
        Uint8List.fromList(
          List<int>.from(cCodeTable.codeUnits)
            ..add(profile.getCodePageId(_codeTable)),
        ),
      );
    }

    return bytes;
  }

  /// Print selected code table.
  ///
  /// If [codeTable] is null, global code table is used.
  /// If global code table is null, default printer code table is used.
  @override
  List<int> printCodeTable({String? codeTable}) {
    List<int> bytes = <int>[];
    bytes += cKanjiOff.codeUnits;

    if (codeTable != null) {
      bytes += Uint8List.fromList(
        List<int>.from(cCodeTable.codeUnits)
          ..add(
            profile.getCodePageId(codeTable),
          ),
      );
    }

    bytes += Uint8List.fromList(List<int>.generate(256, (int i) => i));

    // Back to initial code table
    setGlobalCodeTable(_codeTable);
    return bytes;
  }

  /// Beeps [n] times
  ///
  /// Beep [duration] could be between 50 and 450 ms.
  @override
  List<int> beep({
    int n = 3,
    PosBeepDuration duration = PosBeepDuration.beep450ms,
  }) {
    List<int> bytes = <int>[];
    if (n <= 0) {
      return <int>[];
    }

    int beepCount = n;
    if (beepCount > 9) {
      beepCount = 9;
    }

    bytes += Uint8List.fromList(
      List<int>.from(cBeep.codeUnits)
        ..addAll(
          <int>[
            beepCount,
            duration.value,
          ],
        ),
    );

    beep(n: n - 9, duration: duration);
    return bytes;
  }

  /// Open cash drawer
  @override
  List<int> openCashDrawer({PosDrawer pin = PosDrawer.pin2}) {
    List<int> bytes = <int>[];
    if (pin == PosDrawer.pin2) {
      bytes += cCashDrawerPin2.codeUnits;
    } else {
      bytes += cCashDrawerPin5.codeUnits;
    }
    return bytes;
  }
}
