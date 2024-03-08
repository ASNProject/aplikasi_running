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

import 'package:aplikasi_running/cores/routers/app_route_constants.dart';
import 'package:aplikasi_running/features/features.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouterConfiguration {
  static GoRouter returnRouter(bool isAuth) {
    GoRouter router = GoRouter(
        routes: [
          GoRoute(
            name: AppRouteConstants.formDataScreen,
            path: '/',
            builder: (context, state) {
              return const FormDataMobileScreen();
            },
          ),
          GoRoute(
            name: AppRouteConstants.dashboardScreen,
            path: AppRouteConstants.dashboardScreen,
            builder: (context, state) {
              return DashboardMobileScreen(
                name: state.params['name'] as String,
                age: state.params['age'] as String,
              );
            },
          ),
          GoRoute(
            name: AppRouteConstants.resultScreen,
            path: AppRouteConstants.resultScreen,
            builder: (context, state) {
              String average = state.queryParams['averageBPM'] as String;
              String maxBPM = state.queryParams['maxBPM'] as String;
              String getTime = state.queryParams['getTime'] as String;
              return ResultMobileScreen(
                name: state.params['name'] as String,
                age: state.params['age'] as String,
                averageBPM: average,
                maxBPM: maxBPM,
                getTime: getTime,
              );
            },
          ),
        ],
        errorBuilder: (context, state) {
          return const Scaffold(
            body: Center(
              child: Text('Halaman tidak ditemukan'),
            ),
          );
        });
    return router;
  }
}
