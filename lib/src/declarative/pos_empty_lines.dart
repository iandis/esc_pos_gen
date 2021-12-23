import '../generator.dart';
import 'helpers.dart' as helpers;
import 'pos_component.dart';
import 'pos_feed.dart';

abstract class PosEmptyLines implements PosComponent {
  /// Creates ESC/POS commands for skipping [numberOfLines] lines
  ///
  /// Similar to [PosFeed] but uses an alternative command
  const factory PosEmptyLines(
    int numberOfLines,
  ) = _PosEmptyLines;
}

class _PosEmptyLines implements PosEmptyLines {
  const _PosEmptyLines(this.numberOfLines);

  final int numberOfLines;

  @override
  List<int> generate(Generator generator) {
    return helpers.emptyLines(numberOfLines);
  }
}
