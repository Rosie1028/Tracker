import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../backend/backend_block.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  WorkoutScreenState createState() => WorkoutScreenState();
}

class WorkoutScreenState extends State<WorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _day = TextEditingController(text: 'Monday');
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _typeController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final backendBloc = BlocProvider.of<BackendBloc>(context);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDateSelector(context),
            const SizedBox(height: 10.0),
            _buildDateDisplay(),
            _buildTextFormField('Workout Type', 'Please enter some text', _typeController),
            _buildNumberFormField('Reps', 'Please enter a number', _repsController),
            _buildNumberFormField('Weight', 'Please enter a number', _weightController),
            _buildTimeFormField('Duration', 'Please enter a time', _durationController),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return TextButton(
      onPressed: () => _selectDate(context),
      child: const Text('Select date'),
    );
  }

  Widget _buildDateDisplay() {
    return Text(' ${DateFormat('yyyy-MM-dd').format(_date)}');
  }

  Widget _buildTextFormField(String label, String validationMessage, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }

  Widget _buildNumberFormField(String label, String validationMessage, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }

  Widget _buildTimeFormField(String label, String validationMessage, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.datetime,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final backendBloc = BlocProvider.of<BackendBloc>(context);
            backendBloc.postData(
              _day.text,
              _date,
              _typeController.text,
              _repsController.text,
              double.tryParse(_weightController.text) ?? 0.0,
              double.tryParse(_durationController.text) ?? 0.0,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
          }
        },
        child: const Text('Submit'),
      ),
    );
  }
}
