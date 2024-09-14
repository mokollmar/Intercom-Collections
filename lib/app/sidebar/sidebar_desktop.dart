import 'package:dashboard/device.dart';
import 'package:dashboard/app/sidebar/sidebar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late final screenWidth = MediaQuery.of(context).size.width;
  late final double _defaultWidth = screenWidth / 7;
  late final double _minimizedWidth = screenWidth / 20;

  // Current Width:
  late double _currentWidth = _defaultWidth;
  late bool _isMinimzed = false;

  bool showedErrorMessage = false;

  void _onMinimize(bool value) {
    setState(() {
      _currentWidth = value ? _minimizedWidth : _defaultWidth;
      _isMinimzed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Device.isSmartphone(context)
        ? const SizedBox.shrink()
        : Row(
            children: [
              Container(
                color: Theme.of(context).colorScheme.secondary,
                child: SizedBox(
                  width: _currentWidth,
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SidebarContent.desktop(
                      onMinimize: (value) => _onMinimize(value),
                      isMinimized: _isMinimzed,
                    ),
                  ),
                ),
              ),

              // Draggable Seperator
              MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    final delta = details.delta.dx;
                    final newWidth = _currentWidth + delta;
                    final isLeftDrag = delta < 0;

                    // If the width is smaller then normal & we drag to the left
                    if ((newWidth < _defaultWidth) && isLeftDrag) {
                      _onMinimize(true);
                      // If the width is smaller then normal & we drag to the right
                    } else if ((newWidth < _defaultWidth) && !isLeftDrag) {
                      _onMinimize(false);
                    } else {
                      // Dragged to the right => max at screenWidth / 3
                      if (newWidth < screenWidth / 3) {
                        setState(() => _currentWidth += delta);
                      } else if (!showedErrorMessage) {
                        showedErrorMessage = true;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Sorry this is too large.", style: GoogleFonts.inter(color: Colors.white.withOpacity(0.75), fontWeight: FontWeight.w800)),
                          backgroundColor: Colors.redAccent,
                        ));
                      }
                    }
                  },
                  child: Container(
                    height: double.infinity,
                    width: 2,
                    color: Colors.black.withOpacity(0.75),
                  ),
                ),
              )
            ],
          );
  }
}
