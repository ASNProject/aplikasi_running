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

import 'package:aplikasi_running/cores/networks/firebase_services.dart';
import 'package:aplikasi_running/cores/routers/app_route_constants.dart';
import 'package:aplikasi_running/models/heart_rate_data.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:aplikasi_running/models/utils.dart';

class DashboardMobileScreen extends StatefulWidget {
  final String name;
  final String age;
  final String? timer;

  const DashboardMobileScreen({
    super.key,
    required this.name,
    required this.age,
    this.timer,
  });

  @override
  State<DashboardMobileScreen> createState() => _DashboardMobileScreenState();
}

class _DashboardMobileScreenState extends State<DashboardMobileScreen> {
  // Membuat inisialisasi
  late Stream<List<HeartRateData>> heartRateStream;
  late Timer _timer;
  int _secondsElapsed = 0;
  bool _isTimerRunning = true;
  String geTime = '';

  // Membuat data percentage bpm
  final List<double> percentages = [
    59.0,
    57.0,
    56.0,
    54.0,
    52.0,
    50.0,
    69.0,
    67.0,
    66.0,
    64.0,
    62.0,
    60.0,
    79.0,
    77.0,
    76.0,
    74.0,
    72.0,
    70.0,
    89.0,
    87.0,
    86.0,
    84.0,
    82.0,
    80.0,
    99.0,
    97.0,
    96.0,
    94.0,
    92.0,
    90.0,
  ];

  // Membuat data levels
  final List<double> levels = [
    1,
    5,
    1,
    1,
    1,
    1,
    2,
    2,
    2,
    2,
    2,
    2,
    3,
    3,
    3,
    3,
    3,
    3,
    4,
    4,
    4,
    4,
    4,
    4,
    5,
    5,
    5,
    5,
    5,
    5,
  ];

  DecisionTreeClassifier? classifier;

  @override
  void initState() {
    super.initState();
    final firebaseService = FirebaseService();
    heartRateStream = firebaseService.getHeartRateData();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      _updateTimer,
    );
    // Menjalankan training model
    _trainModel();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Membuat code untuk melalukan training model
  void _trainModel() {
    final data = DataFrame.fromSeries([
      Series('percentages', percentages),
      Series('level', levels),
    ]);
    classifier = DecisionTreeClassifier(data, 'level');
  }

  // Program decision tree untuk menentukan level
  double _buildDecisionThreeMethods(double maxHr, double hr) {
    if (classifier == null) {
      return 0;
    }
    double percentage = (hr / maxHr) * 100;

    final input = DataFrame([
      [percentage]
    ], header: [
      'percentages'
    ]);

    final prediction = classifier!.predict(input);

    // Ensure prediction is not empty
    if (prediction.rows.isEmpty || prediction.rows.first.isEmpty) {
      return 0;
    }

    final predictedLevel = prediction.rows.first.first.toString();

    return double.tryParse(predictedLevel) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    // Membuat body aplikasi
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // Memanggil data dari firebase
          child: StreamBuilder<List<HeartRateData>>(
            stream: heartRateStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 200.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 16,
                        ),
                        Text('Mohon menuggu sedang melakukan sinkronisasi data')
                      ],
                    ),
                  ),
                );
              }

              // Mengolah data firebase
              final heartRateData = snapshot.data!;
              double bpmMax = 220 - double.parse(widget.age);
              if (heartRateData.isNotEmpty) {
                // Calculate average bpm
                double totalBPM = snapshot.data!
                    .fold(0, (prev, e) => prev + double.parse(e.bpm));
                double averageBPM = totalBPM / snapshot.data!.length;
                // Calculate max bpm
                double maxBPM = snapshot.data!.fold(
                    0,
                    (prev, e) => prev > double.parse(e.bpm)
                        ? prev
                        : double.parse(e.bpm));
                // Cek level menggunakan decision tree
                double ceklevel = _buildDecisionThreeMethod(
                    bpmMax, double.parse(snapshot.data!.last.bpm));
                int level = ceklevel.toInt();

                if (double.parse(snapshot.data!.last.bpm) >= bpmMax) {
                  Future.delayed(Duration.zero, () {
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Peringatan!',
                        message:
                            'HeartRate anda melebihi batas bpmMax, Silahkan istirahat terlebih dahulu!.',
                        contentType: ContentType.failure,
                      ),
                    );

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  });
                }

                // Membuat tampilan screen
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(
                        child: Text(
                          'Mulai Lari',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // Menjalankan Timer
                    Text(
                      'Time: ${_formatTime(_secondsElapsed)}',
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Heart Rate',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child:
                                      Image.asset('assets/images/hearrate.png'),
                                ),
                              ),
                              // Menampilkan grafik data
                              Expanded(
                                child: SfCartesianChart(
                                  primaryXAxis: const NumericAxis(
                                    title: AxisTitle(
                                      text: 'Time',
                                      textStyle: TextStyle(fontSize: 8),
                                    ),
                                  ),
                                  primaryYAxis: const NumericAxis(
                                    title: AxisTitle(
                                      text: 'BPM',
                                      textStyle: TextStyle(fontSize: 8),
                                    ),
                                  ),
                                  series: <CartesianSeries>[
                                    // Menampilkan data realtime
                                    LineSeries<HeartRateData, int>(
                                      dataSource: snapshot.data,
                                      xValueMapper:
                                          (HeartRateData heartRate, _) =>
                                              heartRate.time,
                                      yValueMapper:
                                          (HeartRateData heartRate, _) =>
                                              double.parse(heartRate.bpm),
                                      color: Colors.amber,
                                    ),
                                    // Menampilkan data max bpm
                                    LineSeries<HeartRateData, int>(
                                      dataSource: List.generate(
                                          snapshot.data!.length,
                                          (index) => HeartRateData(
                                              snapshot.data![index].time,
                                              bpmMax.toString())),
                                      // Data dengan nilai BPM konstan 100
                                      xValueMapper:
                                          (HeartRateData heartRate, _) =>
                                              heartRate.time,
                                      yValueMapper:
                                          (HeartRateData heartRate, _) =>
                                              double.parse(heartRate.bpm),
                                      color: Colors
                                          .red, // Ganti warna sesuai kebutuhan
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'BPM',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        // Menampilkan data bpm terakhir yang dikirim
                        Text(
                          snapshot.data!.last.bpm.toString(),
                          style: const TextStyle(
                              fontSize: 60, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        const Text(
                          'Your level run now',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        // Menampilkan level
                        Text(
                          'Level $level',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        // Tombol pindah halaman ke result screen
                        SizedBox(
                          height: 50,
                          width: 200,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  const WidgetStatePropertyAll<Color>(
                                      Colors.blue),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              // Membuka screen result screen
                              GoRouter.of(context).pushReplacementNamed(
                                  // Mengirim parameter ke result screen seperti nama, age, average bpm, max bpm, getTime,
                                  AppRouteConstants.resultScreen,
                                  params: {
                                    'name': widget.name,
                                    'age': widget.age,
                                  },
                                  queryParams: {
                                    'averageBPM': averageBPM.toStringAsFixed(3),
                                    'maxBPM': maxBPM.toString(),
                                    'getTime': _formatTime(_secondsElapsed),
                                  });

                              _stopTimer();
                            },
                            child: const Text(
                              'END',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Error: '
                    '${_buildDecisionThreeMethods(0, 0)}'
                    '');
              }
              return const Text('tidak ada data');
            },
          ),
        ),
      ),
    );
  }

  // Program update Timer
  void _updateTimer(Timer timer) {
    if (_isTimerRunning) {
      setState(() {
        _secondsElapsed++;
      });
    }
  }

  // Program Stop Timer
  void _stopTimer() {
    setState(() {
      _isTimerRunning = false;
      geTime = _formatTime(_secondsElapsed);
    });
  }

  // Format Timer
  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String hourStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hourStr:$minutesStr:$secondsStr';
  }
}
