import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Car extends StatefulWidget {
  const Car({Key? key}) : super(key: key);

  @override
  State<Car> createState() => _CarState();
}

class _CarState extends State<Car> {
late String CO2 = '';
  late String cargoSpace = '';
  late String curbWeight = '';
  late String cylinders = '';
  late String engineSize = '';
  late String fuelEconomy = '';
  late String grossVehicleWeight = '';
  late String maxOutput = '';
  late String maxTorque = '';
  late String name = 'Your Car';
  late String netPayload = '';
  late String transmissionSystem = '';

  @override
  void initState() {
    super.initState();
    // Call a method to fetch car data from Firestore
    fetchCarData();
  }

  Future<void> fetchCarData() async {
    try {
      // Reference to Firestore collection 'car'
      CollectionReference carCollection = FirebaseFirestore.instance.collection('cars');
      // Get the document snapshot
      DocumentSnapshot carSnapshot = await carCollection.doc('oqYCtyD4piSrJJiwiifA').get();
      // Extract data from the document
      setState(() {
        CO2 = carSnapshot['CO2'];
        cargoSpace = carSnapshot['cargo_Space'];
        curbWeight = carSnapshot['curb_Weight'];
        cylinders = carSnapshot['cylinders'];
        engineSize = carSnapshot['engine_size'];
        fuelEconomy = carSnapshot['fuel_Economy '];
        grossVehicleWeight = carSnapshot['gross_Vehicle_Weight'];
        maxOutput = carSnapshot['max_Output'];
        maxTorque = carSnapshot['max_Torque'];
        name = carSnapshot['name'];
        netPayload = carSnapshot['net_Payload'];
        transmissionSystem = carSnapshot['transmission_System'];
      });
    } catch (e) {
      // Handle any errors that occur
      print('Error fetching car data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Car+',
          style: TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.directions_car, // Car icon
                  size: 200.0, // Adjust the size as needed
                  color: Color.fromARGB(255, 255, 47, 47), // Adjust the color as needed
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  name ?? 'Your Car',
                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'CO2',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: CO2),
            readOnly: true,
          ),
          const SizedBox(height: 20.0),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Cargo Space',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: cargoSpace),
            readOnly: true,
          ),
          const SizedBox(height: 20.0),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Curb Weight',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: curbWeight),
            readOnly: true,
          ),
          const SizedBox(height: 20.0),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Cylinders',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: cylinders),
            readOnly: true,
          ),
          const SizedBox(height: 20.0),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Engine Size',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: engineSize),
            readOnly: true,
          ),
          const SizedBox(height: 20.0),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Fuel Economy',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: fuelEconomy),
            readOnly: true,
          ),
          const SizedBox(height: 20.0),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Gross Vehicle Weight',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: grossVehicleWeight),
            readOnly: true,
          ),
          const SizedBox(height: 20.0),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Max Output',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: maxOutput),
            readOnly: true,
          ),
          const SizedBox(height: 20.0),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Max Torque',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: maxTorque),
            readOnly: true,
          ),
          const SizedBox(height: 20.0),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Net Payload',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: netPayload),
            readOnly: true,
          ),
          const SizedBox(height: 20.0),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Transmission System',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: transmissionSystem),
            readOnly: true,
          ),
          
        ],
      ),
    );
  }
}
