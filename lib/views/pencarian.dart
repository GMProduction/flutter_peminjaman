import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peminjaman/bloc/barang_bloc.dart';
import 'package:peminjaman/helper/base_helper.dart';
import 'package:peminjaman/model/barang.dart';
import 'package:peminjaman/views/components/bottom_navbar.dart';
import 'package:peminjaman/views/components/card_barang.dart';

class Pencarian extends StatefulWidget {
  const Pencarian({Key? key}) : super(key: key);

  @override
  _PencarianState createState() => _PencarianState();
}

class _PencarianState extends State<Pencarian> {
  List<Barang> barang = [];
  bool isLoading = true;
  List<dynamic> _listBarang = [];

  @override
  void initState() {
    super.initState();
    fetchBarangByName('');
  }

  void fetchBarangByName(String param) async {
    try {
      setState(() {
        isLoading = true;
      });
      final response =
          await Dio().get('$HostAddress/barang?name=$param&limit=100&offset=0');
      final data = response.data['payload'] as List;
      print(data.toString());
      setState(() {
        _listBarang = data;
      });
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Mengambil Data...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
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
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextField(
                onSubmitted: (text) {
                  print(text);
                  fetchBarangByName(text);
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    hintText: 'Cari Alat Praktek...'),
                style: TextStyle(fontSize: 16),
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
                    : _listBarang.length <= 0
                        ? Container(
                            height: double.infinity,
                            width: double.infinity,
                            child:
                                Center(child: Text("Data Tidak Tersedia...")))
                        : SingleChildScrollView(
                            child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Column(
                              children: _listBarang
                                  .map((barang) => GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/detail',
                                            arguments: barang["id"]);
                                      },
                                      child: CardBarang(
                                        image:
                                            "$HostImage${barang["image"].toString()}",
                                        nama: barang["nama_barang"].toString(),
                                        stock: barang["qty"] as int,
                                      )))
                                  .toList(),
                            ),
                          ))),
          ],
        ),
      ),
    );
  }
}
