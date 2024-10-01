import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class BackendBloc extends Cubit<String> {
  BackendBloc() : super('');

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://api.sheety.co/71a928192913e9628d4d7159cceee299/workoutTracker/hoja1'));
    if (response.statusCode == 200) {
      emit(response.body);
    } else {
      emit('Failed to fetch data');
    }
  }

  Future<void> postData(DateTime date, String type, String reps, double weight, double duration) async {
    final response = await http.post(
      Uri.parse('https://api.sheety.co/71a928192913e9628d4d7159cceee299/workoutTracker/hoja1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'date': DateFormat('yyyy-MM-dd').format(date),
        'type': type,
        'reps': reps,
        'weight': weight,
        'duration': duration,
      }),
    );
    if (response.statusCode == 200) {
      emit(response.body);
    } else {
      emit('Failed to post data');
    }
  } 
}