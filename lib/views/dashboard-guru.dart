import 'package:flutter/material.dart';
import 'package:peminjaman/helper/base_helper.dart';
import 'package:peminjaman/helper/dummy.dart';
import 'package:peminjaman/views/components/bottom_navbar_guru.dart';
import 'package:peminjaman/views/components/card_peminjaman.dart';
import 'package:peminjaman/views/components/profile_navbar.dart';

class DashboardGuru extends StatefulWidget {
  @override
  _DashboardGuruState createState() => _DashboardGuruState();
}

class _DashboardGuruState extends State<DashboardGuru> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileNavbar(
              avatar: FaceAvatar,
              nama: "Bu Cantik",
              kelas: "Fisika",
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: DataDummy.dummyRequest.map((value) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/detail-pinjam", arguments: value);
                      },
                      child: CardPeminjaman(
                        image: value["image"].toString(),
                        nama: value["nama"].toString(),
                        qty: value["qty"] as int,
                        tanggal: value["tanggal"].toString(),
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
