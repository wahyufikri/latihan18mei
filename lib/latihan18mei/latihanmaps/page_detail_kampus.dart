import 'package:flutter/material.dart';
import 'package:latihan18mei/latihan18mei/latihanmaps/page_maps.dart';

import '../latihanmaps/model_kampus.dart';

class KampusDetail extends StatelessWidget {
  final Datum kampus;

  KampusDetail({required this.kampus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kampus.namaKampus),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'http://192.168.100.93/kampusDB/gambar/${kampus.gambarKampus}',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              kampus.namaKampus,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              kampus.lokasiKampus,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 8.0),
            Text(
              kampus.profileKampus,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.location_pin, color: Colors.red),
                SizedBox(width: 8.0),
                Text('Lat: ${kampus.latKampus}, Long: ${kampus.longKampus}'),
              ],
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapsPage(
                        latitude: double.parse(kampus.latKampus),
                        longitude: double.parse(kampus.longKampus),
                        namaKampus: kampus.namaKampus,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.map),
                label: Text('Lihat di Peta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}