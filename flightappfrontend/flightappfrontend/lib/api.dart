//@dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:praneet/model.dart';
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;
import 'main.dart';


int maxAttempts = 5;
NavigatorState failureNavState;
onRetry(context) {
  if (failureNavState == null) {
    failureNavState = navigatorKeyMain.currentState;
    showDialog(
      context: navigatorKeyMain.currentContext,
      builder: (context) => Center(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
          child: Material(
            color: Colors.transparent,
            child: Text(
              'Check yout internet connection',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<FlightModel>> flightplan({String departure_city, String arrival_city, String date_time,context}) async {
  failureNavState = null;
  print('date time output ${date_time}');
  final http.Response response = await retry(
        () => http.post(
      Uri.parse('$server_url/flight-plan/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'departure_city': departure_city,
        'arrival_city': arrival_city,
        'departure_time':date_time,
      }),
    ),

  );
  failureNavState?.pop();
  print('reponse ${response.body}');
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;

    List<FlightModel> _flightlisting = data.map<FlightModel>((json)=>FlightModel.fromJson(json)).toList();

    return _flightlisting;

  } else {
    throw Exception('Server Failure');
  }
}