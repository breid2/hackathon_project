import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarIcon extends StatelessWidget {
  final DateTime date;

  const CalendarIcon({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
  top: 10,
  left: 0,
  right: 0,
  child: Container(
    height: 40, // Increased height for the red container
    decoration: const BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
    ),
  ),
),
Positioned(
  top: 20, // Adjusted top position for the month text
  left: 0,
  right: 0,
  child: Center(
    child: Text(
      DateFormat('MMM').format(date).toUpperCase(), // Month
      style: const TextStyle(
        fontSize: 20, // Ensure the font size fits within the new height
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ),
),

          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                date.day.toString(), // Day
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                DateFormat('HH:mm').format(date), // Time
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
