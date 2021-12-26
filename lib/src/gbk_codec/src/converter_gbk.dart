import 'dart:convert';

import 'gbk_maps.dart';

GBKCodec gbk = GBKCodec();

Map<int, String> _gbkCodeToChar = <int, String>{};
Map<String, int> _charToGbkCode = <String, int>{};

class GBKCodec extends Encoding {
  @override
  Converter<List<int>, String> get decoder => const GBKDecoder();

  @override
  Converter<String, List<int>> get encoder => const GBKEncoder();

  @override
  String get name => 'gbk';

  GBKCodec() {
    //initialize gbk code maps
    _charToGbkCode = json_char_to_gbk;
    json_gbk_to_char.forEach((String sInt, String sChar) {
      _gbkCodeToChar[int.parse(sInt, radix: 16)] = sChar;
    });
  }
}

class GBKEncoder extends Converter<String, List<int>> {
  const GBKEncoder();

  @override
  List<int> convert(String input) {
    return gbkEncode(input);
  }
}

List<int> gbkEncode(String input) {
  final List<int> ret = <int>[];
  for (final int charCode in input.codeUnits) {
    final String char = String.fromCharCode(charCode);
    final int? gbkCode = _charToGbkCode[char];
    if (gbkCode != null) {
      ret.add(gbkCode);
    } else {
      ret.add(charCode);
    }
  }
  return ret;
}

class GBKDecoder extends Converter<List<int>, String> {
  const GBKDecoder();

  @override
  String convert(List<int> input) {
    return gbkDecode(input);
  }
}

String gbkDecode(List<int> input) {
  String ret = '';
  /*
  List<int> combined =  List<int>();
  int id= 0;
  while(id<input.length) {
      int charCode = input[id];
      id ++;
      if (charCode < 0x80 || charCode > 0xffff || id == input.length) {
        combined.add(charCode);
      } else {
        charCode = (charCode << 8) + input[id];
        id ++;
        combined.add(charCode);
      }
  }
  */
  for (final int charCode in input) {
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
