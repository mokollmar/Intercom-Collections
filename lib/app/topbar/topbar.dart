import 'package:dashboard/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Topbar extends StatefulWidget {
  final VoidCallback? onDrawer;
  const Topbar.desktop({super.key}) : onDrawer = null;
  const Topbar.mobile({super.key, required this.onDrawer});

  @override
  State<Topbar> createState() => _TopbarState();
}

class _TopbarState extends State<Topbar> {
  final List<IconData> _icons = [FontAwesomeIcons.question, FontAwesomeIcons.solidBell, FontAwesomeIcons.solidUser];
  final List<String> _titles = ["need Help?", "Notifications", "Account"];

  final List<dynamic> messages = [
    {"title": ""}
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.75), width: 2)),
        ),
        child: SafeArea(child: Device.isSmartphone(context) ? _mobileTopBar() : _desktopTopBar()));
  }

  Widget _mobileTopBar() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.center,
      children: [
        //* Logo:
        Container(
          width: screenWidth,
          margin: EdgeInsets.symmetric(horizontal: screenWidth / 10),
          height: double.infinity,
          padding: const EdgeInsets.all(10.0),
          child: FittedBox(child: SvgPicture.asset("assets/logo.svg")),
        ),

        mobilePositioned(isLeft: true),
        mobilePositioned(isLeft: false)
      ],
    );
  }

  Widget _desktopTopBar() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //* Logo:
        Container(
          width: screenWidth / 7,
          height: double.infinity,
          padding: const EdgeInsets.all(10.0),
          child: FittedBox(child: SvgPicture.asset("assets/logo.svg")),
        ),

        //* Right Part
        desktopRightMenu(),
      ],
    );
  }

  // ---

  Widget desktopRightMenu() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeigth = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _icons.length,
        separatorBuilder: (context, index) => SizedBox(width: screenWidth / 50),
        itemBuilder: (context, index) {
          return PopupMenuButton(
              onSelected: (value) {},
              tooltip: _titles[index],
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              offset: Offset(0, screenHeigth / 14),
              child: Container(
                width: screenWidth / 40,
                height: double.infinity,
                margin: EdgeInsets.symmetric(vertical: screenHeigth / 100),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.25),
                  border: Border.all(width: 2.0, color: Colors.black.withOpacity(0.75)),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeigth / 50),
                  child: FittedBox(
                    child: FaIcon(_icons[index], color: Colors.black54),
                  ),
                ),
              ),
              itemBuilder: (BuildContext context) {
                switch (index) {
                  case 0:
                    return notificationPopup(index: index);
                  case 2:
                    return notificationPopup(index: index);
                  default:
                    return [
                      PopupMenuItem(
                        enabled: false,
                        padding: EdgeInsets.symmetric(vertical: screenHeigth / 50),
                        textStyle: GoogleFonts.inder(color: Colors.black.withOpacity(0.75), fontWeight: FontWeight.w800),
                        child: SizedBox(
                          width: screenWidth / 8,
                          child: Center(
                            child: Text(
                              _titles[index],
                              textScaler: const TextScaler.linear(1.25),
                            ),
                          ),
                        ),
                      ),
                    ];
                }
              });
        },
      ),
    );
  }

  Widget mobilePositioned({required bool isLeft}) {
    return Positioned(
      left: isLeft ? 0 : null,
      right: !isLeft ? 0 : null,
      child: Container(
        width: 25,
        height: 25,
        margin: const EdgeInsets.all(15),
        child: GestureDetector(
          onTap: () => widget.onDrawer!(),
          child: FittedBox(
            child: FaIcon(isLeft ? FontAwesomeIcons.bars : FontAwesomeIcons.bell, color: Colors.black.withOpacity(0.75)),
          ),
        ),
      ),
    );
  }

  List<PopupMenuEntry<dynamic>> notificationPopup({required int index}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeigth = MediaQuery.of(context).size.height;

    final List<dynamic> menuIcons = [
      [FontAwesomeIcons.alignCenter, FontAwesomeIcons.solidEnvelope, FontAwesomeIcons.question],
      [],
      [FontAwesomeIcons.userGear, FontAwesomeIcons.receipt, FontAwesomeIcons.users, FontAwesomeIcons.rightFromBracket]
    ];
    final List<dynamic> menuTitles = [
      ["Help Desk", "eMail Support", "FAQ Section"],
      [],
      ["Profil", "Abrechung", "Team hinzufügen", "Logout"],
    ];

    return [
      PopupMenuItem(
        enabled: false,
        padding: EdgeInsets.symmetric(vertical: screenHeigth / 50),
        textStyle: GoogleFonts.inder(color: Colors.black.withOpacity(0.75), fontWeight: FontWeight.w800),
        child: Container(
          width: double.infinity,
          color: Colors.redAccent,
          child: Text(_titles[index], textAlign: TextAlign.center, textScaler: const TextScaler.linear(1.3)),
        ),
      ),
      for (var i = 0; i < menuTitles[index].length; i++) ...[
        PopupMenuItem(
          value: "/${menuTitles[index][i].toLowerCase().replaceAll(' ', '')}",
          textStyle: GoogleFonts.inder(color: Colors.black.withOpacity(0.75), fontWeight: FontWeight.w800),
          padding: EdgeInsets.symmetric(horizontal: screenWidth / 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(flex: 1, child: FaIcon(menuIcons[index][i], color: Colors.black.withOpacity(0.75))),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(left: screenWidth / 150),
                  child: Align(alignment: Alignment.centerLeft, child: Text(menuTitles[index][i])),
                ),
              ),
            ],
          ),
        ),
      ],
    ];
  }
}
