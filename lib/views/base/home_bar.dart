import 'package:flutter/material.dart';

class HomeBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeBar({super.key});

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 2),
        child: Row(
          children: [Image.asset("assets/images/trad.png", height: 32)],
        ),
      ),
    );
  }
}
