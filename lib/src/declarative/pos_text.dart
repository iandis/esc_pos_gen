import 'dart:typed_data';

import '../enums.dart';
import '../generator.dart';
import '../pos_styles.dart';
import 'helpers.dart' as helpers;
import 'pos_component.dart';

part 'pos_text_impl.dart';
part 'pos_text_encoded_impl.dart';

abstract class PosText implements PosComponent {
  /// Creates ESC/POS commands for printing text
  ///
  /// * [styles] defaults to have [PosAlign.left]
  ///
  /// * [linesAfter] defaults to 0
  const factory PosText(
    String data, {
    PosStyles styles,
    int linesAfter,
    bool containsChinese,
    int? maxCharsPerLine,
  }) = _PosText;

  /// Creates ESC/POS commands for printing encoded text
  const factory PosText.encoded(
    Uint8List textBytes, {
    PosStyles styles,
    int linesAfter,
    int? maxCharsPerLine,
  }) = _PosTextEncoded;

  /// Creates ESC/POS commands for printing bold text
  const factory PosText.bold(
    String data, {
    PosStyles styles,
    int linesAfter,
    bool containsChinese,
    int? maxCharsPerLine,
  }) = _PosText.bold;

  /// Creates ESC/POS commands for printing center-aligned text
  const factory PosText.center(
    String data, {
    PosStyles styles,
    int linesAfter,
    bool containsChinese,
    int? maxCharsPerLine,
  }) = _PosText.center;

  /// Creates ESC/POS commands for printing right-aligned text
  const factory PosText.right(
    String data, {
    PosStyles styles,
    int linesAfter,
    bool containsChinese,
    int? maxCharsPerLine,
  }) = _PosText.right;
}
