import 'package:image/image.dart';

import '../commands.dart';
import '../enums.dart';
import '../generator.dart';
import '../pos_styles.dart';
import 'helpers.dart' as helpers;
import 'pos_component.dart';

part 'pos_image_impl.dart';
part 'pos_image_raster_impl.dart';

/// ## PosImage
/// ESC/POS command generator for printing image
/// using (ESC *) or (GS v 0) command.
///
/// ### Examples
/// For printing image using (ESC *):
/// ```dart
/// ...
/// final PosImage imageToPrint = PosImage(
///   image: imageSource,
/// );
/// ...
/// ```
///
/// For printing image raster (using (GS v 0)):
/// ```dart
/// ...
/// final PosImage imageToPrint = PosImage.raster(
///   image: imageSource,
/// );
/// ...
/// ```
abstract class PosImage implements PosComponent {
  /// Creates ESC/POS commands for printing image
  /// using (ESC *) command
  ///
  /// * [image] is an instanse of class from
  /// [Image library](https://pub.dev/packages/image)
  ///
  /// * [align] defaults to [PosAlign.center]
  const factory PosImage({
    required Image image,
    PosAlign align,
  }) = _PosImage;

  /// Creates a ESC/POS command for printing image
  /// using (GS v 0) obsolete command
  ///
  /// * [image] is an instanse of class from
  /// [Image library](https://pub.dev/packages/image)
  ///
  /// * [align] defaults to [PosAlign.center]
  ///
  /// * [highDensityHorizontal] defaults to `true`
  ///
  /// * [highDensityVertical] defaults to `true`
  ///
  /// * [imageFn] defaults to [PosImageFn.bitImageRaster]
  const factory PosImage.raster({
    required Image image,
    PosAlign align,
    bool highDensityHorizontal,
    bool highDensityVertical,
    PosImageFn imageFn,
  }) = _PosImageRaster;
}
