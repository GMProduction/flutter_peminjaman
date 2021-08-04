import 'package:flutter/material.dart';

class CardBarang extends StatelessWidget {
  final String image;
  final String nama;
  final int stock;
  const CardBarang(
      {Key? key,
      this.image = '',
      this.nama = '',
      this.stock = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
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
            ]),
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
                      image: NetworkImage(this.image),
                      fit: BoxFit.cover)),
            ),
            Expanded(
                child: Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.nama,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Sisa Stok : ${this.stock.toString()}',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
