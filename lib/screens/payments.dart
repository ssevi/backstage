import 'package:flutter/material.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Payments> {
  final DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments Page'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            const SizedBox(height: 20),
            Text(
              'Selected Payments page', // Display selected date
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
