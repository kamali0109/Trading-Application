import 'package:flutter/material.dart';

class StepperDemo extends StatefulWidget {
  StepperDemo() : super();

  final String title = "Stepper Demo";

  @override
  StepperDemoState createState() => StepperDemoState();
}

class StepperDemoState extends State<StepperDemo> {
  //
  int current_step = 0;
  List<Step> steps = [
    Step(
      title: Text('Orderplaced'),
      content: Text('23/10/2024'),
      isActive: true,
    ),
    Step(
      title: Text(' Pending'),
      content: Text('24/10/2024'),
      isActive: true,
    ),
    Step(
      title: Text('Order Failed'),
      
      content: Text('25/10/2024'),
      state: StepState.complete,
      isActive: true,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
      // Body
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Theme(data: ThemeData( colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Color(0x665ac18e),
                  background:  Color(0x665ac18e),
                  secondary:  Color(0x665ac18e),
                ),),
          child: Card(
            child: Container(
              child: Stepper(
              
                currentStep: this.current_step,
                steps: steps,
                type: StepperType.vertical,
                onStepTapped: (step) {
                  setState(() {
                    current_step = step;
                  });
                },
                onStepContinue: () {
                  setState(() {
                    if (current_step < steps.length - 1) {
                      current_step = current_step + 1;
                    } else {
                      current_step = 0;
                    }
                  });
                },
                onStepCancel: () {
                  setState(() {
                    if (current_step > 0) {
                      current_step = current_step - 1;
                    } else {
                      current_step = 0;
                    }
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}