import 'dart:async';
import 'package:aplikasi_running/models/heart_rate_data.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _heartRateRef =
  FirebaseDatabase.instance.ref().child('hearRateData');

  Stream<List<HeartRateData>> getHeartRateData() {
    return _heartRateRef.onValue.map((event) {
      final data = event.snapshot.value as List<dynamic>?;

      if (data == null) {
        return []; // Jika data kosong, kembalikan list kosong
      }

      final List<HeartRateData> heartRateList = data
          .where((entry) => entry != null) // Filter out null entries
          .map((entry) {
        final time = entry['time'];
        final bpm = entry['bpm'];

        // Periksa jika time atau bpm null, jika ya, berikan nilai default atau tangani kasus null
        if (time == null || bpm == null) {
          return HeartRateData(0, '0'); // Contoh memberikan nilai default 0
        }

        return HeartRateData(time as int, bpm );
      }).toList();

      return heartRateList;
    });
  }
}

// class HeartRateData {
//   final int time;
//   final int bpm;
//
//   HeartRateData(this.time, this.bpm);
// }
