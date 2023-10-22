import 'package:aya_seller_center/Logic/rootL.dart';
import 'package:aya_seller_center/Model/productM.dart';
import 'package:aya_seller_center/stringSources.dart';

class MyF{

  backInt(var data){
    if(data is int){
      return data;
    }else{
      return int.parse(data);
    }
  }

  backImageApiPath(ProductM productM, RL _, int index){
    if(productM.images.isNotEmpty){
      return 'https://${SS().sApiHost}/${productM.images[index].path}';
    } else{
      return 'https://${SS().sApiHost}/path/error/error.png';
    }
  }
}