import 'package:dashboard/app/sidebar/sidebar_content.dart';
import 'package:dashboard/app/sidebar/sidebar_desktop.dart';
import 'package:dashboard/app/topbar/topbar.dart';
import 'package:dashboard/content.dart';
import 'package:dashboard/device.dart';
import 'package:flutter/material.dart';

class EasyDashboard extends StatefulWidget {
  const EasyDashboard({super.key});

  @override
  State<EasyDashboard> createState() => _EasyDashboardState();
}

class _EasyDashboardState extends State<EasyDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeigth = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: !Device.isSmartphone(context) ? Size(screenWidth, screenHeigth / 11) : Size(screenWidth, screenHeigth / 13),
        child: !Device.isSmartphone(context) ? const Topbar.desktop() : Topbar.mobile(onDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      ),
      drawer: !Device.isSmartphone(context) ? null : const SidebarContent.mobile(),
      body: Row(
        children: [
          //* Sidebar
          const Sidebar(),

          //* Content
          Expanded(
            child: Container(
              color: Colors.white,
              child: const MyHomePage(title: 'My Flutter Home Page'),
            ),
          ),
        ],
      ),
    );
  }
}
