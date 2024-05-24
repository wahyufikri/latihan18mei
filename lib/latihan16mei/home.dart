import 'package:flutter/material.dart';
import 'package:latihan18mei/latihan16mei/akses_kamera.dart';
import 'package:latihan18mei/latihan16mei/maps.dart';

class PageAwal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latihan 16 Mei'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AksesKamera()),
                );
              },
              child: Text('Akses Kamera'),
            ),
            SizedBox(height: 20), // Spacer
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapsFlutter()),
                );
              },
              child: Text('Maps'),
            ),
          ],
        ),
      ),
    );
  }
}