import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peminjaman/bloc/barang_bloc.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBarangByName('');
  }

  void fetchBarangByName(String param) async {
    try {
      final response = await Dio()
          .get('http://192.168.137.1:8000/api/barang/cari/nama?name=$param');
      final data = response.data as List;
      final List<Barang> items = data.map((item) {
        final String image = item['image'] ?? '';
        return Barang(
            id: item['id'] as int,
            nama: item['nama_barang'] as String,
            qty: item['qty'] as int,
            image: image);
      }).toList();
      setState(() {
        barang = items;
      });
    } on DioError catch (e) {
      print(e);
    } on Exception catch (e) {
      print(e);
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
                    : barang.length <= 0
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
                              children: barang
                                  .map((barang) => GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/detail',
                                            arguments: barang.id);
                                      },
                                      child: CardBarang(image: barang.image, nama: barang.nama, stock: barang.qty,)))
                                  .toList(),
                            ),
                          ))),
            
          ],
        ),
      ),
    );
  }
}
