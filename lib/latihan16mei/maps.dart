import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapsFlutter extends StatefulWidget {
  const MapsFlutter({Key? key}) : super(key: key);
  @override
  State<MapsFlutter> createState() => _MapsFlutterState();
}
class _MapsFlutterState extends State<MapsFlutter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps Flutter'),
        backgroundColor: Colors.green,
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        initialCameraPosition: const CameraPosition(
            target: LatLng(-6.297950949676951, 106.6989246837098),
            zoom: 16)
        ,
        mapType: MapType.normal,
        markers: {
          const Marker(
              markerId: MarkerId("Udacoding"),
              position: LatLng(-6.297950949676951,
                  106.6989246837098),infoWindow: InfoWindow(
              title: 'Udacoding Tangsel', snippet: 'Udacoding Tangerang selatan'
          ))
        },
      ),
    );
  }
}