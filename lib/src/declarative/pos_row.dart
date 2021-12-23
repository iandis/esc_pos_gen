import 'dart:typed_data';

import '../enums.dart';
import '../generator.dart';
import '../pos_column.dart';
import '../pos_styles.dart';
import 'helpers.dart' as helpers;
import 'pos_component.dart';

part 'pos_left_right_text.dart';
part 'pos_row_impl.dart';

abstract class PosRow implements PosComponent {
  /// Creates ESC/POS commands for printing a row.
  ///
  /// A row contains up to 12 columns. A column has a width between 1 and 12.
  /// Total width of columns in one row must be equal 12.
  const factory PosRow(
    List<PosColumn> columns,
  ) = _PosRow;

  /// Creates ESC/POS commands for creating a row of 2 texts
  /// aligned left and right.
  ///
  /// This is basically a [PosRow] having 2 [PosColumn]s for
  /// the texts
  ///
  /// * [leftTextStyles] defaults to `const PosStyles()`
  /// * [leftTextWidth] defaults to 6
  /// * [leftTextContainsChinese] defaults to `false`
  /// * [rightTextStyles] defaults to have [PosAlign.right]
  /// * [rightTextWidth] defaults to 6
  /// * [rightTextContainsChinese] defaults to `false`
  ///
  /// Total width ([leftTextWidth] + [rightTextWidth])
  /// must equals to 12.
  factory PosRow.leftRightText({
    required String leftText,
    Uint8List? leftTextEncoded,
    PosStyles leftTextStyles,
    bool leftTextContainsChinese,
    int leftTextWidth,
    required String rightText,
    Uint8List? rightTextEncoded,
    PosStyles rightTextStyles,
    bool rightTextContainsChinese,
    int rightTextWidth,
  }) = PosLeftRightText;
}
