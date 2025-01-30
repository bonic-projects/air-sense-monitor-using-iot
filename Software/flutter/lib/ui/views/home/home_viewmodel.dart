import 'package:air_quality_sensor/app/app.bottomsheets.dart';
import 'package:air_quality_sensor/app/app.dialogs.dart';
import 'package:air_quality_sensor/app/app.locator.dart';
import 'package:air_quality_sensor/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import '../../../models/device_data.dart';
import '../../../services/alert_service.dart';
import '../../../services/database_service.dart';
import 'dart:developer' as developer;

class HomeViewModel extends StreamViewModel<EnvironmentData> {
  final _firebaseService = locator<DatabaseService>();
  final _alertService = locator<AlertService>();
  bool _isHighAQI = false;
  @override
  Stream<EnvironmentData> get stream => _firebaseService.getEnvironmentData();

  @override
  void onData(EnvironmentData? data) {
    super.onData(data);
    _checkAQIAlert(data?.aqi ?? 0);
    developer.log('HomeViewModel received data: AQI=${data?.aqi}, '
        'Temp=${data?.temperature}, '
        'Humidity=${data?.humidity}');
  }

  void _checkAQIAlert(double aqi) {
    if (aqi > 200 && !_isHighAQI) {
      _isHighAQI = true;
      _alertService.showAQIAlert(aqi);
    } else if (aqi <= 200) {
      _isHighAQI = false;
    }
  }

  bool get showAlert => _isHighAQI;
  double get aqi => data?.aqi ?? 0.0;
  double get temperature => data?.temperature ?? 0.0;
  double get humidity => data?.humidity ?? 0.0;
}
