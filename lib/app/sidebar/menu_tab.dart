import 'package:dashboard/device.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuTab extends StatefulWidget {
  final Map<String, dynamic> map;
  final int index;
  final int currentIndex;
  final List<dynamic>? subChildren;
  final Function(int idx, int subIdx) onTab;
  final bool isMinimized;
  const MenuTab({
    super.key,
    required this.map,
    required this.onTab,
    required this.index,
    required this.currentIndex,
    required this.isMinimized,
    this.subChildren,
  });

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  bool childrenState = false;
  int _currentSubChild = -1;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = Device.isSmartphone(context);

    return Column(
      children: [
        // Tabs:
        Padding(
          padding: EdgeInsets.only(left: !isMobile ? screenWidth / 450 : screenWidth / 150, right: !isMobile ? screenWidth / 150 : screenWidth / 50),
          child: tab(map: widget.map),
        ),

        // Children:
        if (childrenState) ...[
          Padding(
            padding: EdgeInsets.only(left: !isMobile ? screenWidth / 30 : screenWidth / 10, right: !isMobile ? screenWidth / 150 : screenWidth / 50),
            child: ListView.builder(
              itemCount: widget.subChildren?.length ?? 0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (widget.subChildren == null) {
                  return const SizedBox.shrink();
                }

                //* Sub Menu:
                final map = widget.subChildren?[index];
                return tab(map: map, isSubMenu: true, subIndex: index);
              },
            ),
          )
        ]
      ],
    );
  }

  Widget tab({required Map<String, dynamic> map, bool isSubMenu = false, int subIndex = -1}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeigth = MediaQuery.of(context).size.height;
    final hasSubChildren = (widget.subChildren?.length ?? 0) != 0;
    final isMobile = Device.isSmartphone(context);

    Color? color = !childrenState
        ? widget.currentIndex == widget.index
            ? Colors.white
            : Colors.black54
        : subIndex == _currentSubChild
            ? Colors.white
            : Colors.black54;

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(vertical: !isSubMenu ? 5 : 2, horizontal: !widget.isMinimized ? 2 : screenWidth / 250),
          padding: EdgeInsets.symmetric(vertical: screenHeigth / 300, horizontal: !isMobile ? screenWidth / 300 : screenWidth / 200),
          height: !isSubMenu ? screenHeigth / 20 : screenHeigth / 23,
          decoration: tabDecoration(subIndex: subIndex, isSubMenu: isSubMenu),
          child: InkWell(
            onTap: () {
              widget.onTab(widget.index, subIndex);
              hasSubChildren && !isSubMenu ? setState(() => childrenState = !childrenState) : null;
              hasSubChildren && isSubMenu ? setState(() => _currentSubChild = subIndex) : null;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //* Icon:

                Expanded(
                  child: Container(
                    // color: Colors.amberAccent,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: !isMobile
                              ? !widget.isMinimized
                                  ? screenWidth / 150
                                  : 0
                              : screenWidth / 25,
                          right: !isMobile
                              ? !widget.isMinimized
                                  ? screenWidth / 600
                                  : 0
                              : screenWidth / 100),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeigth / 150),
                        alignment: !widget.isMinimized ? Alignment.centerLeft : Alignment.center,
                        child: FittedBox(child: FaIcon(map["icon"], color: color)),
                      ),
                    ),
                  ),
                ),

                if (!widget.isMinimized) ...[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(left: !isMobile ? screenWidth / 500 : screenWidth / 250),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: !isMobile ? screenHeigth / 150 : screenHeigth / 250),
                        // color: Colors.blue,
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            // color: Colors.redAccent,
                            child: Text(
                              map["title"],
                              style: GoogleFonts.inter(color: color, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Chevron:
        if (!isSubMenu && hasSubChildren && !widget.isMinimized) ...[
          Positioned(
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(right: !isMobile ? screenWidth / 120 : screenWidth / 50),
              child: InkWell(
                onTap: () => setState(() => childrenState = !childrenState),
                child: Container(
                  width: 15,
                  height: 15,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child: FittedBox(alignment: Alignment.center, child: FaIcon(FontAwesomeIcons.chevronDown, color: Colors.black.withOpacity(0.5))),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  BoxDecoration tabDecoration({required int subIndex, required bool isSubMenu}) {
    return BoxDecoration(
      color: !childrenState
          ? widget.currentIndex == widget.index
              ? Theme.of(context).colorScheme.primary
              : null
          : subIndex == _currentSubChild
              ? Theme.of(context).colorScheme.primary
              : null,
      borderRadius: !childrenState
          ? widget.currentIndex == widget.index
              ? const BorderRadius.all(Radius.circular(250))
              : null
          : subIndex == _currentSubChild
              ? const BorderRadius.all(Radius.circular(250))
              : null,
      border: !isSubMenu
          ? Border.symmetric(
              horizontal: BorderSide(
                color: !childrenState
                    ? widget.currentIndex == widget.index
                        ? Colors.black12
                        : Colors.transparent
                    : subIndex == _currentSubChild
                        ? Colors.black12
                        : Colors.transparent,
                width: 2.0,
              ),
            )
          : null,
    );
  }
}


// PopupMenuButton(
//   child: ClipRRect(
//     borderRadius: BorderRadius.circular(100),
//     child: Image.asset(
//       "assets/images/logo.png",
//       width: 50,
//     ),
//   ),
//   onSelected: (value) {
//     if (value == "profile") {
//       // add desired output
//     }else if(value == "settings"){
//       // add desired output
//     }else if(value == "logout"){
//       // add desired output
//     }
//   },
//   itemBuilder: (BuildContext context) => <PopupMenuEntry>[
//     PopupMenuItem(
//       value: "profile",
//       child: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: Icon(Icons.account),
//           ),
//           const Text(
//             'Profile',
//             style: TextStyle(fontSize: 15),
//           ),
//         ],
//       ),
//     ),
//     PopupMenuItem(
//       value: "settings",
//       child: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: Icon(Icons.settings)
//           ),
//           const Text(
//             'Settings',
//             style: TextStyle(fontSize: 15),
//           ),
//         ],
//       ),
//     ),
//     PopupMenuItem(
//       value: "logout",
//       child: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//              child: Icon(Icons.logout)
//           ),
//           const Text(
//             'Logout',
//             style: TextStyle(fontSize: 15),
//           ),
//         ],
//       ),
//     ),
//   ],
// )