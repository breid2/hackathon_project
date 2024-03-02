import 'package:flutter/material.dart';

class StepperScreen extends StatefulWidget {
  const StepperScreen({super.key});

  @override
  _StepperScreenState createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  int currentStep = 0;
  final firstName = TextEditingController();
  bool isCompleted = false;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Discharge'),
        centerTitle: true,
      ),
      body: 
        Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.blue)
        ), 
        child: Stepper(
          //type: StepperType.horizontal,
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: () {
            final isLastStep = currentStep == getSteps().length - 1;
            if (isLastStep){
              print('Completed');
              isCompleted = true;
              // send data or finish task 
            }
            else{
              setState(() => currentStep < getSteps().length - 1 
                ? currentStep += 1 : null);
            }
            
          },
          onStepTapped: (step) => setState(() => currentStep = step),
          onStepCancel: () {
            setState(() => currentStep > 0 ? currentStep -= 1 : null);
          },
         controlsBuilder: (context, controlsDetails) {
            final isLastStep = currentStep == getSteps().length - 1;
            return Container(
              margin: const EdgeInsets.only(top: 50),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: controlsDetails.onStepContinue,
                      child: Text(isLastStep ? 'Finish' : 'Next'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (currentStep != 0 || (currentStep == getSteps().length))
                    // ignore: avoid_print
                    SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: controlsDetails.onStepCancel,
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
              ),
            );
          },
        ),
      )
    );
  }

  // Other Stepper properties and children can be added here

  List<Step> getSteps() => [
    Step(
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,
      title: const Text('Account'),
      content: Column(children: <Widget>[
        TextFormField(
          controller: firstName,
          decoration: const InputDecoration(labelText: 'First Name'),
        )
      ],),
    ),
    Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: const Text('Before Surgery'),
      content: Container(),
    ),
    Step(
      state: currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 2,
      title: const Text('After Surgery'),
      content: Container(),
    ),
    Step(
      state: currentStep > 3 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 3,
      title: const Text('At Home'),
      content: Container(),
    ),
    Step(
      state: currentStep > 4 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 4,
      title: const Text('Completed'),
      content: Container(),
    ),
  ];
}
