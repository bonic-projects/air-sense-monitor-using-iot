// views/home_view.dart
import 'package:air_quality_sensor/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.black, // Set background to black
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'Environment Monitor',
              style: TextStyle(
                color: Colors.white, // White text for contrast
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white), // White icons
          ),
          body: Column(
            children: [
              if (model.showAlert)
                Container(
                  width: double.infinity,
                  color: Colors.red.shade900
                      .withOpacity(0.8), // Darker red for alert
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red.shade100, // Light red icon
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dangerous Air Quality!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade100, // Light red text
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Current AQI is ${model.aqi.toStringAsFixed(1)}. Please take necessary precautions.',
                              style: TextStyle(
                                color: Colors.red.shade100, // Light red text
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: model.hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 60, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${model.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      )
                    : model.isBusy
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white), // White spinner
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Loading data...',
                                  style: TextStyle(
                                    color: Colors.grey[400], // Light grey text
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Air Quality Section
                                  _buildHeader('Current Air Quality'),
                                  const SizedBox(height: 8),
                                  _buildAQICard(model.aqi),
                                  const SizedBox(height: 24),

                                  // Weather Section
                                  _buildHeader('Weather Conditions'),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildWeatherCard(
                                          'Temperature',
                                          '${model.temperature.toStringAsFixed(1)}°C',
                                          Icons.thermostat,
                                          _getTemperatureColor(
                                              model.temperature),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildWeatherCard(
                                          'Humidity',
                                          '${model.humidity.toStringAsFixed(1)}%',
                                          Icons.water_drop,
                                          _getHumidityColor(model.humidity),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Last Update Time
                                  const SizedBox(height: 24),
                                  Center(
                                    child: Text(
                                      'Last updated: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                        color:
                                            Colors.grey[400], // Light grey text
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white, // White text for contrast
      ),
    );
  }

  Widget _buildAQICard(double aqi) {
    return Card(
      elevation: 4,
      shadowColor: Colors.white.withOpacity(0.1), // Subtle shadow
      color: Colors.grey[900], // Dark grey card background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Air Quality Index',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white, // White text
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      aqi.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.air,
                  size: 48,
                  color: _getAQIColor(aqi),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: aqi / 500, // Assuming max AQI is 500
              backgroundColor:
                  Colors.grey[800], // Darker grey for progress background
              valueColor: AlwaysStoppedAnimation<Color>(_getAQIColor(aqi)),
            ),
            const SizedBox(height: 8),
            Text(
              _getAQIDescription(aqi),
              style: TextStyle(
                color: _getAQIColor(aqi),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shadowColor: Colors.white.withOpacity(0.1), // Subtle shadow
      color: Colors.grey[900], // Dark grey card background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400], // Light grey text
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAQIColor(double aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    if (aqi <= 300) return Colors.purple;
    return Colors.brown;
  }

  String _getAQIDescription(double aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive Groups';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  Color _getTemperatureColor(double temp) {
    if (temp < 10) return Colors.blue;
    if (temp < 20) return Colors.green;
    if (temp < 30) return Colors.orange;
    return Colors.red;
  }

  Color _getHumidityColor(double humidity) {
    if (humidity < 30) return Colors.orange;
    if (humidity < 60) return Colors.blue;
    return Colors.purple;
  }
}
