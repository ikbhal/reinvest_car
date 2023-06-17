import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Car {
  final int id;
  final int loanDuration;
  int monthsRemaining=0;
  int earnings=0;
  int loan=0;
  final int downPayment;
  final int onRoadPrice;
  final int monthNumber;

  Car({
    required this.id,
    required this.loanDuration,
    required this.downPayment,
    required this.onRoadPrice,
    required this.monthNumber,
  }) {
    monthsRemaining = loanDuration;
    earnings = 0;
    loan = 0;
  }

   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loanDuration': loanDuration,
      'monthsRemaining': monthsRemaining,
      'earnings': earnings,
      'loan': loan,
      'downPayment': downPayment,
      'onRoadPrice': onRoadPrice,
      'monthNumber': monthNumber,
    };
  }
}

class CarInvestApp extends StatefulWidget {
  @override
  _CarInvestAppState createState() => _CarInvestAppState();
}

class _CarInvestAppState extends State<CarInvestApp> {

  final TextEditingController investWaitMonthsController = TextEditingController(text:'24');
  final TextEditingController earningController = TextEditingController(text:'10000');
  final TextEditingController loanDurationController = TextEditingController(text:'60');
  List<Car> cars = [];
  String result = '';

  void calculateReinvest() {
    // final int investWaitInMonths = 24; //convert to text field 
    final int investWaitInMonths = int.parse(investWaitMonthsController.text);
    final int monthlyEarnings = int.parse(earningController.text);
``
    const int initialOnRoadPrice = 391000;
    const int downPayment = 71000;
    // int loanDuration = int.parse(loanDurationController.text); // 60 default
    const loanDuration = 60; // 5 years
    const int monthlyEmi = 9300;

    int vid = 1;
    int totalEarnings = 0;

    cars = [
      Car(
        id: vid++,
        loanDuration: loanDuration,
        downPayment: downPayment,
        onRoadPrice: initialOnRoadPrice,
        monthNumber: 1,
      )
    ];

    for (int monthNumber = 1; monthNumber < investWaitInMonths; monthNumber++) {
      totalEarnings += monthlyEarnings * cars.length;

      final List<Car> newCars = [];
      final int carsPurchased = totalEarnings ~/ downPayment;
      totalEarnings %= downPayment;

      if (carsPurchased > 0) {
        for (int i = 0; i < carsPurchased; i++) {
          final newCar = Car(
            id: vid++,
            loanDuration: loanDuration,
            downPayment: downPayment,
            onRoadPrice: initialOnRoadPrice,
            monthNumber: monthNumber,
          );
          
          newCar.loan = newCar.onRoadPrice - newCar.downPayment;
          newCars.add(newCar);
        }
      }

      cars.removeWhere((car) => car.monthsRemaining < 1);
      for (final car in cars) {
        if (car.monthsRemaining > 1) {
          car.monthsRemaining--;
        }
      }

      if (newCars.isNotEmpty) {
        cars.addAll(newCars);
      }
    }

    final yearNumber = investWaitInMonths ~/ 12;
    final monthNumber = investWaitInMonths % 12;
    // result = 'Total number of cars after $yearNumber years and $monthNumber months: ${cars.length}';
    setState(() {
      result = 'Total number of cars after $yearNumber years and $monthNumber months: ${cars.length}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Invest App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Car Invest App'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
               TextFormField(
                controller: investWaitMonthsController,
                decoration: const InputDecoration(labelText: 'Invest wait in months'),
              ),
              TextFormField(
                controller: earningController,
                decoration: const InputDecoration(labelText: 'Earning for Month'),
              ),
              // TextFormField(
              //   controller: loanDurationController,
              //   decoration: const InputDecoration(labelText: 'Loan Duration'),
              // ),
              ElevatedButton(
                onPressed: calculateReinvest,
                child: const Text('Calculate'),
              ),
              const SizedBox(height: 16.0),
              Text(result),
              const SizedBox(height: 16.0),
              if (cars.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Car Objects at Each Iteration:'),
                    for (final car in cars)
                      Text(
                        jsonEncode(car),
                        style: const TextStyle(fontFamily: 'Courier New'),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(CarInvestApp());
}