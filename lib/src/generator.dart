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
import 'declarative/helpers.dart' as helpers;
import 'enums.dart';
import 'pos_styles.dart';

part 'generator_impl.dart';

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
  List<int> reset();

  /// Set global code table which will be used
  /// instead of the default printer's code table
  /// (even after resetting)
  List<int> setGlobalCodeTable(String? codeTable);

  /// Set global font which will be used instead of the default printer's font
  /// (even after resetting)
  List<int> setGlobalFont(
    PosFontType? font, {
    int? maxCharsPerLine,
  });

  List<int> setGlobalStyles(
    PosStyles styles, {
    bool isKanji = false,
  });

  List<int> getStyles(
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
