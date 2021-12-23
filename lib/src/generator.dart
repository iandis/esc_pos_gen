/*
 * esc_pos_utils
 * Created by Andrey U.
 * 
 * Copyright (c) 2019-2020. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:convert';
import 'dart:typed_data' show Uint8List;

import 'capability_profile.dart';
import 'commands.dart';
import 'declarative/helpers.dart';
import 'enums.dart';
import 'pos_styles.dart';

part 'generator_impl.dart';

class Result {
  const Result({
    required this.styles,
    required this.bytes,
  });

  final PosStyles styles;
  final List<int> bytes;

  Result copyWith({
    PosStyles? styles,
    List<int>? bytes,
  }) {
    return Result(
      styles: styles ?? this.styles,
      bytes: bytes ?? this.bytes,
    );
  }
}

abstract class Generator {
  /// Creates a [Generator]
  ///
  /// [paperSize] and [profile] are required.
  ///
  /// [spaceBetweenRows] defaults to 5.
  factory Generator(
    PaperSize paperSize,
    CapabilityProfile profile, {
    int spaceBetweenRows,
  }) = _GeneratorImpl;

  /// Ticket config
  PaperSize get paperSize;

  int get spaceBetweenRows;

  CapabilityProfile get profile;

  int? get maxCharsPerLine;

  /// Global styles
  String? get codeTable;

  PosFontType? get font;

  /// Current styles
  PosStyles get styles;

  /// Clear the buffer and reset text styles
  List<int> getInitialStyles();

  void reset();

  /// Set global code table which will be used
  /// instead of the default printer's code table
  /// (even after resetting)
  Result getGlobalCodeTable(String? codeTable);

  /// Set global code table which will be used
  /// instead of the default printer's code table
  /// (even after resetting)
  void setGlobalCodeTable(String? codeTable);

  /// Set global font which will be used instead of the default printer's font
  /// (even after resetting)
  Result getGlobalFont(
    PosFontType? font, {
    int? maxCharsPerLine,
  });

  /// Set global font which will be used instead of the default printer's font
  /// (even after resetting)
  void setGlobalFont(
    PosFontType? font, {
    int? maxCharsPerLine,
  });

  Result getStyles(PosStyles styles, {bool isKanji = false});

  void setStyles(
    PosStyles styles, {
    bool isKanji = false,
  });

  /// Print selected code table.
  ///
  /// If [codeTable] is null, global code table is used.
  /// If global code table is null, default printer code table is used.
  List<int> printCodeTable({
    String? codeTable,
  });

  /// Beeps [n] times
  ///
  /// Beep [duration] could be between 50 and 450 ms.
  List<int> beep({
    int n = 3,
    PosBeepDuration duration = PosBeepDuration.beep450ms,
  });

  /// Open cash drawer
  List<int> openCashDrawer({PosDrawer pin = PosDrawer.pin2});
}
