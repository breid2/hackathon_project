import 'package:flutter/material.dart';

class DischargePlanPage extends StatefulWidget {
  const DischargePlanPage({super.key});

  @override
  State<DischargePlanPage> createState() => _DischargePlanPageState();
}

class _DischargePlanPageState extends State<DischargePlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discharge Plan"),
        ),
      body: Center()
    );
  }
}