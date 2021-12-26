part of 'pos_image.dart';

class _PosImage implements PosImage {
  const _PosImage({
    required this.image,
    this.align = PosAlign.center,
  });

  final Image image;
  final PosAlign align;

  @override
  List<int> generate(Generator generator) {
    final List<int> bytes = <int>[];

    // Image alignment
    bytes.addAll(
      generator.getStyles(
        const PosStyles().copyWith(
          align: align,
        ),
      ),
    );

    // make a copy
    final Image image = Image.from(this.image);

    invert(image);
    flip(image, Flip.horizontal);
    final Image imageRotated = copyRotate(image, 270);

    const int lineHeight = 3; // highDensityVertical ? 3 : 1;
    final List<List<int>> blobs = helpers.toColumnFormat(
      imageRotated,
      lineHeight * 8,
    );

    // Compress according to line density
    // Line height contains 8 or 24 pixels of src image
    // Each blobs[i] contains greyscale bytes [0-255]
    // const int pxPerLine = 24 ~/ lineHeight;
    for (int blobInd = 0; blobInd < blobs.length; blobInd++) {
      blobs[blobInd] = helpers.packBitsIntoBytes(blobs[blobInd]);
    }

    final int heightPx = imageRotated.height;
    const int densityByte = 33;

    final List<int> header = List<int>.from(cBitImg.codeUnits);
    header.add(densityByte);
    header.addAll(helpers.intLowHigh(heightPx, 2));

    // Adjust line spacing (for 16-unit line feeds):
    // ESC 3 0x10 (HEX: 0x1b 0x33 0x10)
    bytes.addAll(const <int>[27, 51, 16]);
    for (int i = 0; i < blobs.length; ++i) {
      bytes.addAll(
        List<int>.from(header)
          ..addAll(blobs[i])
          ..addAll('\n'.codeUnits),
      );
    }
    // Reset line spacing: ESC 2 (HEX: 0x1b 0x32)
    return bytes..addAll(const <int>[27, 50]);
  }
}
