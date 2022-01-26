import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),
        IconButton(onPressed: () {}, icon: Icon(Icons.people)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: Icon(Icons.list_alt)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: Icon(Icons.login)),
        const Spacer(flex: 2),
      ],
    );
  }
}
