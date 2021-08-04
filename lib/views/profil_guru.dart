import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peminjaman/helper/base_helper.dart';

class ProfilGuru extends StatefulWidget {
  @override
  _ProfilGuruState createState() => _ProfilGuruState();
}

class _ProfilGuruState extends State<ProfilGuru> {
  bool isEditable = false;
  bool onUploadImage = false;
  String nama = '';
  String avatar = '';

  File? imageFile;
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      upload(File(pickedFile.path));
    }
    print(pickedFile);
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  void getProfile() async {
    String url = "http://192.168.137.1:8003/api/siswa";
    try {
      final response = await Dio().get(url,
          options: Options(headers: {
            "Authorization":
                "Bearer 28|RDHbXXe5WR3Y6Jn7OPY4MifftibuMzgQ0jBtLcms",
            "Accept": "application/json"
          }));
      setState(() {
        avatar =
            "http://192.168.137.1:8003/${response.data["payload"]["get_siswa"]["image"]}";
        nama = response.data["payload"]["get_siswa"]["nama"].toString();
      });
      print(response);
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Mengganti Gambar Profil...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void upload(File file) async {
    print("============callled==========");
    print(file);
    String url = "http://192.168.137.1:8003/api/siswa/update-image";
    try {
      setState(() {
        onUploadImage = true;
      });
      String fileName = file.path.split("/").last;
      FormData form = FormData.fromMap({
        "image": await MultipartFile.fromFile(file.path, filename: fileName)
      });
      final response = await Dio().post(url,
          data: form,
          options: Options(headers: {
            "Authorization":
                "Bearer 28|RDHbXXe5WR3Y6Jn7OPY4MifftibuMzgQ0jBtLcms",
            "Accept": "application/json"
          }));
      setState(() {
        avatar =
            "http://192.168.137.1:8003/${response.data["payload"]["data"].toString()}";
      });
      print("=========uploaded========");
      print(response.data);
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Mengganti Gambar Profil...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print("=========error uploaded==========");
      print(e.response);
    }
    setState(() {
      onUploadImage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(nama);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Profil",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      child: isEditable
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEditable = false;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.save,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Simpan")
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEditable = true;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Ubah")
                                ],
                              ),
                            ),
                    )
                  ],
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (!onUploadImage) {
                      _getFromGallery();
                    }
                  },
                  child: onUploadImage
                      ? Container(
                          height: 150,
                          width: 150,
                          child: Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      avatar == "" ? BaseAvatar : avatar),
                                  fit: BoxFit.cover)),
                        ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nama"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: "Bangsat",
                      enabled: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Alamat"),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      enabled: isEditable,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.only(left: 10, right: 10)),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("No. Hp"),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      enabled: isEditable,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.only(left: 10, right: 10)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
