import '../commands.dart';
import '../enums.dart';
import '../generator.dart';
import 'helpers.dart' as helpers;
import 'pos_component.dart';

abstract class PosCut implements PosComponent {
  /// Creates ESC/POS commands for cutting the paper
  ///
  /// [mode] is used to define the full or partial cut
  /// (if supported by the priner). defaults to [PosCutMode.full]
  const factory PosCut({
    PosCutMode mode,
  }) = _PosCut;
}

class _PosCut implements PosCut {
  const _PosCut({
    this.mode = PosCutMode.full,
  });

  final PosCutMode mode;

  @override
  List<int> generate(Generator generator) {
    final List<int> bytes = <int>[];
    bytes.addAll(
      helpers.emptyLines(5),
    );
    if (mode == PosCutMode.partial) {
      bytes.addAll(cCutPart.codeUnits);
    } else {
      bytes.addAll(cCutFull.codeUnits);
    }
    return bytes;
  }
}
