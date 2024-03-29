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
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  late Stream<List<HeartRateData>> heartRateStream;
  late Timer _timer;
  int _secondsElapsed = 0;
  bool _isTimerRunning = true;
  String geTime = '';

  @override
  void initState() {
    super.initState();
    final firebaseService = FirebaseService();
    heartRateStream = firebaseService.getHeartRateData();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      _updateTimer,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<List<HeartRateData>>(
            stream: heartRateStream,
            builder: (context, snapshot) {
              int bpmMax = 220 - int.parse(widget.age);
              if (snapshot.hasData) {
                // Calculate average bpm
                int totalBPM =
                    snapshot.data!.fold(0, (prev, e) => prev + e.bpm);
                double averageBPM = totalBPM / snapshot.data!.length;
                // Calculate max bpm
                int maxBPM = snapshot.data!
                    .fold(0, (prev, e) => prev > e.bpm ? prev : e.bpm);
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
                    SizedBox(
                      height: 200,
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset('assets/images/hearrate.png'),
                            ),
                          ),
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
                                LineSeries<HeartRateData, int>(
                                  dataSource: snapshot.data,
                                  xValueMapper: (HeartRateData heartRate, _) =>
                                      heartRate.time,
                                  yValueMapper: (HeartRateData heartRate, _) =>
                                      heartRate.bpm,
                                  color: Colors.amber,
                                ),
                                LineSeries<HeartRateData, int>(
                                  dataSource: List.generate(
                                      snapshot.data!.length,
                                      (index) => HeartRateData(
                                          snapshot.data![index].time, bpmMax)),
                                  // Data dengan nilai BPM konstan 100
                                  xValueMapper: (HeartRateData heartRate, _) =>
                                      heartRate.time,
                                  yValueMapper: (HeartRateData heartRate, _) =>
                                      heartRate.bpm,
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Level ${_buildDecisionTreeMethod(
                        bpmMax,
                        snapshot.data!.last.bpm,
                      )}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll<Color>(
                                  Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          GoRouter.of(context).pushReplacementNamed(
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
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  void _updateTimer(Timer timer) {
    if (_isTimerRunning) {
      setState(() {
        _secondsElapsed++;
      });
    }
  }

  void _stopTimer() {
    setState(() {
      _isTimerRunning = false;
      geTime = _formatTime(_secondsElapsed);
    });
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String hourStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hourStr:$minutesStr:$secondsStr';
  }

  int _buildDecisionTreeMethod(
    int maxHr,
    int hr,
  ) {
    int decisionTree(double percentage) {
      if (percentage < 60) {
        return 1; // Level 1
      } else if (percentage < 70) {
        return 2; // Level 2
      } else if (percentage < 80) {
        return 3; // Level 3
      } else if (percentage < 90) {
        return 4; // Level 4
      } else {
        return 5; // Level 5
      }
    }

    int calculateLevel(int hr, int max) {
      double percentage = (hr / max) * 100;

      if (percentage < 50) {
        return 0; // Heart rate below 50% of MaxHR
      } else {
        return decisionTree(percentage);
      }
    }

    int level = calculateLevel(hr, maxHr);
    return level;
  }
}
