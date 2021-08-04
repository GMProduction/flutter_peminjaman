import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peminjaman/bloc/barang_bloc.dart';
import 'package:peminjaman/views/dashboard-guru.dart';
import 'package:peminjaman/views/dashboard.dart';
import 'package:peminjaman/views/detail.dart';
import 'package:peminjaman/views/detail_peminjaman.dart';
import 'package:peminjaman/views/history.dart';
import 'package:peminjaman/views/history_guru.dart';
import 'package:peminjaman/views/login_guru.dart';
import 'package:peminjaman/views/login_siswa.dart';
import 'package:peminjaman/views/pages/login.dart';
import 'package:peminjaman/views/pencarian.dart';
import 'package:peminjaman/views/profil_guru.dart';
import 'package:peminjaman/views/welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<BarangBloc>(create: (_) => BarangBloc())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Welcome(),
          '/login-siswa': (context) => LoginSiswa(),
          '/login-guru': (context) => LoginGuru(),
          '/dashboard': (context) => Dashboard(),
          '/dashboard-guru': (context) => DashboardGuru(),
          '/history-guru': (context) => HistoryGuru(),
          '/profil-guru': (context) => ProfilGuru(),
          '/pencarian': (context) => Pencarian(),
          '/detail': (context) => Detail(),
          '/detail-pinjam': (context) => DetailPeminjaman(),
          '/history': (context) => History(),
        },
      ),
    );
  }
}
