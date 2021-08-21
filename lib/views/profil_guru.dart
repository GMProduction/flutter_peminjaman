import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peminjaman/helper/base_helper.dart';
import 'package:peminjaman/views/components/bottom_navbar_guru.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilGuru extends StatefulWidget {
  @override
  _ProfilGuruState createState() => _ProfilGuruState();
}

class _ProfilGuruState extends State<ProfilGuru> {
  bool isEditable = false;
  bool isLoadingSave = false;
  bool onUploadImage = false;
  String nama = '';
  String avatar = '';
  TextEditingController textNama = TextEditingController();
  TextEditingController textAlamat = TextEditingController();
  DateTime? tanggal;
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

  @override
  void dispose() {
    textNama.dispose();
    textAlamat.dispose();
    super.dispose();
  }

  void getProfile() async {
    String url = "$HostAddress/guru";
    String _token = await GetToken();
    try {
      final response = await Dio().get(url,
          options: Options(headers: {
            "Authorization": "Bearer $_token",
            "Accept": "application/json"
          }));
      String? tglLahir = response.data["payload"]["get_guru"]["tanggal"];
      if (tglLahir != null) {
        DateTime tempDate = DateTime.parse(tglLahir);
        setState(() {
          tanggal = tempDate;
        });
      }
      setState(() {
        avatar = response.data["payload"]["get_guru"]["image"] == null
            ? BaseAvatar
            : "$HostImage${response.data["payload"]["get_guru"]["image"]}";
      });
      textAlamat.text =
          response.data["payload"]["get_guru"]["alamat"].toString();
      textNama.text = response.data["payload"]["get_guru"]["nama"].toString();
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
    String url = "$HostAddress/guru/update-image";
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
    setState(() {
      isLoadingSave = true;
    });
    try {
      Map<String, dynamic> data = {
        "nama": textNama.text,
        "alamat": textAlamat.text,
        "tanggal": tanggal
      };
      print(data);
      String url = "$HostAddress/guru";
      String token = await GetToken();
      var formData = FormData.fromMap(data);
      final response = await Dio().post(url,
          data: formData,
          options: Options(headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          }));
      Fluttertoast.showToast(
          msg: "Berhasil Merubah Data...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print(response.data);
      setState(() {
        isEditable = false;
      });
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Menyimpan Data...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print(e.response);
    }
    setState(() {
      isLoadingSave = false;
    });
  }

  void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("token");
    preferences.remove("role");
    Navigator.pushNamedAndRemoveUntil(context, "/", ModalRoute.withName("/"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                          ),
                  ),
                  Text(
                    "Profil",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      logout();
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            size: 16,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Logout")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
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
                        TextField(
                          controller: textNama,
                          enabled: isEditable,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 10),
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
                              contentPadding:
                                  EdgeInsets.only(left: 10, right: 10)),
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
                                border: Border.all(
                                    color: Colors.black54, width: 1)),
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
                        child: GestureDetector(
                          onTap: () {
                            if (!isLoadingSave) {
                              editProfile();
                            }
                          },
                          child: Container(
                            height: 65,
                            decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: isLoadingSave
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Loading...",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24),
                                        )
                                      ],
                                    )
                                  : Text(
                                      "Simpan",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
            BottomNavbarGuru(
              selected: 2,
            ),
          ],
        ),
      ),
    );
  }
}
