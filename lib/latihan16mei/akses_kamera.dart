import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AksesKamera extends StatefulWidget {
  const AksesKamera({Key? key}) : super(key: key);

  @override
  State<AksesKamera> createState() => _AksesKameraState();
}

class _AksesKameraState extends State<AksesKamera> {
  XFile? image;

  Future<void> imageKamera() async {
    try {
      var res = await ImagePicker().pickImage(source: ImageSource.camera);
      if (res != null) {
        setState(() {
          image = res;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Akses Kamera"),
        backgroundColor: Colors.green,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () async {
            await imageKamera();
          },
          child: image != null
              ? Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 5, color: Colors.green),
            ),
            child: kIsWeb
                ? Image.network(
              image!.path,
            )
                : Image.file(
              File(image!.path),
            ),
          )
              : const Icon(
            Icons.camera_alt_outlined,
            size: 50,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}