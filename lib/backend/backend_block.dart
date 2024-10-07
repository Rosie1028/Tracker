import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class BackendBloc extends Cubit<String> {
  BackendBloc() : super('');

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:5001/api/workouts'));
    if (response.statusCode == 200) {
      emit(response.body);
    } else {
      emit('Failed to fetch data');
    }
  }

  Future<void> postData(String day, DateTime date, String type, String reps, double weight,
      double duration) async {
    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:5001/api/workouts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'day': day,
        'date': DateFormat('yyyy-MM-dd').format(date),
        'tipe': type,
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
