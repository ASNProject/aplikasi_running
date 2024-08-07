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

import 'package:flutter/material.dart';

class ResultMobileScreen extends StatefulWidget {
  final String name;
  final String age;
  final String averageBPM;
  final String maxBPM;
  final String getTime;

  const ResultMobileScreen({
    super.key,
    required this.name,
    required this.age,
    required this.averageBPM,
    required this.maxBPM,
    required this.getTime,
  });

  @override
  State<ResultMobileScreen> createState() => _ResultMobileScreenState();
}

class _ResultMobileScreenState extends State<ResultMobileScreen> {
  double? averageBmp;
  double? maxBpm;

  @override
  Widget build(BuildContext context) {
    averageBmp = double.tryParse(widget.averageBPM);
    maxBpm = double.tryParse(widget.maxBPM);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            // Menampilkan background
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/result.png"),
                  fit: BoxFit.fill,
                  opacity: 0.4),
            ),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 40,
                  ),
                  child: Center(
                    child: Text(
                      'Ringkasan',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Menampilkan nama
                    const SizedBox(
                      width: 100,
                      child: Text(
                        'Nama',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ': ${widget.name}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    // Menampilkan Usia
                    const SizedBox(
                      width: 100,
                      child: Text(
                        'Usia',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ': ${widget.age} tahun',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                const Text(
                  'Waktu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // Menampilkan Timer
                Text(
                  widget.getTime,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  'Detak max',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // Menampilkan max BPM
                Text(
                  '${maxBpm?.round()} BPM',
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  'Detak rata-rata',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // Menampilkan rata-rata bpm
                Text(
                  '$averageBmp BPM',
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Center(
                  child: Text(
                    'Always keep your spirit for run !!!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
