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

import 'package:aplikasi_running/cores/routers/routes.dart';
import 'package:aplikasi_running/models/heart_rate_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardMobileScreen extends StatefulWidget {
  final String name;
  final String age;
  const DashboardMobileScreen({
    super.key,
    required this.name,
    required this.age,
  });

  @override
  State<DashboardMobileScreen> createState() => _DashboardMobileScreenState();
}

class _DashboardMobileScreenState extends State<DashboardMobileScreen> {
  final List<HeartRateData> heartRate = [
    HeartRateData(1, 123),
    HeartRateData(2, 145),
    HeartRateData(3, 124),
    HeartRateData(4, 132),
    HeartRateData(5, 165),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: Text(
                    'Mulai Lari',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Text(
                'Time: 00:00:00',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Heart Rate',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            dataSource: heartRate,
                            xValueMapper: (HeartRateData heartRate, _) =>
                                heartRate.time,
                            yValueMapper: (HeartRateData heartRate, _) =>
                                heartRate.bpm,
                            color: Colors.amber,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'BPM',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                '152',
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 32,
              ),
              const Text(
                'Your level run now',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Level 1',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                        const MaterialStatePropertyAll<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                    );
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
          ),
        ),
      ),
    );
  }
}
