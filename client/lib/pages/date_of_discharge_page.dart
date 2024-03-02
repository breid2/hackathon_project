import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:hackathon_project/components/calendar_icon.dart';


class DateOfDischargePage extends StatefulWidget {
  const DateOfDischargePage({super.key});

  @override
  State<DateOfDischargePage> createState() => _DateOfDischargePageState();
}

class _DateOfDischargePageState extends State<DateOfDischargePage> {
  final dateOfDischarge = DateTime.parse('2024-07-20 20:18:04Z'); // reference
  // DateTime dateOfDischarge = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expected Date of Discharge')
      ),
      body: 
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(child: Text(DateFormat('EEEE').format(dateOfDischarge.toLocal()))),
              Text(DateFormat.yMMMMd('en_US').format(dateOfDischarge.toLocal())),
              Text(DateFormat('hh:mm aaa v').format(dateOfDischarge.toLocal())),
            ],
         )
        )
    );
  }
}