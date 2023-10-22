
import 'package:aya_seller_center/plugin/functions.dart';
import 'dart:typed_data';

class ProductPicturesM{
  ProductPicturesM({
    this.id = 0,
    this.productId = 0,
    this.path = '',
  });
  int id;
  int productId;
  String path;
  Uint8List uint8list = Uint8List(0);

  factory ProductPicturesM.fromJson(Map<String, dynamic> json){

    return ProductPicturesM(
      id: json['id'],
      productId: MyF().backInt(json['product_id']),
      path: json['path'],
    );

  }

  Map<String, dynamic> toJson() {

    Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['product_id'] = productId;
    json['path'] = path;

    return json;
  }

}