import 'package:flutter/material.dart';
import 'package:hackathon_project/components/button.dart'; 

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final feedbackTextController = TextEditingController();

  // Function to handle the submission of feedback
  void submitFeedback() {
    final String feedback = feedbackTextController.text;

    // handle feedback to server
    //print('Submitted Feedback: $feedback');

    // confirmation messate
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Thank you for your feedback!')),
    );

    feedbackTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Feedback text field
            TextFormField(
              controller: feedbackTextController,
              maxLines: 5, // Increase maxLines for better text input for feedback
              decoration: InputDecoration(
                hintText: 'Enter your feedback here...', border: OutlineInputBorder(), ), ),
            const SizedBox(height: 20),

            // Submit button
            MyButton(
              onTap: submitFeedback,
              text: 'Submit Feedback',
            ),
          ],
        ),
      ),
    );
  }
}