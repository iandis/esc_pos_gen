/*
 * esc_pos_utils
 * Created by Andrey U.
 * 
 * Copyright (c) 2019-2020. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

const String esc = '\x1B';
const String gs = '\x1D';
const String fs = '\x1C';

// Miscellaneous
const String cInit = '$esc@'; // Initialize printer
const String cBeep = '${esc}B'; // Beeper [count] [duration]

// Mech. Control
const String cCutFull = '${gs}V0'; // Full cut
const String cCutPart = '${gs}V1'; // Partial cut

// Character
const String cReverseOn =
    '${gs}B\x01'; // Turn white/black reverse print mode on
const String cReverseOff =
    '${gs}B\x00'; // Turn white/black reverse print mode off
const String cSizeGSn = '$gs!'; // Select character size [N]
const String cSizeESCn = '$esc!'; // Select character size [N]
const String cUnderlineOff = '$esc-\x00'; // Turns off underline mode
// Turns on underline mode (1-dot thick)
const String cUnderline1dot = '$esc-\x01';
// Turns on underline mode (2-dots thick)
const String cUnderline2dots = '$esc-\x02';
const String cBoldOn = '${esc}E\x01'; // Turn emphasized mode on
const String cBoldOff = '${esc}E\x00'; // Turn emphasized mode off
const String cFontA = '${esc}M\x00'; // Font A
const String cFontB = '${esc}M\x01'; // Font B
const String cTurn90On = '${esc}V\x01'; // Turn 90° clockwise rotation mode on
const String cTurn90Off = '${esc}V\x00'; // Turn 90° clockwise rotation mode off
const String cCodeTable = '${esc}t'; // Select character code table [N]
const String cKanjiOn = '$fs&'; // Select Kanji character mode
const String cKanjiOff = '$fs.'; // Cancel Kanji character mode

// Print Position
const String cAlignLeft = '${esc}a0'; // Left justification
const String cAlignCenter = '${esc}a1'; // Centered
const String cAlignRight = '${esc}a2'; // Right justification
const String cPos = '$esc\$'; // Set absolute print position [nL] [nH]

// Print
const String cFeedN = '${esc}d'; // Print and feed n lines [N]
const String cReverseFeedN = '${esc}e'; // Print and reverse feed n lines [N]

// Bit Image
const String cRasterImg = '$gs(L'; // Print image - raster bit format (graphics)
const String cRasterImg2 =
    '${gs}v0'; // Print image - raster bit format (bitImageRaster) [obsolete]
const String cBitImg = '$esc*'; // Print image - column format

// Barcode

// Select print position of HRI characters [N]
const String cBarcodeSelectPos = '${gs}H';
// Select font for HRI characters [N]
const String cBarcodeSelectFont = '${gs}f';
const String cBarcodeSetH = '${gs}h'; // Set barcode height [N]
const String cBarcodeSetW = '${gs}w'; // Set barcode width [N]
const String cBarcodePrint = '${gs}k'; // Print barcode

// Cash Drawer Open
const String cCashDrawerPin2 = '${esc}p030';
const String cCashDrawerPin5 = '${esc}p130';

// QR Code
const String cQrHeader = '$gs(k';
