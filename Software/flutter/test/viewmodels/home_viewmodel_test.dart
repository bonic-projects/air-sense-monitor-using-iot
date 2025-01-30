import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:air_quality_sensor/app/app.bottomsheets.dart';
import 'package:air_quality_sensor/app/app.locator.dart';
import 'package:air_quality_sensor/ui/common/app_strings.dart';
import 'package:air_quality_sensor/ui/views/home/home_viewmodel.dart';

import '../helpers/test_helpers.dart';

void main() {
  HomeViewModel getModel() => HomeViewModel();

  group('HomeViewmodelTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
