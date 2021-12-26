part of 'pos_row.dart';

abstract class PosLeftRightText implements PosRow {
  /// Creates ESC/POS commands for creating a row of 2 texts
  /// aligned left and right.
  ///
  /// This is basically a [PosRow] having 2 [PosColumn]s for
  /// the texts
  ///
  /// * [leftTextStyles] defaults to `PosStyles.defaults`
  /// * [leftTextWidth] defaults to 6
  /// * [leftTextContainsChinese] defaults to `false`
  /// * [rightTextStyles] defaults to `PosStyles.defaults` with [PosAlign.right]
  /// * [rightTextWidth] defaults to 6
  /// * [rightTextContainsChinese] defaults to `false`
  ///
  /// Total width ([leftTextWidth] + [rightTextWidth])
  /// must equals to 12.
  factory PosLeftRightText({
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
  }) = _PosLeftRightText;
}

class _PosLeftRightText extends _PosRow implements PosLeftRightText {
  _PosLeftRightText({
    required String leftText,
    Uint8List? leftTextEncoded,
    PosStyles leftTextStyles = const PosStyles.defaults(),
    bool leftTextContainsChinese = false,
    int leftTextWidth = 6,
    required String rightText,
    Uint8List? rightTextEncoded,
    PosStyles rightTextStyles = const PosStyles.defaults(align: PosAlign.right),
    bool rightTextContainsChinese = false,
    int rightTextWidth = 6,
  })  : assert(
          leftTextWidth + rightTextWidth == 12,
          'Total width (leftTextWidth + rightTextWidth) must equals to 12',
        ),
        super(<PosColumn>[
          PosColumn(
            text: leftText,
            textEncoded: leftTextEncoded,
            styles: leftTextStyles,
            containsChinese: leftTextContainsChinese,
            width: leftTextWidth,
          ),
          PosColumn(
            text: rightText,
            textEncoded: rightTextEncoded,
            styles: rightTextStyles,
            containsChinese: rightTextContainsChinese,
            width: rightTextWidth,
          ),
        ]);
}
