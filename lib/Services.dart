import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove the shadow under the AppBar
        title: Text(''),
      ),
      extendBodyBehindAppBar: true, // Extend the body behind the AppBar
      body: Stack(
        children: [
          // Maintain your original background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/splash.PNG'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Adding the staggered services buttons to the page
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 100), // Increased height to accommodate for AppBar space
              Center(
                child: Text(
                  "Services Offer",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Adjust the color if needed to ensure visibility
                  ),
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ServiceButton(
                          serviceName: "PASTA",
                          description:
                              "Pasta is used to restore a tooth that has been damaged by cavities or decay."),
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ServiceButton(
                          serviceName: "TEETH CLEANING",
                          description:
                              "Teeth cleaning involves removing plaque and tartar from your teeth to maintain oral hygiene."),
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ServiceButton(
                          serviceName: "TEETH WHITENING",
                          description:
                              "Teeth whitening is a procedure that lightens the color of your teeth to improve appearance."),
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ServiceButton(
                          serviceName: "ROOT CANALS",
                          description:
                              "Root canals are procedures to treat infection within the root of a tooth."),
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ServiceButton(
                          serviceName: "EXTRACTIONS",
                          description:
                              "Extractions involve removing a tooth that is damaged beyond repair."),
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ServiceButton(
                          serviceName: "BRACES",
                          description:
                              "Braces are orthodontic devices used to align and straighten teeth."),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ServiceButton extends StatelessWidget {
  final String serviceName;
  final String description;

  ServiceButton({required this.serviceName, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        color: Colors.pink.shade100,
        borderRadius: BorderRadius.circular(10),
        elevation: 5,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(serviceName),
                  content: Text(description),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 200,
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    serviceName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: ServicesScreen(),
));

