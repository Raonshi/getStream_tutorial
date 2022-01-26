import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/login_ctrl.dart';
import 'package:single_chat_practice/pages/home_page.dart';

class LoginInputWidget extends StatelessWidget {
  LoginInputWidget({Key? key}) : super(key: key);
  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        _buildLoginInputWidget('ID'),
        const Spacer(),
        _buildLoginInputWidget('NAME'),
        const Spacer(),
        ElevatedButton(
          onPressed: () {},
          child: Text('Login'),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildLoginInputWidget(String label) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
