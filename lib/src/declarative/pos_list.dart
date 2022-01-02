import '../generator.dart';
import 'pos_component.dart';

abstract class PosList implements PosComponent {
  const factory PosList(
    List<PosComponent> components,
  ) = _PosList;

  const factory PosList.builder({
    required int count,
    required PosComponent Function(int index) builder,
  }) = _PosListBuilder;
}

class _PosList implements PosList {
  const _PosList(this.components);
  final List<PosComponent> components;

  @override
  List<int> generate(Generator generator) {
    final List<int> bytes = <int>[];
    for (final PosComponent component in components) {
      bytes.addAll(component.generate(generator));
    }
    return bytes;
  }
}

class _PosListBuilder implements PosList {
  const _PosListBuilder({
    required this.count,
    required this.builder,
  });

  final int count;
  final PosComponent Function(int index) builder;

  @override
  List<int> generate(Generator generator) {
    final List<int> bytes = <int>[];
    for (int i = 0; i < count; i++) {
      bytes.addAll(builder(i).generate(generator));
    }
    return bytes;
  }
}
