import 'dart:typed_data';
import '../capability_profile.dart';
import '../commands.dart';
import '../enums.dart';
import '../generator.dart';
import '../pos_styles.dart';

/// The base class for generating ESC/POS commands
/// for creating components such as text, image, barcode, etc
/// that will be printed on an ESC/POS printer.
abstract class PosComponent {
  /// Creates ESC/POS commands from raw bytes
  ///
  /// This will create a [Uint8List] from [bytes]
  const factory PosComponent(
    List<int> bytes, {
    bool isKanji,
  }) = _RawBytesComponent;

  /// Generates ESC/POS commands based on [generator]'s
  /// [CapabilityProfile], [PaperSize], [PosStyles], etc.
  List<int> generate(Generator generator);
}

class _RawBytesComponent implements PosComponent {
  const _RawBytesComponent(
    this.bytes, {
    this.isKanji = false,
  });

  final List<int> bytes;
  final bool isKanji;

  @override
  List<int> generate(Generator generator) {
    final List<int> bytes = <int>[];
    if (!isKanji) {
      bytes.addAll(cKanjiOff.codeUnits);
    }
    return bytes..addAll(Uint8List.fromList(bytes));
  }
}