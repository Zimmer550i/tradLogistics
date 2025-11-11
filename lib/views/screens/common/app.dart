import 'package:flutter/material.dart';
import 'package:template/views/base/custom_bottom_navbar.dart';
import 'package:template/views/screens/common/account.dart';
import 'package:template/views/screens/common/inbox.dart';
import 'package:template/views/screens/common/orders.dart';
import 'package:template/views/screens/driver/earnings/driver_earnings.dart';
import 'package:template/views/screens/driver/home/driver_home.dart';

class App extends StatefulWidget {
  final bool isUser;
  const App({super.key, this.isUser = true});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int index = 0;
  List<Widget> userPages = [FlutterLogo(), Orders(), Inbox(), Account()];
  List<Widget> driverPages = [
    DriverHome(),
    Orders(canSeePast: false),
    DriverEarnings(),
    Inbox(),
    Account(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.isUser ? userPages[index] : driverPages[index],
      bottomNavigationBar: CustomBottomNavbar(
        index: index,
        isUser: widget.isUser,
        onChanged: (val) {
          setState(() {
            index = val;
          });
        },
      ),
    );
  }
}
