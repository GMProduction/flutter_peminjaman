import 'package:flutter/material.dart';
import 'package:peminjaman/helper/base_helper.dart';

class DetailPeminjaman extends StatefulWidget {
  @override
  _DetailPeminjamanState createState() => _DetailPeminjamanState();
}

class _DetailPeminjamanState extends State<DetailPeminjaman> {
  dynamic detail = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var arguments = ModalRoute.of(context)!.settings.arguments;
      print(arguments);
      setState(() {
        detail = arguments;
      });
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text(
                      "Detail Pinjaman",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(detail["image"] != null ? detail["image"].toString() : BaseAvatar),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama Alat : "),
                                Text(detail["nama"] != null ? detail["nama"].toString() : '')
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jumlah Pinjam : "),
                                Text(detail["qty"] != null ? detail["qty"].toString() : '')
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tanggal Pinjam : "),
                                Text(detail["tanggal"] != null ? detail["tanggal"].toString() : '')
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text("Detail Peminjam", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(FaceAvatar),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama : "),
                                Text(detail["nama"] != null ? detail["nama"].toString() : '')
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Kelas : "),
                                Text(detail["qty"] != null ? detail["qty"].toString() : '')
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
              child: Row(
                children: [
                  Flexible(
                    flex: 1, 
                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text("Terima", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
                      ),
                    )
                  ),
                  SizedBox(width: 10,),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.red[300],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text("Tolak", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
                      ),
                    ),
                  )

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
