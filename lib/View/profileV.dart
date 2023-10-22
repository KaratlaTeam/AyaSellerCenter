import 'package:aya_seller_center/Logic/rootL.dart';
import 'package:aya_seller_center/Model/shopM.dart';
import 'package:aya_seller_center/main.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RL>(
      builder: (_){
        return Scaffold(
          //appBar: AppBar(),
          body: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: (){
                      Get.toNamed(RN.setting);
                    },
                    icon: Icon(Icons.settings),
                  ),
                ],
              ),

              Container(
                //margin: EdgeInsets.only(top: Get.height*30/1000),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 5,
                      child: Container(
                        height: Get.height*7/100,
                        width: Get.width*80/100,
                        //color: Colors.blue,
                        child: Column(
                          children: [
                            ListTile(
                              //leading: Image.asset(name),
                              title: Text(_.rS.rM.userM.name),
                              //subtitle: Text('Shop: ${_.rS.rM.shopMList.isNotEmpty ? _.rS.rM.shopMList[0].name : ''}'),
                              trailing: Text('ID: ${_.rS.rM.userM.id}'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //margin: EdgeInsets.only(top: Get.height*30/1000),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 5,
                      child: Container(
                        height: Get.height*15/100,
                        width: Get.width*80/100,
                        //color: Colors.blue,
                        child: Column(
                          children: [
                            ListTile(
                              //leading: Image.asset(name),
                              title: Text(_.rS.rM.shopMList.shopMList.isNotEmpty?_.rS.rM.shopMList.shopMList[0].name:''),
                              subtitle: Text(_.rS.rM.shopMList.shopMList.isNotEmpty ? _.rS.rM.shopMList.shopMList[0].description : ''),
                              //trailing: Text('ID: ${_.rS.rM.userM.id}'),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: Get.height*4/100),
                              //color: Colors.blue,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Orders: ${_.rS.rM.orderMList.orderMList.length}'),
                                  Text('Products: ${_.rS.rM.productMList.productMList.length}'),
                                  Text('Other: 0'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: _.rS.rM.shopMList.shopMList.isEmpty ?
          FloatingActionButton(
            child: const Text('Add'),
            onPressed: (){
              Get.to(()=>NewShopView());
            },
          ) : Container(),
        );
      },
    );
  }

}


class NewShopView extends StatefulWidget {
  const NewShopView({super.key});

  @override
  State<NewShopView> createState() => _NewShopViewState();
}
class _NewShopViewState extends State<NewShopView>{

  //final _formKey1 = GlobalKey<FormBuilderState>();
  String name = '';
  String description = '';


  @override
  Widget build(BuildContext context) {
    return GetBuilder<RL>(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create new shop'),
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(vertical: 40),
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: Get.width*80/100,
                      child: ListTile(
                        //title: Text('Shop Name'),
                        subtitle: FormBuilder(
                          //key: _formKey1,
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                name: 'Shop Name',
                                decoration: InputDecoration(
                                  labelText: 'Shop Name',
                                ),
                                onChanged: (val) {
                                  name = val!;
                                },
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                              FormBuilderTextField(
                                name: 'Description',
                                maxLines: 5,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                ),
                                onChanged: (val) {
                                  description = val!;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        _.newShop(ShopM(name: name, description: description));
                      },
                      child: Text('Create'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
