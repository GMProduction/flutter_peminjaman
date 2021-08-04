import 'package:flutter/material.dart';
import 'package:peminjaman/helper/dummy.dart';
import 'package:peminjaman/views/components/bottom_navbar_guru.dart';
import 'package:peminjaman/views/components/card_history_pinjam_guru.dart';

class HistoryGuru extends StatefulWidget {
  @override
  _HistoryGuruState createState() => _HistoryGuruState();
}

class _HistoryGuruState extends State<HistoryGuru> {
  @override
  void initState() {
    super.initState();
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
                      children: DataDummy.dummyHistory.map((value) {
                        return CardHistoryGuru(
                          image: value["image"].toString(),
                          nama: value["nama"].toString(),
                          qty: value["qty"] as int,
                          status: value["status"] as int == 3 ? true : false,
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
