import 'package:esc_pos_gen/esc_pos_gen.dart';

Future<void> main() async {
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

  final List<int> bytes = paper.bytes;
}
