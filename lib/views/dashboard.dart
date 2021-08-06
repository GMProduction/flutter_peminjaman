import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peminjaman/helper/base_helper.dart';
import 'package:peminjaman/model/barang.dart';
import 'package:peminjaman/views/components/bottom_navbar.dart';
import 'package:peminjaman/views/components/card_barang.dart';
import 'package:peminjaman/views/components/profile_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Barang> barang = [];
  bool isLoading = true;
  String token = '';
  String avatar = BaseAvatar;
  String nama = "Nama Siswa";
  String kelas = "Kelas";
  // List<dynamic> dummyBarang = [];
  List<dynamic> _listBarang = [];
  @override
  void initState() {
    super.initState();
    getProfile();
    fetchBarang();
  }

  void fetchBarang() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await Dio().get('$HostAddress/barang');
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

  void getProfile() async {
    String url = "$HostAddress/siswa";
    String _token = await GetToken();
    try {
      final response = await Dio().get(url,
          options: Options(headers: {
            "Authorization": "Bearer $_token",
            "Accept": "application/json"
          }));

      setState(() {
        avatar = response.data["payload"]["get_siswa"]["image"] == null
            ? BaseAvatar
            : "$HostImage${response.data["payload"]["get_siswa"]["image"]}";
        nama = response.data["payload"]["get_siswa"]["nama"].toString();
        kelas = response.data["payload"]["get_siswa"]["kelas"].toString();
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

  // void fetchDummyData() async {
  //   Future.delayed(const Duration(seconds: 2));
  //   setState(() {
  //     dummyBarang = DataDummy.data;
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ProfileNavbar(
              avatar: avatar,
              nama: nama,
              kelas: kelas,
              isGuru: false,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Alat yang tersedia"),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/pencarian');
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade300),
                        child: Row(
                          children: [
                            Expanded(child: Text("Cari alat..")),
                            Icon(
                              Icons.search,
                              size: 20,
                            )
                          ],
                        ),
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
                                    children: _listBarang
                                        .map((barang) => GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/detail',
                                                  arguments: barang["id"]);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: CardBarang(
                                                image:
                                                    "$HostImage${barang["image"].toString()}",
                                                nama: barang["nama_barang"]
                                                    .toString(),
                                                stock: barang["qty"] as int,
                                              ),
                                            )))
                                        .toList())))
                  ],
                ),
              ),
            ),
            BottomNavbar()
          ],
        ),
      ),
    );
  }
}
