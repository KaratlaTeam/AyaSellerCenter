import 'package:aya_seller_center/Logic/rootL.dart';
import 'package:get/get.dart';

class RootBinding implements Bindings{

  @override
  void dependencies(){
    printInfo(info: 'RootBinding called');
    Get.put(RL());
  }
}