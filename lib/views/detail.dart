import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peminjaman/helper/base_helper.dart';
import 'package:peminjaman/model/barang.dart';
import 'package:peminjaman/views/components/card_barang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detail extends StatefulWidget {
  const Detail({Key? key}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late int stock = 0;
  late int idBarang = 0;
  late DateTime _vTanggal = DateTime.now();
  late int _vPinjam = 0;
  late bool isLoadingSave = false;
  TextEditingController _textEditingController = TextEditingController()
    ..text = '0';
  late List<dynamic> _mapel = [];
  late dynamic _vMapel = {};
  Map<String, dynamic> _dataBarang = {};
  String token = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var arguments = ModalRoute.of(context)!.settings.arguments;
      fetchBarangById(arguments.toString());
      fetchMapel();
      print(arguments);
      cekToken();
    });
  }

  void cekToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String _dataToken = preferences.getString("token") ?? "";
    print("TOKEN : $_dataToken");
    setState(() {
      token = _dataToken;
    });
  }

  void fetchBarangById(String id) async {
    try {
      final response = await Dio().get('$HostAddress/barang/$id');
      print(response.data);
      setState(() {
        _dataBarang = {
          "id": response.data['id'] as int,
          "nama": response.data['nama_barang'] as String,
          "qty": response.data['qty'] as int,
          "image": response.data['image'] == null
              ? BaseAvatar
              : response.data['image'] as String
        };
        stock = response.data['qty'] as int;
        idBarang = response.data['id'] as int;
      });
    } on DioError catch (e) {
      print(e.toString());
    }
  }

  void fetchMapel() async {
    try {
      final response = await Dio().get('$HostAddress/mapel');
      final data = response.data as List;
      setState(() {
        _mapel = data.map((value) {
          return {"id": value['id'], "mapel": value['nama_mapel']};
        }).toList();
      });
      _vMapel = _mapel.length > 0 ? _mapel[0] : null;
      print(_mapel);
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Mengambil Data Mapel...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print(e);
    }
  }

  void pinjam() async {
    setState(() {
      isLoadingSave = true;
    });

    //cek ketersediaan stock
    if (stock < _vPinjam) {
      Fluttertoast.showToast(
          msg: "Sisa Ketersediaan Tidak Mencukupi...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Map<String, dynamic> _saveData = {
        "id_barang": idBarang,
        "id_mapel": _vMapel["id"],
        "qty": _vPinjam,
        "tanggal_pinjam":
            "${_vTanggal.year.toString()}-${_vTanggal.month.toString()}-${_vTanggal.day.toString()}"
      };
      print(_saveData);
      try {
        var formData = FormData.fromMap({
          "id_barang": idBarang,
          "id_mapel": _vMapel["id"],
          "qty": _vPinjam,
          "tanggal_pinjam":
              "${_vTanggal.year.toString()}-${_vTanggal.month.toString()}-${_vTanggal.day.toString()}"
        });
        final response = await Dio().post('$HostAddress/pinjam',
            data: formData,
            options: Options(headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json"
            }, contentType: "application/json"));
        print(response.statusCode);
        Navigator.popAndPushNamed(context, '/history');
      } on DioError catch (e) {
        Fluttertoast.showToast(
            msg: "Gagal Menyimpan Data...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        print(e.response);
      }
    }
    setState(() {
      isLoadingSave = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: CardBarang(
                image: _dataBarang["image"] != null
                    ? "$HostImage${_dataBarang["image"]}"
                    : BaseAvatar,
                nama: _dataBarang["nama"] == null
                    ? ""
                    : _dataBarang["nama"].toString(),
                stock:
                    _dataBarang["qty"] == null ? 0 : _dataBarang["qty"] as int,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Form Peminjaman",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text("Tanggal Pinjam"),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2021),
                                  lastDate: DateTime(2222))
                              .then((value) {
                            if (value != null) {
                              String tglString =
                                  "${value.day.toString()}-${value.month.toString()}-${value.year.toString()}";
                              print(tglString);
                              setState(() {
                                _vTanggal = value;
                              });
                            }
                          });
                        },
                        child: Container(
                          height: 45,
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black54, width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "${_vTanggal.day.toString().padLeft(2, "0")}-${_vTanggal.month.toString().padLeft(2, "0")}-${_vTanggal.year.toString()}"),
                              Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text("Jumlah Pinjam"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: TextField(
                          onChanged: (value) {
                            if (value == '') {
                              setState(() {
                                _vPinjam = 0;
                              });
                            } else {
                              setState(() {
                                _vPinjam = int.parse(value);
                              });
                            }
                          },
                          controller: _textEditingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding:
                                  EdgeInsets.only(left: 10, right: 10),
                              hintText: 'Cari Alat Praktek...'),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text("Mata Pelajaran"),
                      ),
                      Container(
                        width: double.infinity,
                        child: DropdownButton(
                            isExpanded: true,
                            value: _vMapel,
                            icon: const Icon(Icons.arrow_drop_down),
                            onChanged: (dynamic newValue) {
                              setState(() {
                                _vMapel = newValue;
                              });
                            },
                            iconSize: 24,
                            elevation: 16,
                            items: _mapel.map<DropdownMenuItem<dynamic>>(
                                (dynamic value) {
                              return DropdownMenuItem<dynamic>(
                                value: value,
                                child: Text(value['mapel']),
                              );
                            }).toList()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  if (!isLoadingSave) {
                    print(_vMapel);
                    print(_vTanggal.toString());
                    print(_vPinjam);
                    pinjam();
                  } else {
                    Fluttertoast.showToast(
                        msg: "Tunggu Sebentar Sedang Menyimpan Data...",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                      child: isLoadingSave
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1,
                                  ),
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Loading...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                )
                              ],
                            )
                          : Text(
                              "Simpan",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
