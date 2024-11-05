import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Import for clipboard functionalities

class Deliveries extends StatefulWidget {
  final void Function(String, double, double) navigateToMap; // Add this line

  const Deliveries(
      {super.key, required this.navigateToMap}); // Update constructor

  @override
  State<Deliveries> createState() => _DeliveriesState();
}

class _DeliveriesState extends State<Deliveries> {
  late Stream<QuerySnapshot> _userStream;
  void _showSafetyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, //  Makes the dialog non-dismissable
      builder: (context) => AlertDialog(
        title: const Text('Safety Reminder'),
        content: const Text(
            'Please prioritize safety! Do not actively use your phone while driving.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Future<dynamic> findDriverAssignmentByEmail(String email) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('drivers')
        .where('Email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        // Access the document data
        Map<String, dynamic> data = documentSnapshot.data();
        if (data.containsKey('assignment')) {
          dynamic assignment = data['assignment'];
          return assignment;
        }
      }
    }
    return null;
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  @override
  void initState() {

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? email = user.email;
      findDriverAssignmentByEmail(email!).then((assignment) {
        if (assignment != null) {
          // Listen for changes in the driver's assignment
          _subscription = FirebaseFirestore.instance
              .collection('drivers')
              .where('Email', isEqualTo: email)
              .snapshots()
              .listen((snapshot) {
            snapshot.docs.forEach((doc) {
              if (doc.exists && doc['assignment'] != null) {
                String assignmentId = doc['assignment'];
                _updateUserStream(assignmentId);
              }
            });
          });
        } else {
          print('No assignment found for the provided email.');
        }
      });
    } else {
      print('impossible');
    }
    super.initState();

    Future.delayed(const Duration(seconds: 1), () => _showSafetyDialog());
  }

  void _updateUserStream(String assignmentId) {
    setState(() {
      _userStream = FirebaseFirestore.instance
          .collection(assignmentId)
          .orderBy('order') // Order documents by the 'order' field
          .snapshots();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _copyPhoneNumber(String phoneNumber) {
    Clipboard.setData(ClipboardData(text: phoneNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Phone number copied to clipboard'),
      ),
    );
  }

  void _deleteItem(String documentId) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? email = user.email;
      findDriverAssignmentByEmail(email!).then((assignment) {
        if (assignment != null) {
          // Update the document in the appropriate collection based on the assignment
          FirebaseFirestore.instance
              .collection(assignment)
              .doc(documentId)
              .update({'status': 'cancelled'})
              .then((_) {})
              .catchError((error) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(error.message ?? "Error occurred, contact admin."),
                  ),
                );
              });
        } else {
          print('No assignment found for the provided email.');
        }
      });
    } else {
      print('impossible');
    }
  }

  void _markAsDone(String documentId) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? email = user.email;
      findDriverAssignmentByEmail(email!).then((assignment) {
        if (assignment != null) {
          // Update the document in the appropriate collection based on the assignment
          FirebaseFirestore.instance
              .collection(assignment)
              .doc(documentId)
              .update({'status': 'done'})
              .then((_) {})
              .catchError((error) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(error.message ?? "Error occurred, contact admin."),
                  ),
                );
              });
        } else {
          print('No assignment found for the provided email.');
        }
      });
    } else {
      print('impossible');
    }
  }

  Future<void> _showDeleteConfirmationDialog(String documentId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Cancellation'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to cancel this delivery?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Back',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Confirm',
                style: TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
              ),
              onPressed: () {
                _deleteItem(documentId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDoneConfirmationDialog(String documentId) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delivery'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to mark this delivery as done?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Back',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Confirm',
                style: TextStyle(color: Color.fromARGB(255, 21, 255, 0)),
              ),
              onPressed: () {
                _markAsDone(documentId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Row(
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 43,
              color: Color.fromARGB(255, 46, 46, 46),
            ),
            Text(
              "   Deliveries",
              style: TextStyle(color: Color.fromARGB(211, 19, 19, 19)),
            )
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          var docs = snapshot.data!.docs
              .where((doc) => doc['status'] == 'pending')
              .toList();
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              height: 5,
              color: Color.fromARGB(255, 209, 209, 209),
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var doc = docs[index];
              return GestureDetector(
                onLongPress: () {
                  _copyPhoneNumber(doc['mobile']);
                },
                child: Dismissible(
                  key: Key(doc.id),
                  onDismissed: (direction) {
                    setState(
                      () {
                        _deleteItem(doc.id);
                        docs.removeAt(index);
                      },
                    );
                  },
                  background: Container(color: Colors.red),
                  child: ListTile(
                    horizontalTitleGap: 3,
                    leading: Column(
                      children: [
                        const Icon(
                          Icons.place,
                          color: Colors.red,
                          size: 32,
                        ),
                        Text(
                          doc["order"].toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    title: Text(doc['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doc['mobile']),
                        Text(doc['location']),
                        Text(doc['deliveryTime']),

                      ],
                    ),
                    onTap: () {
                      widget.navigateToMap(
                        doc["location"],
                        doc['lat'],
                        doc['lng'],
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 22,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          onPressed: () {
                            _showDeleteConfirmationDialog(doc.id);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            backgroundColor:
                                const Color.fromARGB(155, 255, 0, 0),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            _showDoneConfirmationDialog(doc.id);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            backgroundColor:
                                const Color.fromARGB(246, 94, 189, 94),
                          ),
                          child: const Text(
                            "Done",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
