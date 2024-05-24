import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';


// Model classes
ModelMaps modelMapsFromJson(String str) => ModelMaps.fromJson(json.decode(str));

String modelMapsToJson(ModelMaps data) => json.encode(data.toJson());

class ModelMaps {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelMaps({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelMaps.fromJson(Map<String, dynamic> json) => ModelMaps(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String namaKampus;
  String lokasi;
  String gambar;
  String lat;
  String long;
  String profile;

  Datum({
    required this.id,
    required this.namaKampus,
    required this.lokasi,
    required this.gambar,
    required this.lat,
    required this.long,
    required this.profile,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    namaKampus: json["nama_kampus"],
    lokasi: json["lokasi"],
    gambar: json["gambar"],
    lat: json["lat"],
    long: json["long"],
    profile: json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_kampus": namaKampus,
    "lokasi": lokasi,
    "gambar": gambar,
    "lat": lat,
    "long": long,
    "profile": profile,
  };
}

// Flutter widget
class PageHomeMaps extends StatefulWidget {
  const PageHomeMaps({Key? key}) : super(key: key);

  @override
  State<PageHomeMaps> createState() => _PageHomeMapsState();
}

class _PageHomeMapsState extends State<PageHomeMaps> {
  List<Datum> listData = [];
  TextEditingController txtCari = TextEditingController();
  bool isLoading = false;
  bool isCari = true;
  List<Datum> filterData = [];

  @override
  void initState() {
    super.initState();
    txtCari.addListener(() {
      filterSearchResults(txtCari.text);
    });
    getData();
  }

  Future getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse("http://192.168.145.195/maps_mobile/getMaps.php"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("http://192.168.145.195/maps_mobile/image/$data"); // Debugging: Print the raw response
        var modelData = modelMapsFromJson(response.body);

        // Prepend base URL to the image path
        String baseUrl = "http://192.168.145.195/maps_mobile/image/${modelData?.data?.first?.gambar}";
        modelData.data.forEach((datum) {
          datum.gambar = baseUrl + datum.gambar;
        });

        setState(() {
          listData = modelData.data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Datum> dummyListData = [];
      for (var item in listData) {
        if (item.namaKampus.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        isCari = false;
        filterData = dummyListData;
      });
      return;
    } else {
      setState(() {
        isCari = true;
        filterData = listData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: txtCari,
              decoration: InputDecoration(
                hintText: "Search..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(1),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: isCari ? listData.length : filterData.length,
                itemBuilder: (context, index) {
                  Datum data = isCari ? listData[index] : filterData[index];
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: () {
                        // Handle the card tap event here
                        // Handle the card tap event here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(data: data),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Image.network(
                              data.gambar,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            ListTile(
                              title: Text(data.namaKampus),
                              subtitle: Text(data.lokasi),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Datum data;

  const DetailPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.namaKampus),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Image.network(
              data.gambar,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.namaKampus,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(data.lokasi),
                  const SizedBox(height: 10),
                  Text(data.profile),
                ],
              ),
            ),
            const SizedBox(height: 10), // Adding space between the text and the map
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse(data.lat), double.parse(data.long)),
                  zoom: 16,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(data.id),
                    position: LatLng(double.parse(data.lat), double.parse(data.long)),
                    infoWindow: InfoWindow(
                      title: data.namaKampus,
                      snippet: data.lokasi,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailMaps(data: data),
                        ),
                      );
                    },
                  ),
                },
                onMapCreated: (GoogleMapController controller) {
                  // Optional: Add logic here if needed for map customization
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class DetailMaps extends StatefulWidget {
  final Datum data;

  const DetailMaps({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailMaps> createState() => _DetailMapsState();
}

class _DetailMapsState extends State<DetailMaps> {
  late LatLng _initialPosition;

  @override
  void initState() {
    super.initState();
    _initialPosition = LatLng(double.parse(widget.data.lat), double.parse(widget.data.long));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Maps'),
        backgroundColor: Colors.green,
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 16,
        ),
        mapType: MapType.normal,
        markers: {
          Marker(
            markerId: MarkerId(widget.data.id),
            position: _initialPosition,
            infoWindow: InfoWindow(
              title: widget.data.namaKampus,
              snippet: widget.data.lokasi,
            ),
          ),
        },
      ),
    );
  }
}