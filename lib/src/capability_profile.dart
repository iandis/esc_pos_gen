// ignore_for_file: avoid_dynamic_calls

import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

List<Map<String, dynamic>> __printProfiles = <Map<String, dynamic>>[];
Map<String, dynamic> __printCapabilities = <String, dynamic>{};

class CodePage {
  CodePage(this.id, this.name);
  int id;
  String name;
}

class CapabilityProfile {
  CapabilityProfile._internal(
    this.name,
    this.codePages,
  );

  final String name;
  final List<CodePage> codePages;

  /// [ensureProfileLoaded]
  /// this method will cache the profile json into data which will
  /// speed up the next loop and searching profile
  static Future<void> ensureProfileLoaded({String? path}) async {
    /// check where this global capabilities is empty
    /// then load capabilities.json,
    /// else do nothing
    if (__printCapabilities.isEmpty == true) {
      final String content = await rootBundle.loadString(
        path ?? 'packages/esc_pos_gen/resources/capabilities.json',
      );
      final dynamic _capabilities = json.decode(content);
      __printCapabilities = Map<String, dynamic>.from(
        _capabilities as Map<dynamic, dynamic>,
      );

      _capabilities['profiles'].forEach((dynamic k, dynamic v) {
        __printProfiles.add(<String, dynamic>{
          'key': k,
          'vendor': v['vendor'] is String ? v['vendor'] : '',
          'name': v['name'] is String ? v['name'] : '',
          'description': v['description'] is String ? v['description'] : '',
        });
      });

      /// assert that the capabilities will be not empty
      assert(__printCapabilities.isNotEmpty);
    } else {
      assert(() {
        // ignore: avoid_print
        print('capabilities.length is already loaded');
        return true;
        // ignore: require_trailing_commas
      }());
    }
  }

  /// Public factory
  static Future<CapabilityProfile> load({String name = 'default'}) async {
    ///
    await ensureProfileLoaded();

    final dynamic profile = __printCapabilities['profiles'][name];

    if (profile == null) {
      throw Exception("The CapabilityProfile '$name' does not exist");
    }

    final List<CodePage> list = <CodePage>[];
    profile['codePages'].forEach((dynamic k, dynamic v) {
      list.add(CodePage(int.parse(k as String), v as String));
    });

    // Call the private constructor
    return CapabilityProfile._internal(name, list);
  }

  int getCodePageId(String? codePage) {
    return codePages.firstWhere(
      (CodePage cp) => cp.name == codePage,
      orElse: () {
        throw Exception(
          "Code Page '$codePage' isn't defined for this profile",
        );
      },
    ).id;
  }

  static Future<List<dynamic>> getAvailableProfiles() async {
    /// ensure the capabilities is not empty
    await ensureProfileLoaded();

    final dynamic _profiles = __printCapabilities['profiles'];

    final List<dynamic> res = <dynamic>[];

    _profiles.forEach((dynamic k, dynamic v) {
      res.add(<String, dynamic>{
        'key': k,
        'vendor': v['vendor'] is String ? v['vendor'] : '',
        'name': v['name'] is String ? v['name'] : '',
        'description': v['description'] is String ? v['description'] : '',
      });
    });

    return res;
  }
}
