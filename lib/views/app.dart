import 'package:flutter/material.dart';
import 'package:template/views/base/custom_bottom_navbar.dart';
import 'package:template/views/screens/common/account.dart';
import 'package:template/views/screens/common/inbox.dart';
import 'package:template/views/screens/common/orders.dart';
import 'package:template/views/screens/driver/earnings/driver_earnings.dart';
import 'package:template/views/screens/driver/home/driver_home.dart';
import 'package:template/views/screens/user/home/user_home.dart';

final GlobalKey<AppState> appKey = GlobalKey<AppState>();

void setAppTab(int newIndex) {
  final state = appKey.currentState;
  if (state == null) {
    return;
  }
  state.setIndex(newIndex);
}

class App extends StatefulWidget {
  final bool isUser;
  const App({super.key, this.isUser = true});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  int index = 0;
  List<Widget> userPages = [
    UserHome(),
    Orders(),
    Inbox(),
    Account(isUser: true),
  ];
  List<Widget> driverPages = [
    DriverHome(),
    Orders(isUser: false),
    DriverEarnings(),
    Inbox(),
    Account(isUser: false),
  ];

  void setIndex(int newIndex) {
    if (newIndex == index) {
      return;
    }
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.isUser ? userPages[index] : driverPages[index],
      bottomNavigationBar: CustomBottomNavbar(
        index: index,
        isUser: widget.isUser,
        onChanged: (val) {
          setIndex(val);
        },
      ),
    );
  }
}
