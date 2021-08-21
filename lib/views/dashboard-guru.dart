import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peminjaman/helper/base_helper.dart';
import 'package:peminjaman/helper/dummy.dart';
import 'package:peminjaman/views/components/bottom_navbar_guru.dart';
import 'package:peminjaman/views/components/card_peminjaman.dart';
import 'package:peminjaman/views/components/profile_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardGuru extends StatefulWidget {
  @override
  _DashboardGuruState createState() => _DashboardGuruState();
}

class _DashboardGuruState extends State<DashboardGuru> {
  List<dynamic> _listPinjaman = [];
  bool isLoading = true;
  String avatar = BaseAvatar;
  String nama = "Nama Guru";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
    getListPinjaman();
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

      setState(() {
        avatar = response.data["payload"]["get_guru"]["image"] == null
            ? BaseAvatar
            : "$HostImage${response.data["payload"]["get_guru"]["image"]}";
        nama = response.data["payload"]["get_guru"]["nama"].toString();
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

  void getListPinjaman() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String _dataToken = preferences.getString("token") ?? "";
      String url = "$HostAddress/pinjam-guru";
      final response = await Dio().get(url,
          options: Options(headers: {
            "Authorization": "Bearer $_dataToken",
            "Accept": "application/json"
          }));
      final data = response.data as List;
      setState(() {
        _listPinjaman = data;
      });
      print(response.data);
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Mendapatkan Data Peminjaman...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print(e.response);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileNavbar(
              avatar: avatar,
              nama: nama,
              isGuru: true,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                "Daftar permintaan peminjaman alat praktek",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Expanded(
              child: isLoading
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text("Sedang Mengunduh Data...")
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _listPinjaman.map((value) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/detail-pinjam",
                                  arguments: value);
                            },
                            child: CardPeminjaman(
                              image:
                                  "$HostImage${value["get_barang"]["image"].toString()}",
                              nama:
                                  value["get_barang"]["nama_barang"].toString(),
                              qty: value["qty"] as int,
                              tanggal: value["tanggal_pinjam"],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
            BottomNavbarGuru()
          ],
        ),
      ),
    );
  }
}
