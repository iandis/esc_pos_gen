# esc_pos_gen

[![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)

Declarative-style ESC/POS commands for printing.

`Generator` class generates printing properties such as
`CapabilityProfile`, `PaperSize`, etc.

`PosComponent` classes generates bytes for printing ESC/POS commands.

Combine both to create a `Paper` object that can generate all commands from `PosComponent`s to bytes.

## Features

- 📝 Declarative-style (just like creating widgets)
- Tables printing using `PosRow`
- Text styling:
  - size, align, bold, reverse, underline, different fonts, turn 90°
- Print images
- Print barcodes
  - UPC-A, UPC-E, JAN13 (EAN13), JAN8 (EAN8), CODE39, ITF (Interleaved 2 of 5), CODABAR (NW-7), CODE128
- Paper cut (partial, full)
- Beeping (with different duration)
- Paper feed, reverse feed

**Note**: Your printer may not support some of the presented features (some styles, partial/full paper cutting, reverse feed, barcodes...).

## Generate a Paper

### Simple paper with styles:

```dart
List<int> generatePaper() {
  final CapabilityProfile profile = await CapabilityProfile.load();
  final Generator generator = Generator(
    PaperSize.mm58,
    profile,
  );

  final List<PosComponent> components = <PosComponent>[
    const PosText(
      'Bold Title',
      styles: PosStyles(
        bold: true,
        align: PosAlign.center,
      ),
    ),
    const PosText.right('Right Text'),
    const PosSeparator(),
    PosRow.leftRightText(
      leftText: 'Left Text',
      rightText: 'Right Text',
    ),
    for (int i = 1; i <= 10; i++)
      PosRow.leftRightText(
        leftText: 'Item $i',
        rightText: 'US\$ ${i * 10}',
      ),
    const PosSeparator(),
    const PosQRCode('QRCode#1'),
    const PosText('QR-Code'),
    const PosSeparator(),
    const PosFeed(1),
    const PosCut(),
  ];

  final Paper paper = Paper(
    generator: generator,
    components: components,
  );

  return paper.bytes;
}
```

### Print a table row:

```dart
PosRow([
    PosColumn(
      text: 'col3',
      width: 3,
      styles: PosStyles(
        align: PosAlign.center,
        underline: true,
      ),
    ),
    PosColumn(
      text: 'col6',
      width: 6,
      styles: PosStyles(
        align: PosAlign.center,
        underline: true,
      ),
    ),
    PosColumn(
      text: 'col3',
      width: 3,
      styles: PosStyles(
        align: PosAlign.center,
        underline: true,
      ),
    ),
]);
```

### Print an image:

This package implements 3 ESC/POS functions:

- `ESC *` - print in column format
- `GS v 0` - print in bit raster format (obsolete)
- `GS ( L` - print in bit raster format

Note that your printer may support only some of the above functions.

```dart
import 'dart:io';

import 'package:esc_pos_gen/esc_pos_gen.dart';
import 'package:image/image.dart';

final ByteData data = await rootBundle.load('assets/logo.png');
final Uint8List bytes = data.buffer.asUint8List();
final Image image = decodeImage(bytes);
// Using `ESC *`
PosImage(image: image);
// Using `GS v 0` (obsolete)
PosImage.raster(image: image);
// Using `GS ( L`
PosImage.raster(
  image: image,
  imageFn: PosImageFn.graphics,
);
```

### Print a Barcode:

```dart
final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
PosBarcode(Barcode.upcA(barData));
// or
// PosBarcode.upcA(barData);
```

### Print a QR Code:

Using native ESC/POS commands:

```dart
PosQRCode('example.com');
```

To print a QR Code as an image (if your printer doesn't support native commands), add [qr_flutter](https://pub.dev/packages/qr_flutter) and [path_provider](https://pub.dev/packages/path_provider) as a dependency in your `pubspec.yaml` file.

```dart
String qrData = "google.com";
const double qrSize = 200;
try {
  final uiImg = await QrPainter(
    data: qrData,
    version: QrVersions.auto,
    gapless: false,
  ).toImageData(qrSize);
  final dir = await getTemporaryDirectory();
  final pathName = '${dir.path}/qr_tmp.png';
  final qrFile = File(pathName);
  final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
  final img = decodeImage(imgFile.readAsBytesSync());

  return PosImage(image: img);
} catch (e) {
  print(e);
}
```

## Using Code Tables

Different printers support different sets of code tables. Some printer models are defined in `CapabilityProfile` class. So, if you want to change the default code table, it's important to choose the right profile:

```dart
// Xprinter XP-N160I
final profile = await CapabilityProfile.load('XP-N160I');
final generator = Generator(PaperSize.mm80, profile);
bytes += generator.setGlobalCodeTable('CP1252');
```

All available profiles can be retrieved by calling :

```dart
final profiles = await CapabilityProfile.getAvailableProfiles();
```

## How to Help

- Add a CapabilityProfile to support your printer's model. A new profile should be added to `resources/capabilities.json` file
- Test your printer and add it in the table: [Wifi/Network printer](https://github.com/andrey-ushakov/esc_pos_printer/blob/master/printers.md) or [Bluetooth printer](https://github.com/andrey-ushakov/esc_pos_bluetooth/blob/master/printers.md)
- Test and report bugs
- Share your ideas about what could be improved (code optimization, new features...)
