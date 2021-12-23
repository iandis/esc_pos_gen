import 'package:esc_pos_gen/esc_pos_gen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('is capabilities.isEmpty is completed', () {
    expect(printCapabilities.isEmpty, true);
  });
  test('is capabilities.isNotEmpty is completed', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await CapabilityProfile.ensureProfileLoaded();
    CapabilityProfile.load();
    // ignore: avoid_print
    print('capabilities.length ${printCapabilities.length}');
    expect(printCapabilities.isNotEmpty, true);
  });
}
