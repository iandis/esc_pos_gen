/*
 * esc_pos_utils
 * Created by Andrey U.
 * 
 * Copyright (c) 2019-2020. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

enum PosAlign { left, center, right }
enum PosCutMode { full, partial }
enum PosFontType { fontA, fontB }
enum PosDrawer { pin2, pin5 }

/// Choose image printing function
/// bitImageRaster: GS v 0 (obsolete)
/// graphics: GS ( L
enum PosImageFn { bitImageRaster, graphics }

class PosTextSize {
  const PosTextSize._internal(this.value);
  final int value;
  static const PosTextSize size1 = PosTextSize._internal(1);
  static const PosTextSize size2 = PosTextSize._internal(2);
  static const PosTextSize size3 = PosTextSize._internal(3);
  static const PosTextSize size4 = PosTextSize._internal(4);
  static const PosTextSize size5 = PosTextSize._internal(5);
  static const PosTextSize size6 = PosTextSize._internal(6);
  static const PosTextSize size7 = PosTextSize._internal(7);
  static const PosTextSize size8 = PosTextSize._internal(8);

  static int decSize(PosTextSize height, PosTextSize width) =>
      16 * (width.value - 1) + (height.value - 1);
}

class PaperSize {
  const PaperSize._internal(this.value);

  final int value;

  static const PaperSize mm58 = PaperSize._internal(1);
  static const PaperSize mm72 = PaperSize._internal(2);
  static const PaperSize mm80 = PaperSize._internal(3);

  int get width {
    if (value == PaperSize.mm58.value) {
      return 384;
    } else if (value == PaperSize.mm72.value) {
      return 512;
    } else {
      return 576;
    }
    // value == PaperSize.mm58.value ? 384 : 558;
  }
}

class PosBeepDuration {
  const PosBeepDuration._internal(this.value);

  final int value;

  static const PosBeepDuration beep50ms = PosBeepDuration._internal(1);
  static const PosBeepDuration beep100ms = PosBeepDuration._internal(2);
  static const PosBeepDuration beep150ms = PosBeepDuration._internal(3);
  static const PosBeepDuration beep200ms = PosBeepDuration._internal(4);
  static const PosBeepDuration beep250ms = PosBeepDuration._internal(5);
  static const PosBeepDuration beep300ms = PosBeepDuration._internal(6);
  static const PosBeepDuration beep350ms = PosBeepDuration._internal(7);
  static const PosBeepDuration beep400ms = PosBeepDuration._internal(8);
  static const PosBeepDuration beep450ms = PosBeepDuration._internal(9);
}
