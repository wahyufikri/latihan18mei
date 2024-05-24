import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latihan18mei/latihan18mei/latihanmaps/page_detail_kampus.dart';
import 'package:latihan18mei/latihan18mei/latihanmaps/page_maps_all.dart';

import '../latihanmaps/model_kampus.dart';

class KampusList extends StatefulWidget {
  @override
  _KampusListState createState() => _KampusListState();
}

class _KampusListState extends State<KampusList> {
  Future<ModelKampus>? _kampusFuture;
  List<Datum> _kampusList = [];
  List<Datum> _filteredKampusList = [];

  @override
  void initState() {
    super.initState();
    _kampusFuture = fetchKampus();
  }

  Future<ModelKampus> fetchKampus() async {
    final response = await http.get(Uri.parse('http://192.168.100.93/kampusDB/getKampus.php'));

    if (response.statusCode == 200) {
      final kampusData = modelKampusFromJson(response.body);
      setState(() {
        _kampusList = kampusData.data;
        _filteredKampusList = _kampusList;
      });
      return kampusData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _filterKampus(String query) {
    setState(() {
      _filteredKampusList = _kampusList
          .where((kampus) => kampus.namaKampus.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapsAllPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Kampus'),
        backgroundColor: Colors.orange,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://example.com/profile.jpg'), // Replace with your profile image URL
            ),
          ),
        ],
      ),
      body: FutureBuilder<ModelKampus>(
        future: _kampusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (query) => _filterKampus(query),
                      decoration: InputDecoration(
                        hintText: 'Search kampus',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    itemCount: _filteredKampusList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      var kampus = _filteredKampusList[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KampusDetail(kampus: kampus),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'http://192.168.100.93/kampusDB/gambar/${kampus.gambarKampus}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      kampus.namaKampus,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      kampus.lokasiKampus,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped, // Handle tap events
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Maps',
          ),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}