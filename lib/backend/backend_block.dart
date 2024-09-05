import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

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
}