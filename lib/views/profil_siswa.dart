import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peminjaman/helper/base_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilSiswa extends StatefulWidget {
  @override
  _ProfilSiswaState createState() => _ProfilSiswaState();
}

class _ProfilSiswaState extends State<ProfilSiswa> {
  bool isEditable = false;
  bool onUploadImage = false;
  String nama = '';
  String avatar = BaseAvatar;
  String noHp = '';
  String alamat = '';
  String kelas = '';
  DateTime? tanggal;
  TextEditingController textNama = TextEditingController();
  TextEditingController textHp = TextEditingController();
  TextEditingController textAlamat = TextEditingController();
  TextEditingController textKelas = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  void dispose() {
    textNama.dispose();
    textHp.dispose();
    textAlamat.dispose();
    textKelas.dispose();
    super.dispose();
  }

  void getProfile() async {
    String url = "$HostAddress/siswa";
    String _token = await GetToken();
    try {
      final response = await Dio().get(url,
          options: Options(headers: {
            "Authorization": "Bearer $_token",
            "Accept": "application/json"
          }));
      setState(() {
        avatar = response.data["payload"]["get_siswa"]["image"] == null
            ? BaseAvatar
            : "$HostImage${response.data["payload"]["get_siswa"]["image"]}";
        textHp.text = response.data["payload"]["get_siswa"]["no_hp"].toString();
        textAlamat.text =
            response.data["payload"]["get_siswa"]["alamat"].toString();
        textNama.text =
            response.data["payload"]["get_siswa"]["nama"].toString();
        textKelas.text =
            response.data["payload"]["get_siswa"]["kelas"].toString();
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
      print(e.response);
    }
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      upload(File(pickedFile.path));
    }
  }

  void upload(File file) async {
    String url = "$HostAddress/siswa/update-image";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String _dataToken = preferences.getString("token") ?? "";
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
            "Authorization": "Bearer $_dataToken",
            "Accept": "application/json"
          }));
      setState(() {
        avatar = "$HostImage${response.data["payload"]["data"].toString()}";
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

  void editProfile() async {
    try {
      Map<String, dynamic> data = {
        "nama": textNama.text,
        "kelas": textKelas.text,
        "alamat": textAlamat.text,
        "no_hp": textHp.text,
        "tanggal": tanggal
      };
      print(data);
      String url = "$HostAddress/siswa";
      String token = await GetToken();
      var formData = FormData.fromMap(data);
      final response = await Dio().post(url,
          data: formData,
          options: Options(headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          }));
      print(response.data);
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Menyimpan Data...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      child: isEditable ? 
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isEditable = false;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Batal")
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
                            Text("Edit")
                          ],
                        ),
                      )
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
                                  image: NetworkImage(avatar),
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
                    TextField(
                      controller: textNama,
                      enabled: isEditable,
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
                      controller: textAlamat,
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
                      controller: textHp,
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
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Kelas"),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: textKelas,
                      keyboardType: TextInputType.text,
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
              GestureDetector(
                onTap: () {
                  if (isEditable) {
                    showDatePicker(
                            context: context,
                            initialDate:
                                tanggal == null ? DateTime.now() : tanggal!,
                            firstDate: DateTime(1980),
                            lastDate: DateTime(2500))
                        .then((value) {
                      if (value != null) {
                        print(nama);
                        print(nama);
                        print(nama);
                        print(nama);
                        setState(() {
                          tanggal = value;
                        });
                      }
                    });
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tanggal Lahir"),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 45,
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.black54, width: 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            tanggal != null
                                ? Text(
                                    "${tanggal!.day.toString().padLeft(2, "0")}-${tanggal!.month.toString().padLeft(2, "0")}-${tanggal!.year.toString()}")
                                : Text(""),
                            Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isEditable,
                child: Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(bottom: 20),
                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text("Simpan", style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
