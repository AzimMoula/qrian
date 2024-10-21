import 'package:qrian/services/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Change Theme',
      // color: Colors.black,
      onPressed: () async {
        Provider.of<QRIANProvider>(context, listen: false).toggleTheme();
      },
      icon: AnimatedSwitcher(
        switchInCurve: Curves.bounceOut,
        switchOutCurve: Curves.bounceIn,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: RotationTransition(
              turns: Tween<double>(begin: 0.75, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        child: Icon(
          Theme.of(context).brightness == Brightness.light
              ? Icons.dark_mode
              : Icons.light_mode,
          key: ValueKey(Theme.of(context).brightness == Brightness.light
              ? 'light'
              : 'dark'),
        ),
      ),
    );
  }
}
