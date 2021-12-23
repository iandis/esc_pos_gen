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
  List<int> getInitialStyles() {
    final List<int> bytes = <int>[];
    bytes.addAll(cInit.codeUnits);
    bytes.addAll(getGlobalCodeTable(_codeTable).bytes);
    bytes.addAll(getGlobalFont(_font).bytes);
    return bytes;
  }

  @override
  void reset() {
    _styles = const PosStyles();
    setGlobalCodeTable(_codeTable);
    setGlobalFont(_font);
  }

  /// Set global code table which will be used
  /// instead of the default printer's code table
  /// (even after resetting)
  @override
  Result getGlobalCodeTable(String? codeTable) {
    final List<int> bytes = <int>[];
    final String? _codeTable = codeTable;
    final PosStyles _styles = this._styles;
    Result result = Result(
      styles: _styles,
      bytes: bytes,
    );

    if (_codeTable != null) {
      bytes.addAll(
        Uint8List.fromList(
          List<int>.from(cCodeTable.codeUnits)
            ..add(
              profile.getCodePageId(_codeTable),
            ),
        ),
      );
      result = result.copyWith(
        styles: _styles.copyWith(
          codeTable: _codeTable,
        ),
      );
    }
    return result;
  }

  /// Set global code table which will be used
  /// instead of the default printer's code table
  /// (even after resetting)
  @override
  void setGlobalCodeTable(String? codeTable) {
    _codeTable = codeTable;
    if (codeTable != null) {
      _styles = _styles.copyWith(codeTable: codeTable);
    }
  }

  /// Set global font which will be used instead of the default printer's font
  /// (even after resetting)
  @override
  Result getGlobalFont(PosFontType? font, {int? maxCharsPerLine}) {
    final List<int> bytes = <int>[];
    final PosStyles _styles = this._styles;
    Result result = Result(
      styles: _styles,
      bytes: bytes,
    );

    if (font != null) {
      bytes.addAll(
        font == PosFontType.fontB ? cFontB.codeUnits : cFontA.codeUnits,
      );
      result = result.copyWith(
        styles: _styles.copyWith(
          fontType: font,
        ),
      );
    }
    return result;
  }

  /// Set global font which will be used instead of the default printer's font
  /// (even after resetting)
  @override
  void setGlobalFont(PosFontType? font, {int? maxCharsPerLine}) {
    _font = font;
    if (font != null) {
      _maxCharsPerLine = maxCharsPerLine ??
          getMaxCharsPerLine(
            paperSize: paperSize,
            font: font,
          );
      _styles = _styles.copyWith(fontType: font);
    }
  }

  @override
  Result getStyles(PosStyles styles, {bool isKanji = false}) {
    final List<int> bytes = <int>[];
    final PosStyles _styles = this._styles;

    Result result = Result(
      styles: _styles,
      bytes: bytes,
    );

    if (styles.align != _styles.align) {
      bytes.addAll(
        latin1.encode(
          styles.align == PosAlign.left
              ? cAlignLeft
              : (styles.align == PosAlign.center ? cAlignCenter : cAlignRight),
        ),
      );
      result = result.copyWith(
        styles: _styles.copyWith(align: styles.align),
      );
    }

    if (styles.bold != _styles.bold) {
      bytes.addAll(
        styles.bold ? cBoldOn.codeUnits : cBoldOff.codeUnits,
      );
      result = result.copyWith(
        styles: _styles.copyWith(bold: styles.bold),
      );
    }
    if (styles.turn90 != _styles.turn90) {
      bytes.addAll(
        styles.turn90 ? cTurn90On.codeUnits : cTurn90Off.codeUnits,
      );
      result = result.copyWith(
        styles: _styles.copyWith(turn90: styles.turn90),
      );
    }
    if (styles.reverse != _styles.reverse) {
      bytes.addAll(
        styles.reverse ? cReverseOn.codeUnits : cReverseOff.codeUnits,
      );
      result = result.copyWith(
        styles: _styles.copyWith(reverse: styles.reverse),
      );
    }
    if (styles.underline != _styles.underline) {
      bytes.addAll(
        styles.underline ? cUnderline1dot.codeUnits : cUnderlineOff.codeUnits,
      );
      result = result.copyWith(
        styles: _styles.copyWith(underline: styles.underline),
      );
    }

    // Set font
    if (styles.fontType != null && styles.fontType != _styles.fontType) {
      bytes.addAll(
        styles.fontType == PosFontType.fontB
            ? cFontB.codeUnits
            : cFontA.codeUnits,
      );
      result = result.copyWith(
        styles: _styles.copyWith(fontType: styles.fontType),
      );
    } else if (_font != null && _font != _styles.fontType) {
      bytes.addAll(
        _font == PosFontType.fontB ? cFontB.codeUnits : cFontA.codeUnits,
      );
      result = result.copyWith(
        styles: _styles.copyWith(fontType: _font),
      );
    }

    // Characters size
    if (styles.height.value != _styles.height.value ||
        styles.width.value != _styles.width.value) {
      bytes.addAll(
        Uint8List.fromList(
          List<int>.from(cSizeGSn.codeUnits)
            ..add(
              PosTextSize.decSize(styles.height, styles.width),
            ),
        ),
      );
      result = result.copyWith(
        styles: _styles.copyWith(
          height: styles.height,
          width: styles.width,
        ),
      );
    }

    // Set Kanji mode
    if (isKanji) {
      bytes.addAll(
        cKanjiOn.codeUnits,
      );
    } else {
      bytes.addAll(
        cKanjiOff.codeUnits,
      );
    }

    // Set local code table
    if (styles.codeTable != null) {
      bytes.addAll(
        Uint8List.fromList(
          List<int>.from(cCodeTable.codeUnits)
            ..add(
              profile.getCodePageId(styles.codeTable),
            ),
        ),
      );
      result = result.copyWith(
        styles: _styles.copyWith(
          align: styles.align,
          codeTable: styles.codeTable,
        ),
      );
    } else if (_codeTable != null) {
      bytes.addAll(
        Uint8List.fromList(
          List<int>.from(cCodeTable.codeUnits)
            ..add(profile.getCodePageId(_codeTable)),
        ),
      );
      result = result.copyWith(
        styles: _styles.copyWith(
          align: styles.align,
          codeTable: _codeTable,
        ),
      );
    }

    return result;
  }

  @override
  void setStyles(PosStyles styles, {bool isKanji = false}) {
    if (styles.align != _styles.align) {
      _styles = _styles.copyWith(align: styles.align);
    }

    if (styles.bold != _styles.bold) {
      _styles = _styles.copyWith(bold: styles.bold);
    }
    if (styles.turn90 != _styles.turn90) {
      _styles = _styles.copyWith(turn90: styles.turn90);
    }
    if (styles.reverse != _styles.reverse) {
      _styles = _styles.copyWith(reverse: styles.reverse);
    }
    if (styles.underline != _styles.underline) {
      _styles = _styles.copyWith(underline: styles.underline);
    }

    // Set font
    if (styles.fontType != null && styles.fontType != _styles.fontType) {
      _styles = _styles.copyWith(fontType: styles.fontType);
    } else if (_font != null && _font != _styles.fontType) {
      _styles = _styles.copyWith(fontType: _font);
    }

    // Characters size
    if (styles.height.value != _styles.height.value ||
        styles.width.value != _styles.width.value) {
      _styles = _styles.copyWith(height: styles.height, width: styles.width);
    }

    // Set local code table
    if (styles.codeTable != null) {
      _styles =
          _styles.copyWith(align: styles.align, codeTable: styles.codeTable);
    } else if (_codeTable != null) {
      _styles = _styles.copyWith(align: styles.align, codeTable: _codeTable);
    }
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
