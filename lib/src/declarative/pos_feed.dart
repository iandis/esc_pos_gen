import 'dart:typed_data';

import '../commands.dart';
import '../generator.dart';
import 'pos_component.dart';
import 'pos_empty_lines.dart';

abstract class PosFeed implements PosComponent {
  /// Creates ESC/POS commands for skipping [numberOfLines] lines
  ///
  /// Similar to [PosEmptyLines] but uses an alternative command
  const factory PosFeed(
    int numberOfLines,
  ) = _PosFeed;

  /// Creates ESC/POS commands for reverse feeding for [numberOfLines] lines
  /// (if supported by the printer)
  const factory PosFeed.reverse(
    int numberOfLines,
  ) = _PosReverseFeed;
}

class _PosFeed implements PosFeed {
  const _PosFeed(this.numberOfLines);

  final int numberOfLines;

  @override
  List<int> generate(Generator generator) {
    final List<int> bytes = <int>[];
    if (numberOfLines >= 0 && numberOfLines <= 255) {
      bytes.addAll(
        Uint8List.fromList(
          List<int>.from(cFeedN.codeUnits)..add(numberOfLines),
        ),
      );
    }
    return bytes;
  }
}

class _PosReverseFeed implements PosFeed {
  const _PosReverseFeed(
    this.numberOfLines,
  );

  final int numberOfLines;

  @override
  List<int> generate(Generator generator) {
    return Uint8List.fromList(
      List<int>.from(cReverseFeedN.codeUnits)..add(numberOfLines),
    );
  }
}
