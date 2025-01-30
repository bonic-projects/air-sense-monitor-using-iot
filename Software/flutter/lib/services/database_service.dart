import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer' as developer;
import '../models/device_data.dart';

class DatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  Stream<EnvironmentData> getEnvironmentData() {
    return _dbRef.onValue.map((DatabaseEvent event) {
      final data = event.snapshot.value;
      developer.log('Raw Firebase Data: $data');

      if (data == null) {
        developer.log('Error: Firebase returned null data');
        throw Exception('No data available');
      }

      if (data is Map) {
        Map<String, dynamic> mappedData = Map<String, dynamic>.from(data);
        developer.log('Mapped Data: $mappedData');
        return EnvironmentData.fromMap(mappedData);
      }

      throw Exception('Data format is incorrect: ${data.runtimeType}');
    }).handleError((error) {
      developer.log('Error in Firebase Stream: $error');
      throw error;
    });
  }
}
