
import 'package:aya_seller_center/Model/appM.dart';
import 'package:aya_seller_center/Model/companyM.dart';
import 'package:aya_seller_center/Model/orderM.dart';
import 'package:aya_seller_center/Model/productM.dart';
import 'package:aya_seller_center/Model/productPicturesM.dart';
import 'package:aya_seller_center/Model/shopM.dart';
import 'package:aya_seller_center/Model/tempM.dart';
import 'package:aya_seller_center/Model/userM.dart';

class RM{
  RM({
    required this.userM,
    required this.appM,

    required this.shopMList,
    required this.productMList,
    //required this.productPicturesMList,
    required this.orderMList,
    required this.companyMList,
    required this.tempM,
  });

  UserM userM;
  AppM appM;
  TempM tempM;

  ShopMList shopMList;
  ProductMList productMList;
  //List<ProductPicturesM> productPicturesMList;
  OrderMList orderMList;
  CompanyMList companyMList;
}