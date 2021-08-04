import 'package:flutter/material.dart';

class CardPeminjaman extends StatelessWidget {
  final String image;
  final String nama;
  final String tanggal;
  final int qty;
  const CardPeminjaman(
      {Key? key,
      this.image = '',
      this.nama = '',
      this.tanggal = '',
      this.qty = 0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Container(
          height: 120,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: Colors.black12.withOpacity(0.1), width: 1),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(2, 2))
            ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.lightBlue,
                  image: DecorationImage(
                    image: NetworkImage(this.image),
                    fit: BoxFit.cover
                  )
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(this.nama, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    Text("Jumlah Pinjam : ${this.qty.toString()}"),
                    Text("Tanggal Pinjam : ${this.tanggal}"),
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }
}