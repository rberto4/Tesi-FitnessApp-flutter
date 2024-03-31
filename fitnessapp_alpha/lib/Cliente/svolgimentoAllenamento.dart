import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:flutter/material.dart';


class svolgimentoAllenamento extends StatefulWidget {

  late Allenamento allenamento;

  svolgimentoAllenamento({super.key, required this.allenamento});

  @override
  State<svolgimentoAllenamento> createState() => _svolgimentoAllenamentoState(this.allenamento);
}

class _svolgimentoAllenamentoState extends State<svolgimentoAllenamento> {
  late Allenamento allenamento;

  _svolgimentoAllenamentoState(this.allenamento);
   int activeStep = 0;
  StepperType stepperType = StepperType.vertical;

  createSteps() {
    return [
      Step(
        title: const Text('Account'),
        content: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
            ),
          ],
        ),
        isActive: activeStep >= 0,
        state: activeStep >= 1 ? StepState.complete : StepState.disabled,
      ),
      Step(
        title: const Text('Indirizzo'),
        content: Column(
          children: <Widget>[
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Indirizzo di spedizione'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'CAP'),
            ),
          ],
        ),
        isActive: activeStep >= 0,
        state: activeStep >= 0 ? StepState.complete : StepState.disabled,
      ),
    ];
  }

  onTapped(int step) {
    setState(() => activeStep = step);
  }

  onContinued() {
    activeStep < 2 ? setState(() => activeStep += 1) : null;
  }

  onCancel() {
    activeStep > 0 ? setState(() => activeStep -= 1) : null;
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true,),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              type: stepperType,
              physics: const ScrollPhysics(),
              currentStep: activeStep,
              onStepTapped: (step) => onTapped(step),
              onStepContinue: onContinued,
              onStepCancel: onCancel,
              steps: createSteps(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: switchStepsType,
        child: const Icon(Icons.list),
      ),
    
    );
  }
}