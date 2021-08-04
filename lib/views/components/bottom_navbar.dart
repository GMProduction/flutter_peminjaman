import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int selected;

  const BottomNavbar({Key? key, this.selected = 0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, -2))
      ]),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/dashboard');
              },
              child: Icon(
                Icons.home,
                size: 26,
                color: selected == 0 ? Colors.lightBlue : Colors.grey,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/history');
              },
              child: Icon(
                Icons.access_time,
                size: 26,
                color: selected == 1 ? Colors.lightBlue : Colors.grey,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/profil");
              },
              child: Icon(
                Icons.account_circle,
                size: 26,
                color: selected == 2 ? Colors.lightBlue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
