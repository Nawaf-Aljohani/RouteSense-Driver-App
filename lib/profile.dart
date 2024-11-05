import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User? user;
  String? email;
  String? mobile;
  String? car;
  String? name;

  @override
  void initState() {
    super.initState();
    // Fetch the current user when the widget initializes
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        email = user!.email;
        // Call a method to fetch additional user data from Firestore based on email
        fetchUserData();
      });
    }
  }

  Future<void> fetchUserData() async {
    try {
      // Reference to Firestore collection 'drivers'
      CollectionReference drivers =
          FirebaseFirestore.instance.collection('drivers');
      // Query for documents where 'Email' field equals the user's email
      QuerySnapshot querySnapshot =
          await drivers.where('Email', isEqualTo: email).get();
      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Access the first document found (assuming there's only one document per email)
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        // Extract data from the document and update the state
        setState(() {
          mobile = docSnapshot[
              'Mobile']; // Assuming there's a 'Mobile' field in the document
          car = docSnapshot[
              'car']; // Assuming there's a 'Car' field in the document
          name = docSnapshot['name'];
        });
      }
    } catch (e) {
      // Handle any errors that occur
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Color.fromARGB(255, 24, 24, 24)),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app,
                color: Color.fromARGB(255, 255, 13, 13)),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 200.0,
                  color: Color.fromARGB(255, 243, 33, 33),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  name ?? 'Your name',
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Your email',
              border: OutlineInputBorder(),
            ),
            controller:
                TextEditingController(text: email), // Bind car data to TextField
            readOnly: true, // Set to true to prevent editing
          ),
          const SizedBox(height: 20.0),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Your phone',
              border: OutlineInputBorder(),
            ),
            controller:
                TextEditingController(text: mobile), // Bind car data to TextField
            readOnly: true, // Set to true to prevent editing
          ),
          const SizedBox(height: 20.0),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Your Car',
              border: OutlineInputBorder(),
            ),
            controller:
                TextEditingController(text: car), // Bind car data to TextField
            readOnly: true, // Set to true to prevent editing
          ),
        ],
      ),
    );
  }
}
