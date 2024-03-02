// pages/date_of_discharge_page.dart
import 'package:flutter/material.dart';
import 'package:hackathon_project/components/CalendarIcon.dart';

class DateOfDischargePage extends StatefulWidget {
  const DateOfDischargePage({super.key});

  @override
  State<DateOfDischargePage> createState() => _DateOfDischargePageState();
}

class _DateOfDischargePageState extends State<DateOfDischargePage> {
  final dateOfDischarge = DateTime.parse('2024-07-20 08:08:04Z'); // reference

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expected Date of Discharge'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CalendarIcon(date: dateOfDischarge),
            // ... other widgets if needed ...
          ],
        ),
      ),
    );
  }
}
