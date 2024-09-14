
import 'package:dashboard/data/data.dart';
import 'package:dashboard/app/sidebar/menu_tab.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum DDevice { mobile, desktop }

class SidebarContent extends StatefulWidget {
  final DDevice device;
  final Function(bool value)? onMinimize;
  final bool? isMinimized;

  const SidebarContent.mobile({
    super.key,
    this.device = DDevice.mobile,
    this.onMinimize,
    this.isMinimized,
  });

  const SidebarContent.desktop({
    super.key,
    this.device = DDevice.desktop,
    required this.onMinimize,
    required this.isMinimized,
  });

  @override
  State<SidebarContent> createState() => _SidebarContentState();
}

class _SidebarContentState extends State<SidebarContent> {
  int _currentIndex = 0;

  //*
  final List<Map<String, dynamic>> _menuMap = MyMap.menu;

  final ScrollController _myController = ScrollController();
  //*

  void _updateIndex({required int idx}) async {
    setState(() => _currentIndex = 100);
    await Future.delayed(const Duration(milliseconds: 250));
    setState(() => _currentIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeigth = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = widget.device == DDevice.mobile;

    return SafeArea(
      child: ClipRRect(
        borderRadius: isMobile
            ? const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(10),
              )
            : BorderRadius.zero,
        child: Container(
          height: double.infinity,
          width: isMobile ? screenWidth * 0.66 : null,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
          child: Column(
            children: [
              //* Header:
              isMobile
                  ? SizedBox(
                      height: screenHeigth / 8,
                      child: DrawerHeader(
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                        child: const Center(child: Text('Drawer Header', style: TextStyle(fontWeight: FontWeight.w800))),
                      ),
                    )
                  : const SizedBox.shrink(),

              //* Content:
              Expanded(
                child: Column(
                  children: [
                    //* Menu Items:
                    Expanded(child: _tabsList()),
                    SizedBox(height: screenHeigth / 15), // Minimum Seperation
                    if (!isMobile) ...[_minimizeWidget()]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabsList() {
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = widget.device == DDevice.mobile;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight / 30),
      child: Scrollbar(
        radius: const Radius.circular(250),
        scrollbarOrientation: ScrollbarOrientation.right,
        thumbVisibility: true,
        controller: _myController,
        child: ListView.separated(
          shrinkWrap: true,
          controller: _myController,
          itemCount: _menuMap.length,
          separatorBuilder: (context, index) => SizedBox(height: screenHeight / 150),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return MenuTab(
              map: _menuMap[index],
              onTab: (idx, subIdx) => subIdx == -1 ? _updateIndex(idx: idx) : debugPrint("Sub-Index clicked: $subIdx"),
              index: index,
              currentIndex: _currentIndex,
              subChildren: _menuMap[index]["children"],
              isMinimized: !isMobile ? widget.isMinimized! : false,
            );
          },
        ),
      ),
    );
  }

  Widget _minimizeWidget() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight / 25,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: !widget.isMinimized! ? screenWidth / 50 : screenWidth / 350),
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black.withOpacity(0.25), width: 5.0)),
      child: InkWell(
        onTap: () => widget.onMinimize!(!widget.isMinimized!),
        child: FittedBox(
          child: FaIcon(widget.isMinimized ?? false ? FontAwesomeIcons.caretRight : FontAwesomeIcons.caretLeft, color: Colors.black.withOpacity(0.5)),
        ),
      ),
    );
  }
}
