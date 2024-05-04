import 'package:app_mobi/home_page/home_page.dart';
import 'package:app_mobi/main.dart';
import 'package:app_mobi/my_share/background.dart';
import 'package:app_mobi/my_share/my_text_style.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget{
  const MainScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.blue, Colors.white], // Các màu sắc cho gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.6, 0.95], // Điểm dừng của gradient
            tileMode: TileMode.clamp,
          ),
        ),
        child: HomePage(),
      ),
    );
  }

}