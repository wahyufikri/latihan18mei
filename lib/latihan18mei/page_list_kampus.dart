import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;

import 'ModelKampus.dart';



class ListKampus extends StatefulWidget {
  const ListKampus({super.key});

  @override
  State<ListKampus> createState() => _ListKampusState();
}

class _ListKampusState extends State<ListKampus> {
  TextEditingController searchController = TextEditingController();
  List<Datum>? kampusList;
  String? username;
  List<Datum>? filteredKampusList; // List berita hasil filter

  @override
  void initState() {
    super.initState();
  }

  //untuk mendpatkan data ses

  //method untuk get berita
  Future<List<Datum>?> getKampus() async{
    try{
      //berhasil
      http.Response response = await
      http.get(Uri.parse("http://192.168.179.154/mobile_maps/getKampus.php"));

      return modelKampusFromJson(response.body).data;
      //kondisi gagal untuk mendapatkan respon api
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Aplikasi Berita'),
      //   backgroundColor: Colors.cyan,
      //   actions: [
      //     TextButton(onPressed: () {}, child: Text('Hi ... $username')),
      //     // Logout
      //     IconButton(
      //       onPressed: () {
      //         // Clear session
      //         setState(() {
      //           session.clearSession();
      //           Navigator.pushAndRemoveUntil(
      //             context,
      //             MaterialPageRoute(builder: (context) => PageLoginTugas()),
      //                 (route) => false,
      //           );
      //         });
      //       },
      //       icon: Icon(Icons.exit_to_app),
      //       tooltip: 'Logout',
      //     )
      //   ],
      // ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  filteredKampusList = kampusList
                      ?.where((element) =>
                  element.nama!
                      .toLowerCase()
                      .contains(value.toLowerCase()) ||
                      element.lokasi!
                          .toLowerCase()
                          .contains(value.toLowerCase()) ||
                      element.gambar!
                          .toLowerCase()
                          .contains(value.toLowerCase()) ||
                      element.latLong != null &&
                          "${element.latLong.latitude},${element.latLong.longitude}"
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                      element.profile!
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },

              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getKampus(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Datum>?> snapshot) {
                if (snapshot.hasData) {
                  kampusList = snapshot.data;
                  if (filteredKampusList == null) {
                    filteredKampusList = kampusList;
                  }
                  return ListView.builder(
                    itemCount: filteredKampusList!.length,
                    itemBuilder: (context, index) {
                      Datum data = filteredKampusList![index];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => DetailBerita(data),
                            //   ),
                            // );
                          },
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network('http://192.168.179.154/mobile_maps/gambar_kampus/${data.gambar}',
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                ),
                                ListTile(
                                  title: Text(
                                    '${data.nama}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${data.latLong}',
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${data.lokasi}',
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${data.profile}',
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}