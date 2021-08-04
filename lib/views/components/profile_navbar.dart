import 'package:flutter/material.dart';
import 'package:peminjaman/helper/base_helper.dart';
import 'package:peminjaman/views/components/circle_logo.dart';

class ProfileNavbar extends StatelessWidget {
  final String avatar;
  final String nama;
  final String kelas;
  final double height;
  final Color background;
  final Color textColor;
  final bool isGuru;

  const ProfileNavbar({
    Key? key,
    this.avatar = BaseAvatar,
    this.nama = 'Guest',
    this.kelas = "",
    this.height = 75,
    this.background = Colors.white,
    this.textColor = Colors.black,
    this.isGuru = false
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      color: this.background,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat Datang", 
                style: TextStyle(
                  color: this.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                ),
              ),
              !isGuru ? Text(
                "${this.nama} (${this.kelas})"
              ) : Text(
                this.nama
              )
            ],
          ),
          CircleLogo(image: this.avatar, size: 50,)
        ],
      ),
    );
  }
}
