import 'package:flutter_test/flutter_test.dart';
import 'package:air_quality_sensor/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('DatabaseServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
