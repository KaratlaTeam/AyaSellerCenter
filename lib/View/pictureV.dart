import 'dart:io';

import 'package:aya_seller_center/Logic/rootL.dart';
import 'package:aya_seller_center/Model/productPicturesM.dart';
import 'package:aya_seller_center/main.dart';
import 'package:aya_seller_center/stringSources.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class PictureV extends StatelessWidget {
  PictureV({super.key});

  final ProductPicturesM picturesM = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RL>(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text('Photo'),
          ),
          body: Container(
              child: PhotoView(
                imageProvider: FastCachedImageProvider('https://${SS().sApiHost}/${picturesM.path}'),
              )
          ),
        );
      },
    );
  }

}