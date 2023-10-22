import 'dart:io';
import 'dart:typed_data';

import 'package:aya_seller_center/Logic/rootL.dart';
import 'package:aya_seller_center/Model/productPicturesM.dart';
import 'package:aya_seller_center/main.dart';
import 'package:aya_seller_center/stringSources.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class PictureCropV extends StatefulWidget {
  const PictureCropV({super.key});

  @override
  State<PictureCropV> createState() => _PictureCropVState();
}
class _PictureCropVState extends State<PictureCropV>{

  ProductPicturesM file = Get.arguments;

  final _controller = CropController();

  //Uint8List uint8list = Uint8List(0);

  var isCrop = false;

  var _statusText = '';

  var edit = true;

  @override
  void initState() {
    //uint8list = file.uint8list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RL>(
      builder: (_){
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text('Photo'),
          ),
          body: Stack(
            children: [
              edit == false ? Column(
                children: [
                  Expanded(
                    child: Container(
                        child: PhotoView(
                          imageProvider: MemoryImage(file.uint8list),
                        )
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    padding: EdgeInsets.only(bottom: Get.height*1/50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: (){
                            setState(() {
                              edit = true;
                            });
                          },
                          child: Text('Edit',style: TextStyle(color: Colors.white),),
                        ),
                        TextButton(
                          onPressed: (){
                            _.addTempPict(file);
                            Get.back();
                          },
                          child: Text('Confirm',style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                ],
              ) :
              Container(
                child: Column(
                  children: [
                    Expanded(
                      child:
                      Crop(
                        image: file.uint8list,//.readAsBytesSync(),
                        controller: _controller,
                        onCropped: (image) {
                          // do something with image data
                          setState(() {
                            file.uint8list = image;
                          });
                        },
                        aspectRatio: 1080 / 1440,///  9 / 12
                        initialSize: 0.5,
                        //initialArea: Rect.fromLTWH(240, 212, 800, 600),
                        /*initialAreaBuilder: (rect) => Rect.fromLTRB(
                            rect.left + 24, rect.top + 32, rect.right - 24, rect.bottom - 32
                        ),*/
                        //withCircleUi: true,
                        baseColor: Colors.black,
                        //maskColor: Colors.white.withAlpha(100),
                        radius: 0,
                        onMoved: (newRect) {
                          // do something with current cropping area.
                          //printInfo(info: newRect.toString());
                          //printInfo(info: '${newRect.right-newRect.left} * ${newRect.bottom-newRect.top}');
                        },
                        onStatusChanged: (status) {
                          printInfo(info: status.toString());
                          _statusText = <CropStatus, String>{
                            CropStatus.nothing: 'Crop has no image data',
                            CropStatus.loading:
                            'Crop is now loading given image',
                            CropStatus.ready: 'Crop is now ready!',
                            CropStatus.cropping:
                            'Crop is now cropping image',
                          }[status] ?? '';

                          if(status == CropStatus.ready && isCrop){
                            isCrop = false;
                            edit = false;
                            ///file = uint8list;
                            //Get.to(()=>PictureCheck(),arguments: uint8list);
                            //Get.toNamed(RN.pictureCrop,arguments: uint8list);
                            //printInfo(info: a.toString());
                          }

                          setState(() {});
                        },
                        cornerDotBuilder: (size, edgeAlignment) {
                          //printInfo(info: edgeAlignment.index)
                          return const DotControl(color: Colors.white);
                        },
                        //interactive: true,
                        //fixArea: true,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: Get.height*1/30),
                      color: Colors.black,
                      height: Get.height*1/12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(_statusText,style: TextStyle(color: Colors.white),),
                          TextButton(
                            onPressed: (){
                              isCrop = true;
                              _controller.crop();
                            },
                            child: Text('Crop',style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                /*PhotoView(
                imageProvider: FileImage(file),
              )*/
              ),
              if(isCrop)
              Container(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white,),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}


class PictureCheck extends StatelessWidget {
  PictureCheck({super.key});

  final Uint8List uint8list = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RL>(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text('Photo'),
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                    child: PhotoView(
                      imageProvider: MemoryImage(uint8list),
                    )
                ),
              ),
              Container(
                color: Colors.black,
                padding: EdgeInsets.only(bottom: Get.height*1/50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: (){
                        Get.back(result: uint8list);
                      },
                      child: Text('Confirm',style: TextStyle(color: Colors.white),),
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