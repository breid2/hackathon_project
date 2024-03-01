// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Make sure this import path is correct

class DischargeProgressPage extends StatefulWidget {
  final String user;
  const DischargeProgressPage({
    super.key,
    required this.user,
  });
  
  @override
  _DischargeProgressPageState createState() => _DischargeProgressPageState();
}

class _DischargeProgressPageState extends State<DischargeProgressPage> {
  double _progress = 0.4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discharge Progress'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularPercentIndicator(
              animation: false,
              animationDuration: 450,
              radius: 150,
              lineWidth: 20, 
              percent: _progress,
              progressColor: Colors.blue[800],
              backgroundColor: Colors.blue.shade100,
              circularStrokeCap: CircularStrokeCap.round,
              center: Text('${(_progress * 100).toInt()}%', style: const TextStyle(fontSize: 50))
            ),
            LinearPercentIndicator(
              animation: false,
              animationDuration: 450,
              lineHeight: 40,
              percent: _progress,
              progressColor: Colors.blue[800],
              backgroundColor: Colors.blue.shade100,
              barRadius: const Radius.circular(22),
            ),
            const Text('Adjust Progress: '),
            Slider(
              value: _progress,
              thumbColor: Colors.yellow[700],
              activeColor: Colors.yellow[700],
              onChanged: (newProgress) {
                setState(() {
                  _progress = newProgress;
                });
              },
              min: 0.0,
              max: 1.0,
            ),
          ],
        )),
    );
  }
}

