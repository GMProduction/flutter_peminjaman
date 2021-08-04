import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                  image: NetworkImage('https://smkikipsby.sch.id/wp-content/uploads/2014/06/cropped-LOGO.png'),
                  fit: BoxFit.fill
                )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Text("Selamat Datang Di Sistem Informasi Peminjaman Alat Praktek", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24), textAlign: TextAlign.center,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightBlue
                    ),
                    child: Center(child: Text("Login Siswa", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.lightBlue
                    ),
                    child: Center(child: Text("Login Guru", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
