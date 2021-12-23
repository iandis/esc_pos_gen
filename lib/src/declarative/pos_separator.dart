import '../generator.dart';
import 'helpers.dart' as helpers;
import 'pos_component.dart';
import 'pos_text.dart';

abstract class PosSeparator implements PosComponent {
  /// Creates ESC/POS commands for printing full width separator
  ///
  /// * [character] the character to be printed for the separator.
  /// defaults to `"-"` (without double quotes)
  ///
  /// * [length] if null, then it will be adjusted according to
  /// the paper width
  ///
  /// * [linesAfter] defaults to 0.
  const factory PosSeparator({
    String character,
    int? length,
    int linesAfter,
  }) = _PosSeparator;
}

class _PosSeparator implements PosSeparator {
  const _PosSeparator({
    this.character = '-',
    this.length,
    this.linesAfter = 0,
  });

  final String character;
  final int? length;
  final int linesAfter;

  @override
  List<int> generate(Generator generator) {
    final int n = length ??
        generator.maxCharsPerLine ??
        helpers.getMaxCharsPerLine(
          paperSize: generator.paperSize,
          font: generator.styles.fontType,
        );

    final String character1 = character.length == 1 ? character : character[0];

    return PosText(
      List<String>.filled(n, character1).join(),
      linesAfter: linesAfter,
    ).generate(generator);
  }
}
