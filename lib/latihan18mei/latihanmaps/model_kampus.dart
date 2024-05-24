// To parse this JSON data, do
//
//     final modelKampus = modelKampusFromJson(jsonString);

import 'dart:convert';

ModelKampus modelKampusFromJson(String str) => ModelKampus.fromJson(json.decode(str));

String modelKampusToJson(ModelKampus data) => json.encode(data.toJson());

class ModelKampus {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelKampus({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelKampus.fromJson(Map<String, dynamic> json) => ModelKampus(
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
  String lokasiKampus;
  String gambarKampus;
  String latKampus;
  String longKampus;
  String profileKampus;

  Datum({
    required this.id,
    required this.namaKampus,
    required this.lokasiKampus,
    required this.gambarKampus,
    required this.latKampus,
    required this.longKampus,
    required this.profileKampus,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    namaKampus: json["nama_kampus"],
    lokasiKampus: json["lokasi_kampus"],
    gambarKampus: json["gambar_kampus"],
    latKampus: json["lat_kampus"],
    longKampus: json["long_kampus"],
    profileKampus: json["profile_kampus"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_kampus": namaKampus,
    "lokasi_kampus": lokasiKampus,
    "gambar_kampus": gambarKampus,
    "lat_kampus": latKampus,
    "long_kampus": longKampus,
    "profile_kampus": profileKampus,
  };
}