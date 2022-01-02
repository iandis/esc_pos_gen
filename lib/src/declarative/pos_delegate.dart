import '../generator.dart';
import 'pos_component.dart';

abstract class PosDelegate {
  const PosDelegate();

  const factory PosDelegate.builder({
    required PosComponent Function(Generator generator) builder,
  }) = _PosDelegateBuilder;

  PosComponent build(Generator generator);
}

class _PosDelegateBuilder extends PosDelegate {
  const _PosDelegateBuilder({
    required this.builder,
  });

  final PosComponent Function(Generator generator) builder;

  @override
  PosComponent build(Generator generator) => builder(generator);
}
