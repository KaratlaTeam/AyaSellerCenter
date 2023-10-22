import 'dart:convert';
import 'dart:io';

import 'package:aya_seller_center/Logic/rootL.dart';
import 'package:aya_seller_center/View/homeV.dart';
import 'package:aya_seller_center/stringSources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _ = Get.find<RL>();

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      var code = await this._.login(data.name, data.password);
      if(code == 0){
        return 'error';
      }else{
        return null;
      }
    });
  }

  Future<String?> _signupUser(SignupData data) {
    var name = data.name?.substring(0,data.name?.indexOf('@'));
    //debugPrint('Signup Name: $name,Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async{
      var code = await this._.signup(name!, data.name!, data.password!);
      if(code == 0){
        return 'error';
      }else{
        return null;
      }
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {

      return 'null';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: FlutterLogin(
        title: 'Aya',
        logo: const AssetImage('assets/images/Aya_logo.png'),
        onLogin: _authUser,
        onSignup: _signupUser,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomeView(),
          ));
        },
        loginAfterSignUp: false,
        onRecoverPassword: _recoverPassword,
        onSwitchToAdditionalFields: (s){
          printInfo(info: s.additionalSignupData.toString());
        },
        additionalSignupFields: [
          UserFormField(
            keyName: 'username',
            displayName: 'Username',
            userType: LoginUserType.name,
            //icon: Icon(FontAwesomeIcons.userLarge),
            fieldValidator: (val){
              return null;
            }
          ),
          UserFormField(
            keyName: 'username2',
            displayName: 'Username2',
            userType: LoginUserType.name,
            //icon: Icon(FontAwesomeIcons.userLarge),
              fieldValidator: (val){
                return null;
              }
          ),
          UserFormField(
            keyName: 'username3',
            displayName: 'Username3',
            userType: LoginUserType.name,
            //icon: Icon(FontAwesomeIcons.userLarge),
              fieldValidator: (val){
                return null;
              }
          ),
          UserFormField(
              keyName: 'username4',
              displayName: 'Username4',
              userType: LoginUserType.name,
              //icon: Icon(FontAwesomeIcons.userLarge),
              fieldValidator: (val){
                return null;
              }
          ),
        ],
      ),
    );
  }
}