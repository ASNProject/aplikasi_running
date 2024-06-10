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
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class FormDataMobileScreen extends StatefulWidget {
  const FormDataMobileScreen({super.key});

  @override
  State<FormDataMobileScreen> createState() => _FormDataMobileScreenState();
}

class _FormDataMobileScreenState extends State<FormDataMobileScreen> {
  // Membuat initialisasi
  late String name;
  late String age;

  @override
  void initState() {
    super.initState();
    name = '';
    age = '';
  }

  // Program untuk menghapus data dari firebase
  Future<void> _deleteDataFromFirebase() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('hearRateData');
      await ref.remove();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // Membuat body form aplikasi
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Menampilkan background
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/just_keep_running.png"),
                fit: BoxFit.fill,
                opacity: 0.4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                // Menampilkan input form
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60.0),
                      child: Center(
                        child: Text(
                          'Masukkan Data Diri',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            'Nama',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            'Usia',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            onChanged: (value) {
                              setState(() {
                                age = value;
                              });
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
                // Menampilkan Button Save & Go
                Positioned(
                  bottom: 60.0,
                  left: 40,
                  right: 40,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll<Color>(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      // Ketika button Save and Go ditekan
                      onPressed: (name.isNotEmpty && age.isNotEmpty)
                          ? () async {
                        // Pertama memanggil penghapusan firebase
                              await _deleteDataFromFirebase();
                              // Mengarahkan tampilan ke dashboard screen
                              GoRouter.of(context).pushNamed(
                                  // Mengirim konstanta yang diperlukan di dashboard screen seperti name dan age
                                  AppRouteConstants.dashboardScreen,
                                  params: {
                                    'name': name,
                                    'age': age,
                                  });
                            }
                          : null,
                      child: const Text(
                        'Save & Go',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
