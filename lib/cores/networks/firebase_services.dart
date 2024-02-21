// Copyright 2024 ariefsetyonugroho
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:aplikasi_running/models/models.dart';
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

      final List<HeartRateData> heartRateList = data.map((entry) {
        final time = entry['time'];
        final bpm = entry['bpm'];

        // Periksa jika time atau bpm null, jika ya, berikan nilai default atau tangani kasus null
        if (time == null || bpm == null) {
          return HeartRateData(0, 0); // Contoh memberikan nilai default 0
        }

        return HeartRateData(time as int, bpm as int);
      }).toList();

      return heartRateList;
    });
  }
}
