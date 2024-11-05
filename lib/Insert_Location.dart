import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locations Page',
      home: LocationsFieldPage(),
    );
  }
}

class LocationsFieldPage extends StatefulWidget {
  @override
  _LocationsFieldPageState createState() => _LocationsFieldPageState();
}

class _LocationsFieldPageState extends State<LocationsFieldPage> {
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    // Start with one text field controller
    _controllers.add(TextEditingController());
  }

  void _addNewTextField() {
    if (_controllers.length < 25) {
      setState(() {
        _controllers.add(TextEditingController());
      });
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    _controllers.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Best Route'),
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'Image.png',
              height: 120.0,
            ),

            SizedBox(height: 20),

            Text('Enter Locations'),
            SizedBox(height: 10), 
            ..._controllers.asMap().entries.map((entry) {
              int index = entry.key;
              TextEditingController controller = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Location ${index + 1}',
                    border: OutlineInputBorder(),
                  ),
                ),
              );
            }).toList(),
            if (_controllers.length < 25)
              ElevatedButton.icon(
                onPressed: _addNewTextField,
                icon: const Icon(Icons.add),
                label: const Text('Add Location'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red, // background color
                ),
              ),

            ElevatedButton(
              child: const Text('Enter'),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red, // text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}