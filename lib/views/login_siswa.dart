import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peminjaman/helper/base_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSiswa extends StatefulWidget {
  const LoginSiswa({Key? key}) : super(key: key);

  @override
  _LoginSiswaState createState() => _LoginSiswaState();
}

class _LoginSiswaState extends State<LoginSiswa> {
  String username = '';
  String password = '';
  bool isLoading = false;

  void login() async {
    try {
      setState(() {
        isLoading = true;
      });
      var params = {"username": username, "password": password};
      final response = await Dio().post('$HostAddress/login',
          options: Options(
              headers: {HttpHeaders.contentTypeHeader: "application/json"}),
          data: jsonEncode(params));
      final int code = response.data['status'] as int;
      print(response.data);
      if (code == 200) {
        final String token = response.data['data']['token'] as String;
        final String role = response.data['data']['role'] as String;
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("token", token);
        preferences.setString("role", role);
        Fluttertoast.showToast(
            msg: "Login Berhasil Token $token",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushNamedAndRemoveUntil(
            context, "/dashboard", ModalRoute.withName("/dashboard"));
      } else {
        Fluttertoast.showToast(
            msg: "Login Gagal Silahkan Cek Username Dan Password...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: "Terjadi Kesalahan Pada Server...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      isLoading = false;
    });
  }

  // void dummyLogin() {
  //   if (username == "root" && password == "123456") {
  //     Navigator.pushNamed(context, "/dashboard");
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "Login Gagal Silahkan Cek Username Dan Password...",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.black,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(BaseAvatar), fit: BoxFit.fill)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  username = text;
                });
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  prefixIcon: Icon(Icons.account_circle),
                  hintText: 'Username'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  password = text;
                });
              },
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Password'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                if (!isLoading) {
                  login();
                  // dummyLogin();
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.lightBlue),
                child: Center(
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Loading",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )
                          ],
                        )
                      : Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
