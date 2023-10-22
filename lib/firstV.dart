import 'package:flutter/material.dart';

class FirstView extends StatelessWidget{
  const FirstView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome'),
      ),
    );
  }

}