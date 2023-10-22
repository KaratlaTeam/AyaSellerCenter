import 'dart:io';

import 'package:aya_seller_center/Logic/rootL.dart';
import 'package:aya_seller_center/Model/companyM.dart';
import 'package:aya_seller_center/Model/productM.dart';
import 'package:aya_seller_center/main.dart';
import 'package:aya_seller_center/plugin/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}
class _ProductDetailViewState extends State<ProductDetailView>{

  ProductM productM = Get.arguments;
  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RL>(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text(productM.title),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 40),
            children: [
              Container(
                // color: Colors.red,
                margin: const EdgeInsets.only(bottom: 50),
                child: CarouselSlider(
                  items: productM.images.asMap().entries.map((value) {
                    return InkWell(
                      onTap: (){
                        Get.toNamed(RN.picture,arguments: value.value);
                      },
                      child: FastCachedImage(
                        //fit: BoxFit.cover,
                        url: MyF().backImageApiPath(productM, _, value.key),
                        errorBuilder: (context, exception, stacktrace) {
                          return Text(stacktrace.toString());
                        },
                        loadingBuilder: (context, progress) {
                          return Container(
                            // color: Colors.yellow,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (progress.isDownloading && progress.totalBytes != null)
                                  Text('${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',),
                                SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: CircularProgressIndicator(value: progress.progressPercentage.value)),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                  carouselController: buttonCarouselController,
                  options: CarouselOptions(
                    height: Get.height*6/10,
                    autoPlay: false,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    aspectRatio: 1.0,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


}