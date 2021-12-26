import 'dart:convert';

import 'gbk_maps.dart';

GBKBytesCodec gbkBytes = GBKBytesCodec();

Map<int, String> _gbkCodeToChar = <int, String>{};
Map<String, int> _charToGbkCode = <String, int>{};

class GBKBytesCodec extends Encoding {
  @override
  Converter<List<int>, String> get decoder => const GBKBytesDecoder();

  @override
  Converter<String, List<int>> get encoder => const GBKBytesEncoder();

  @override
  String get name => 'gbk_bytes';

  GBKBytesCodec() {
    //initialize gbk code maps
    _charToGbkCode = json_char_to_gbk;
    json_gbk_to_char.forEach((String sInt, String sChar) {
      _gbkCodeToChar[int.parse(sInt, radix: 16)] = sChar;
    });
  }
}

class GBKBytesEncoder extends Converter<String, List<int>> {
  const GBKBytesEncoder();

  @override
  List<int> convert(String input) {
    return gbkBytesEncode(input);
  }
}

List<int> gbkBytesEncode(String input) {
  final List<int> ret = <int>[];
  for (final int charCode in input.codeUnits) {
    final String char = String.fromCharCode(charCode);
    final int? gbkCode = _charToGbkCode[char];
    if (gbkCode != null) {
      //split to two bytes
      final int a = (gbkCode >> 8) & 0xff;
      final int b = gbkCode & 0xff;
      ret.add(a);
      ret.add(b);
    } else {
      ret.add(charCode);
    }
  }
  return ret;
}

class GBKBytesDecoder extends Converter<List<int>, String> {
  const GBKBytesDecoder();

  @override
  String convert(List<int> input) {
    return gbkBytesDecode(input);
  }
}

String gbkBytesDecode(List<int> input) {
  String ret = '';
  final List<int> combined = <int>[];
  int id = 0;
  while (id < input.length) {
    int charCode = input[id];
    id++;
    if (charCode < 0x80 || charCode > 0xff || id == input.length) {
      combined.add(charCode);
    } else {
      charCode = (charCode << 8) + (input[id] & 0xff);
      id++;
      combined.add(charCode);
    }
  }
  for (final int charCode in combined) {
    final String? char = _gbkCodeToChar[charCode];
    if (char != null) {
      ret += char;
    } else {
      ret += String.fromCharCode(charCode);
    }
    //print(ret);
  }
  return ret;
}
