import 'package:flutter/material.dart';

class ReceiptPage extends StatelessWidget {
  final String service;
  final DateTime date;
  final TimeOfDay time;
  final String price;

  ReceiptPage({required this.service, required this.date, required this.time, required this.price});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipt"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Service: $service", style: TextStyle(fontSize: 20)),
              Text("Date: ${date.toLocal().toIso8601String().split('T')[0]}", style: TextStyle(fontSize: 20)),
              Text("Time: ${time.format(context)}", style: TextStyle(fontSize: 20)),
              Text("Price: $price", style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text("Back to Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
