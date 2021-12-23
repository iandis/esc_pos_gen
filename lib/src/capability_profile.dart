/*
 * esc_pos_utils
 * Created by Andrey U.
 * 
 * Copyright (c) 2019-2020. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:convert' show json;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

final List<Map<String, dynamic>> printProfiles = <Map<String, dynamic>>[];
final Map<String, dynamic> printCapabilities = <String, dynamic>{};

class CodePage {
  CodePage(this.id, this.name);
  int id;
  String name;
}

class CapabilityProfile {
  CapabilityProfile._internal(this.name, this.codePages);

  /// [ensureProfileLoaded]
  /// this method will cache the profile json into data which will
  /// speed up the next loop and searching profile
  static Future<void> ensureProfileLoaded({String? path}) async {
    /// check where this global capabilities is empty
    /// then load capabilities.json
    /// else do nothing
    if (printCapabilities.isEmpty) {
      final String content = await rootBundle.loadString(
        path ?? 'packages/esc_pos_gen/resources/capabilities.json',
      );
      final Map<String, dynamic> _capabilities =
          json.decode(content) as Map<String, dynamic>;
      printCapabilities.addAll(_capabilities);

      final Map<String, dynamic>? profiles =
          _capabilities['profiles'] as Map<String, dynamic>?;

      profiles?.forEach(
        (String k, dynamic v) {
          printProfiles.add(
            <String, dynamic>{
              'key': k,
              'vendor': v is Map && v['vendor'] is String ? v['vendor'] : '',
              'name': v is Map && v['name'] is String ? v['name'] : '',
              'description': v is Map && v['description'] is String
                  ? v['description']
                  : '',
            },
          );
        },
      );

      /// assert that the capabilities will be not empty
      assert(printCapabilities.isNotEmpty);
    } else {
      if (kDebugMode || kProfileMode) {
        // ignore: avoid_print
        print('Capabilities is already loaded');
      }
    }
  }

  /// Public factory
  static Future<CapabilityProfile> load({String name = 'default'}) async {
    ///
    await ensureProfileLoaded();

    final Map<String, dynamic>? profiles =
        printCapabilities['profiles'] as Map<String, dynamic>?;

    final Map<String, dynamic>? profile =
        profiles?[name] as Map<String, dynamic>?;

    if (profile == null) {
      throw Exception("The CapabilityProfile '$name' does not exist");
    }

    final List<CodePage> list = <CodePage>[];
    (profile['codePages'] as Map<String, dynamic>?)?.forEach(
      (String k, dynamic v) {
        list.add(CodePage(int.parse(k), v as String));
      },
    );

    // Call the private constructor
    return CapabilityProfile._internal(name, list);
  }

  final String name;
  final List<CodePage> codePages;

  int getCodePageId(String? codePage) {
    return codePages
        .firstWhere(
          (CodePage cp) => cp.name == codePage,
          orElse: () => throw Exception(
            "Code Page '$codePage' isn't defined for this profile",
          ),
        )
        .id;
  }

  static Future<List<dynamic>> getAvailableProfiles() async {
    /// ensure the capabilities is not empty
    await ensureProfileLoaded();

    final Map<String, dynamic> _profiles =
        printCapabilities['profiles'] as Map<String, dynamic>;

    final List<dynamic> res = <dynamic>[];

    _profiles.forEach(
      (String k, dynamic v) {
        res.add(
          <String, dynamic>{
            'key': k,
            'vendor': v is Map && v['vendor'] is String ? v['vendor'] : '',
            'name': v is Map && v['name'] is String ? v['name'] : '',
            'description':
                v is Map && v['description'] is String ? v['description'] : '',
          },
        );
      },
    );

    return res;
  }
}
