import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peminjaman/helper/base_helper.dart';
import 'package:peminjaman/helper/dummy.dart';
import 'package:peminjaman/views/components/bottom_navbar_guru.dart';
import 'package:peminjaman/views/components/card_history_pinjam_guru.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryGuru extends StatefulWidget {
  @override
  _HistoryGuruState createState() => _HistoryGuruState();
}

class _HistoryGuruState extends State<HistoryGuru> {
  List<dynamic> _historyPinjaman = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getHistoryPinjaman();
  }

  void getHistoryPinjaman() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String _dataToken = preferences.getString("token") ?? "";
      String url = "$HostAddress/pinjam-guru/history";
      final response = await Dio().get(url,
          options: Options(headers: {
            "Authorization": "Bearer $_dataToken",
            "Accept": "application/json"
          }));
      final data = response.data as List;
      setState(() {
        _historyPinjaman = data;
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "History pinjam alat praktek",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Column(
                      children: _historyPinjaman.map((value) {
                        return CardHistoryGuru(
                          image:
                              "$HostImage${value["get_barang"]["image"].toString()}",
                          nama: value["get_barang"]["nama_barang"].toString(),
                          qty: value["qty"] as int,
                          status: value["txt_status"].toString(),
                          tanggal: value["tanggal_pinjam"],
                          peminjam: value["get_siswa"]["nama"],
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            ),
            BottomNavbarGuru(
              selected: 1,
            )
          ],
        ),
      ),
    );
  }
}
