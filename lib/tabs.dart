// ignore: file_names
import 'package:flutter/material.dart';
import 'package:learning_app/car.dart';
import 'package:learning_app/deliveries_page.dart';
import 'package:learning_app/profile.dart';
import 'package:learning_app/map.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int currentPageIndex = 1;


  void navigateToMap(String address, double lat, double lng) {
    setState(() {
      //rebuilds
      currentPageIndex = 1; // Switch to the Map tab
      // Update the activePage with the new address
      activePage = Map(
        address: address,
        lat: lat,
        lng: lng,
      );
    });
  }



  Widget activePage = Map(
    address: "Start Delivering!",
    lat: 24.7325,
    lng: 46.7766,
  ); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          Deliveries(navigateToMap: navigateToMap),
          activePage,
          Car(),
          Profile(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        child: NavigationBar(
          indicatorColor: const Color.fromARGB(60, 0, 0, 0),
          backgroundColor: const Color.fromARGB(195, 255, 255, 255),
          selectedIndex: currentPageIndex,
          onDestinationSelected: (value) => {
            setState(() {
              currentPageIndex = value;
            })
          },
          destinations: const [
            NavigationDestination(
              tooltip: "The list of your daily deliveries",
              icon: Icon(
                Icons.list,
              ),
              label: "Deliveries",
            ),
            NavigationDestination(
              tooltip: "The map to show your next route",
              icon: Icon(
                Icons.place,
              ),
              label: "Map",
            ),
            NavigationDestination(
              tooltip: "The tab to show car health and information",
              icon: Icon(
                Icons.car_repair,
              ),
              label: "Car+",
            ),
            NavigationDestination(
              tooltip: "The profile",
              icon: Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
