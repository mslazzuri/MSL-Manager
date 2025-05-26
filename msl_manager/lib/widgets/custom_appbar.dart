import 'package:flutter/material.dart';
import 'package:msl_manager/themes/globals.dart' as globals;

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
          color: globals.neonGreen,
        ),
      ),
      actions: widget.actions,
      backgroundColor: globals.appBarColor,
      iconTheme: IconThemeData(
        color: globals.gray,
      ),
      surfaceTintColor: Colors.transparent,
    );
  }
}