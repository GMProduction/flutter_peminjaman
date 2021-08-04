import 'package:flutter/material.dart';
import 'package:peminjaman/helper/base_helper.dart';

class CircleLogo extends StatelessWidget {
  final double size;
  final String image;

  const CircleLogo({
    Key? key,
    this.size = 120,
    this.image = BaseAvatar
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.size,
      width: this.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.lightBlue,
        image: DecorationImage(
          image: NetworkImage(this.image),
          fit: BoxFit.cover
        )
      ),
    );
  }
}
