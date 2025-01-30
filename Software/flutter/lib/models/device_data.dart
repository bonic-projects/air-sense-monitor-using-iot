import 'dart:developer' as developer;

class EnvironmentData {
  final double aqi;
  final double temperature;
  final double humidity;

  EnvironmentData({
    required this.aqi,
    required this.temperature,
    required this.humidity,
  });

  factory EnvironmentData.fromMap(Map<String, dynamic> map) {
    developer.log('Creating EnvironmentData from map: $map');

    // Extract airquality data
    final airqualityMap = map['airquality'] as Map?;
    developer.log('Airquality Map: $airqualityMap');

    // Get weather from inside airquality
    final weatherMap = airqualityMap?['weather'] as Map?;
    developer.log('Weather Map: $weatherMap');

    // Parse values with null safety
    final aqi = airqualityMap?['Aqi']?.toString() ?? '0';
    final temp = weatherMap?['temperature']?.toString() ?? '0';
    final humidity = weatherMap?['humidity']?.toString() ?? '0';

    developer
        .log('Parsed values - AQI: $aqi, Temp: $temp, Humidity: $humidity');

    return EnvironmentData(
      aqi: double.parse(aqi),
      temperature: double.parse(temp),
      humidity: double.parse(humidity),
    );
  }
}
