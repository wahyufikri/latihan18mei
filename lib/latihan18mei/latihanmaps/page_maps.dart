import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String namaKampus;

  MapsPage({
    required this.latitude,
    required this.longitude,
    required this.namaKampus,
  });

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.namaKampus),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId(widget.namaKampus),
            position: LatLng(widget.latitude, widget.longitude),
            infoWindow: InfoWindow(
              title: widget.namaKampus,
            ),
          ),
        },
      ),
    );
  }
}