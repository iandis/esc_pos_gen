part of 'pos_image.dart';

class _PosImageRaster extends _PosImage {
  const _PosImageRaster({
    required Image image,
    PosAlign align = PosAlign.center,
    this.highDensityHorizontal = true,
    this.highDensityVertical = true,
    this.imageFn = PosImageFn.bitImageRaster,
  }) : super(image: image, align: align);

  final bool highDensityHorizontal;
  final bool highDensityVertical;
  final PosImageFn imageFn;

  @override
  List<int> generate(Generator generator) {
    final List<int> bytes = <int>[];

    // Image alignment
    bytes.addAll(
      generator
          .getStyles(
            const PosStyles().copyWith(
              align: align,
            ),
          )
          .bytes,
    );

    final int widthPx = image.width;
    final int heightPx = image.height;
    final int widthBytes = (widthPx + 7) ~/ 8;
    final List<int> resterizedData = helpers.toRasterFormat(image);

    if (imageFn == PosImageFn.bitImageRaster) {
      // GS v 0
      final int densityByte =
          (highDensityVertical ? 0 : 1) + (highDensityHorizontal ? 0 : 2);

      final List<int> header = List<int>.from(cRasterImg2.codeUnits);
      header.add(densityByte); // m
      header.addAll(helpers.intLowHigh(widthBytes, 2)); // xL xH
      header.addAll(helpers.intLowHigh(heightPx, 2)); // yL yH
      bytes.addAll(
        List<int>.from(header)..addAll(resterizedData),
      );
    } else if (imageFn == PosImageFn.graphics) {
      // 'GS ( L' - FN_112 (Image data)
      final List<int> header1 = List<int>.from(cRasterImg.codeUnits);
      header1
          .addAll(helpers.intLowHigh(widthBytes * heightPx + 10, 2)); // pL pH
      header1.addAll(<int>[48, 112, 48]); // m=48, fn=112, a=48
      header1.addAll(<int>[1, 1]); // bx=1, by=1
      header1.addAll(<int>[49]); // c=49
      header1.addAll(helpers.intLowHigh(widthBytes, 2)); // xL xH
      header1.addAll(helpers.intLowHigh(heightPx, 2)); // yL yH
      bytes.addAll(
        List<int>.from(header1)..addAll(resterizedData),
      );

      // 'GS ( L' - FN_50 (Run print)
      final List<int> header2 = List<int>.from(cRasterImg.codeUnits);
      header2.addAll(<int>[2, 0]); // pL pH
      header2.addAll(<int>[48, 50]); // m fn[2,50]
      bytes.addAll(
        List<int>.from(header2),
      );
    }
    return bytes;
  }
}
