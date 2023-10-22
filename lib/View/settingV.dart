import 'package:aya_seller_center/Logic/rootL.dart';
import 'package:aya_seller_center/main.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RL>(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text('Setting'),
          ),
          body: ListView(
            children: [
              ListTile(
                title: Text('Account'),
                onTap: (){},
              ),
              ListTile(
                title: Text('About'),
                onTap: (){},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      _.logout();
                    },
                    child: Text('Logout'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

}
