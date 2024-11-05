import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Map extends StatefulWidget {
  final String address;
  final double lat; // Latitude
  final double lng; // Longitude

  const Map({
    Key? key,
    required this.address,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController mapController;
  Location location = Location();
  LatLng? _currentLocation;

  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {}; // Set to store all markers

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentLocation = LatLng(
              currentLocation.latitude!, currentLocation.longitude!);
        });
        _updatePolyline();
      }
    });
  }

  void _updatePolyline() {
    if (_currentLocation != null) {
      setState(() {
        _polylines = {
          Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            width: 3,
            points: [
              _currentLocation!,
              LatLng(widget.lat, widget.lng),
            ],
          ),
        };
        _markers.add( // Add new marker to the set
          Marker(
            markerId: MarkerId("Destination"),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(widget.lat, widget.lng),
            infoWindow: InfoWindow(
              title: "Destination",
              snippet: "${widget.lat}, ${widget.lng}",
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.lng),
          zoom: 15,
        ),
        markers: _markers, // Use the set of markers
        polylines: _polylines,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
