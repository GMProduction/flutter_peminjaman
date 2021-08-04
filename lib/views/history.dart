import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:peminjaman/helper/base_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/bottom_navbar.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late bool isLoading = true;
  String token = "";
  List<dynamic> _dataPeminjaman = [];

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  void fetchHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String _dataToken = preferences.getString("token") ?? "";
    try {
      final response = await Dio().get("$HostAddress/pinjam",
          options: Options(headers: {
            "Authorization": "Bearer $_dataToken",
            "Accept": "application/json"
          }));
      setState(() {
        _dataPeminjaman = response.data as List;
      });
      print(response.data);
    } on DioError catch (e) {
      print(e.response);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                "History Peminjaman",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            SizedBox(
                              child: CircularProgressIndicator(),
                              height: 30,
                              width: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Sedang Mengunduh Data...")
                          ],
                        ))
                    : Column(
                        children: _dataPeminjaman.map((value) {
                          return Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              height: 120,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black12.withOpacity(0.1), width: 1),
                                color: Colors.white70,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(2, 2))
                                ]
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.amber,
                                        image: DecorationImage(
                                            image: NetworkImage("$HostImage${value["get_barang"]["image"]}"),
                                            fit: BoxFit.cover)),
                                  ),
                                  Expanded(
                                      child: Container(
                                      height: 100,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            value["get_barang"]["nama_barang"],
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Jumlah Pinjam : ${value["qty"]}',
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                    )
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      )),
            BottomNavbar(
              selected: 1,
            )
          ],
        ),
      ),
    );
  }
}
