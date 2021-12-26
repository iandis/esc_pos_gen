import '../generator.dart';
import 'pos_component.dart';

abstract class PosListComponent implements PosComponent {
  const factory PosListComponent(
    List<PosComponent> components,
  ) = _PosListComponent;

  const factory PosListComponent.builder({
    required int count,
    required PosComponent Function(int index) builder,
  }) = _PosListComponentBuilder;
}

class _PosListComponent implements PosListComponent {
  const _PosListComponent(this.components);
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

class _PosListComponentBuilder implements PosListComponent {
  const _PosListComponentBuilder({
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
