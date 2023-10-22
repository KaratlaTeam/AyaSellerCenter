
import 'package:aya_seller_center/Model/pageM.dart';
import 'package:aya_seller_center/Model/productPicturesM.dart';
import 'package:aya_seller_center/plugin/functions.dart';

class ProductMList{
  ProductMList({
    required this.productMList,
    this.pageIndex = 1,
    this.pageMax = 0,
    this.perPage = 4,
});
  List<ProductM> productMList;
  int pageIndex;
  int pageMax;
  int perPage;
}

class ProductM{
  ProductM({
    this.id = 0,
    this.shopId = 0,
    this.companyId = 0,
    this.title = '',
    this.color = '',
    this.description = '',
    required this.images,
  });

  int id;
  int shopId;
  int companyId;
  String title;
  String color;
  String description;
  List<ProductPicturesM> images;

  factory ProductM.fromJson(Map<String, dynamic> json){


    return ProductM(
      id: json['id'],
      shopId: MyF().backInt(json['shop_id']),
      companyId: MyF().backInt(json['company_id']),
      title: json['title'],
      color: json['color'],
      description: json['description'],
      images: [],
    );

  }

  Map<String, dynamic> toJson() {

    Map<String, dynamic> json = <String, dynamic>{};

    json['id'] = id;
    json['shop_id'] = shopId;
    json['company_id'] = companyId;
    json['title'] = title;
    json['color'] = color;
    json['description'] = description;

    return json;
  }


}