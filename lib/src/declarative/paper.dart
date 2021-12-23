import 'dart:collection' show UnmodifiableListView;

import '../generator.dart';
import 'pos_component.dart';

abstract class Paper {
  /// Creates a [Paper] capable of creating ESC/POS commands
  /// based on its [generator] and its [components].
  const factory Paper({
    required Generator generator,
    required List<PosComponent> components,
  }) = _Paper;

  /// Returns bytes of generated ESC/POS commands
  /// 
  /// `Read-only`
  List<int> get bytes;
}

class _Paper implements Paper {
  const _Paper({
    required this.generator,
    required this.components,
  });

  final Generator generator;
  final List<PosComponent> components;

  @override
  List<int> get bytes {
    final List<int> bytes = <int>[];
    for (final PosComponent component in components) {
      bytes.addAll(component.generate(generator));
    }
    return UnmodifiableListView<int>(bytes);
  }
}
