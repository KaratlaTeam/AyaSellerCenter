import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:aya_seller_center/Model/appM.dart';
import 'package:aya_seller_center/Model/companyM.dart';
import 'package:aya_seller_center/Model/orderM.dart';
import 'package:aya_seller_center/Model/productM.dart';
import 'package:aya_seller_center/Model/productPicturesM.dart';
import 'package:aya_seller_center/Model/rootM.dart';
import 'package:aya_seller_center/Model/shopM.dart';
import 'package:aya_seller_center/Model/tempM.dart';
import 'package:aya_seller_center/Model/userM.dart';
import 'package:aya_seller_center/State/rootS.dart';
import 'package:aya_seller_center/main.dart';
import 'package:aya_seller_center/stringSources.dart';
import 'package:aya_seller_center/type_def.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class RL extends GetxController with StateMixin<RS>{

  late RS rS;
  late Timer timer;

  @override
  Future<void> onInit()async{
    initializeData();

    _timerToName(RN.login, type: RouteType.oFF);

    super.onInit();
  }


  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  initializeData()async{
    var tempM = TempM(pictureUint8List: []);
    var device = await getDeviceId();
    var user = UserM();

    /// app path
    /// ios only supports save files in NSDocumentDirectory--getApplicationDocumentsDirectory
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    printInfo(info: 'tempPath$tempPath');

    Directory? appDocDir = GetPlatform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String? appDocPath = appDocDir?.path;
    printInfo(info: 'appDocPath$appDocPath');

    Directory fileDir = await Directory('${appDocPath!}/File').create();
    String filePath = fileDir.path;
    printInfo(info: filePath);

    Directory pictureDir = await Directory('$appDocPath/Picture').create();
    String picturePath = pictureDir.path;
    printInfo(info: picturePath);

    Directory videoDir = await Directory('$appDocPath/Video').create();
    String videoPath = videoDir.path;
    printInfo(info: videoPath);

    Directory musicDir = await Directory('$appDocPath/Music').create();
    String musicPath = musicDir.path;
    printInfo(info: musicPath);

    Directory dbDir = await Directory('$appDocPath/Db').create();
    String dbPath = dbDir.path;
    printInfo(info: dbPath);

    /// app information
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    printInfo(info: 'appName: $appName, packageName: $packageName, version: $version, buildNumber: $buildNumber');

    ///initial FastCachedImage
    await FastCachedImageConfig.init(
      subDir: dbPath,
      clearCacheAfter: const Duration(days: 15),
    );

    await FastCachedImageConfig.clearAllCachedImages();

    var app = AppM(
      authorizationHeader: 'Bearer'' ',
      token: '',
      deviceName: device ?? '',

      tempPath: tempPath,
      appDocPath: appDocPath,
      filePath: filePath,
      picturePath: picturePath,
      videoPath: videoPath,
      musicPath: musicPath,
      dbPath: dbPath,

      tempDir: tempDir,
      appDocDir: appDocDir,
      fileDir: fileDir,
      pictureDir: pictureDir,
      videoDir: videoDir,
      musicDir: musicDir,
      dbDir: dbDir,

      appName: appName,
      packageName: packageName,
      version: version,
      buildNumber: buildNumber,
    );
    var rm = RM(
      userM: user,
      appM: app,
      productMList: ProductMList(productMList: []),
      //productPicturesMList: [],
      shopMList: ShopMList(shopMList: []),
      orderMList: OrderMList(orderMList: []),
      companyMList: CompanyMList(companyMList: []),
      tempM: tempM,
    );
    rS = RS(rM: rm);
  }

  _timerToName(String name, {RouteType type = RouteType.tO, int second = 2}){
    switch(type){
      case RouteType.tO: {
        Timer(Duration(seconds: second), () {
          Get.toNamed(name);
        });
      }
      break;

      case RouteType.oFF: {
        Timer(Duration(seconds: second), () {
          Get.offNamed(name);
        });
      }
      break;

    }

  }

  /// user /////

  newShop(ShopM shopM)async{
    printInfo(info: '${shopM.name} ${shopM.description}',);
    var client = http.Client();
    try {
      var response = await client.post(
        Uri.https(SS().sApiHost, SS().sNewShop),
        headers: {
          HttpHeaders.authorizationHeader: rS.rM.appM.authorizationHeader+rS.rM.appM.token,
        },
        body: {
          'name': shopM.name,
          'description': shopM.description,
        },
      );
      debugPrint(response.body);
      if(response.statusCode == 200){
        rS.rM.shopMList.shopMList.add(ShopM.fromJson(jsonDecode(response.body)['data']));
        update();
        client.close();
        Get.back();
      }else{
        printInfo(info: 'error');
        client.close();
        return 0;
      }
    } finally {
      client.close();
    }
  }

  Future<int> signup(String name, String email, String password)async{
    printInfo(info: '$name $email $password', );
    var client = http.Client();
    try {
      var response = await client.post(
        Uri.https(SS().sApiHost, SS().sNewUser),
        body: {
          'name': name,
          'email': email,
          'password': password,
          //'device_name': rS.rM.userM.deviceName,
        },
      );
      debugPrint(response.body);
      if(response.statusCode == 200){
        //rS.rM.appM.token = jsonDecode(response.body)['token'];
        //rS.rM.userM = UserM.fromJson(jsonDecode(response.body)['user']);

        //update();
        client.close();
        return 1;
      }else{
        client.close();
        return 0;
      }
    } finally {
      client.close();
    }
  }
  logout(){
    rS.rM.userM = UserM();
    rS.rM.shopMList = ShopMList(shopMList: []);
    rS.rM.productMList = ProductMList(productMList: []);
    //rS.rM.productPicturesMList = [];
    update();
    Get.offAllNamed(RN.login);
  }

  Future<int> login(String email, String password)async{
    var client = http.Client();
    try {
      var response = await client.post(
        Uri.https(SS().sApiHost, SS().sToken),
        body: {
          'email': email,
          'password': password,
          'device_name': rS.rM.appM.deviceName,
        },
      );
      debugPrint(response.body);
      if(response.statusCode == 200){
        rS.rM.appM.token = jsonDecode(response.body)['data'];

        update();
        client.close();
        return await getUserData();
      }else{
        client.close();
        return 0;
      }
    } finally {
      client.close();
    }
  }

  Future<int> getUserData()async{
    var client = http.Client();
    try {
      var response = await client.post(
        Uri.https(SS().sApiHost, SS().sUser),
        headers: {
          HttpHeaders.authorizationHeader: rS.rM.appM.authorizationHeader+rS.rM.appM.token,
        },
      );
      debugPrint(response.body);
      if(response.statusCode == 200){
        ///user
        var user = jsonDecode(response.body)['user'];
        rS.rM.userM = UserM.fromJson(user);

        ///shop
        var shop = jsonDecode(response.body)['shop'];
        rS.rM.shopMList.shopMList.add(ShopM.fromJson(shop));

        ///company
        var companies = jsonDecode(response.body)['companies'] as List;
        for (var element in companies) {
          rS.rM.companyMList.companyMList.add(CompanyM.fromJson(element));
        }
        rS.rM.companyMList.companyMList.sort((a, b) => a.name.compareTo(b.name));
        printInfo(info: 'Companies: ${rS.rM.companyMList.companyMList.length}');

        /// products
        await getProducts(rS.rM.shopMList.shopMList[0].id, rS.rM.productMList.pageIndex);

        update();
        client.close();
        return 1;
      }else{
        client.close();
        return 0;
      }
    } finally {
      client.close();
    }
  }
/// /////////////////
  ///
  ///
  /// product /////
  newProduct(ProductM productM, List<ProductPicturesM> files)async{
    printInfo(info: '${productM.shopId} ${productM.title} ${productM.companyId} ${productM.color} ${productM.description}', );

    var client = http.Client();
    try {
      var response = await client.post(
        Uri.https(SS().sApiHost, SS().sNewProducts),
        headers: {
          HttpHeaders.authorizationHeader: rS.rM.appM.authorizationHeader+rS.rM.appM.token,
        },
        body: {
          'shop_id': productM.shopId.toString(),
          'company_id': productM.companyId.toString(),
          'title': productM.title,
          'color': productM.color,
          'description': productM.description,
        },
      );
      debugPrint(response.body);
      if(response.statusCode == 200){
        var productJs = jsonDecode(response.body)['product'];

        var product = ProductM.fromJson(productJs);

        //rS.rM.productMList.productMList.add(product);

        await uploadMPictures(files, product);

        update();
        client.close();
        return 1;
      }else{
        client.close();
        return 0;
      }
    } finally {
      client.close();
    }

  }

  getProducts(int shopId)async{
    ///check if need to increase index
    if(rS.rM.productMList.pageIndex < rS.rM.productMList.pageMax){
      await requestGetProduct(shopId);


    }else if(rS.rM.productMList.pageIndex == rS.rM.productMList.pageMax){
      /// get product and check


    }


  }

  requestGetProduct(int shopId)async{
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.https(SS().sApiHost, SS().sGetProducts+shopId.toString(),{SS().sPage: rS.rM.productMList.pageIndex.toString()}),
        headers: {
          HttpHeaders.authorizationHeader: rS.rM.appM.authorizationHeader+rS.rM.appM.token,
        },
      );
      debugPrint(response.body);

      if(response.statusCode == 200){

        /// new index
        rS.rM.productMList.pageIndex += 1;

        /// get new max page
        var newMaxPage = jsonDecode(response.body)['products']['last_page'];

        /// max page uopdate or same
        if(newMaxPage == rS.rM.productMList.pageMax){

          rS.rM.productMList.pageMax = newMaxPage;

          ///check if need to increase index
          if(rS.rM.productMList.pageIndex < rS.rM.productMList.pageMax){
            /// next page index
            rS.rM.productMList.pageIndex += 1;

          }else if(rS.rM.productMList.pageIndex == rS.rM.productMList.pageMax){
            /// get product and check


          }

        }else if(newMaxPage > rS.rM.productMList.pageMax){
          rS.rM.productMList.pageMax = newMaxPage;

          ///check if need to increase index


        }else if(newMaxPage < rS.rM.productMList.pageMax){
          rS.rM.productMList.pageMax = newMaxPage;

          ///check if need to increase index


        }




        ///product


        var productsJS = jsonDecode(response.body)['products']['data'] as List;
        for (var element in productsJS) {
          /// add product
          var product = ProductM.fromJson(element);

          /// add images for product
          var newProduct = await getPicture(product);
          if(newProduct != 0){
            // var index = rS.rM.productMList.productMList.indexOf(product);
            // rS.rM.productMList.productMList[index] = newProduct;
            rS.rM.productMList.productMList.add(newProduct);
          }else{
            rS.rM.productMList.productMList.add(product);
          }
        }

        update();
        client.close();
        return 1;
      }else{
        client.close();
        return 0;
      }
    } finally {
      client.close();
    }
  }


  uploadMPictures(List<ProductPicturesM> files, ProductM productM )async{

    for(var f in files){
      await uploadPicture(await writePictureInPath(f), productM);
    }

  }

  getPictureType(String path){
    return path.substring(path.indexOf('.'), path.length);
  }

  Future<File>writePictureInPath(ProductPicturesM data)async{

    Uuid uuid = const Uuid();
    final myImagePath = "${rS.rM.appM.tempPath}/${uuid.v1()}${getPictureType(data.path)}";
    File imageFile = File(myImagePath);
    if(! await imageFile.exists()){
      imageFile.create(recursive: true);
      printInfo(info: 'New picture path: $myImagePath');
    }

    return imageFile.writeAsBytes(data.uint8list);
  }

  uploadPicture(File file, ProductM productM )async{
    var request = http.MultipartRequest("POST", Uri.https(SS().sApiHost, SS().sNewProductPictures));
    request.headers.addAll({
      HttpHeaders.authorizationHeader: rS.rM.appM.authorizationHeader+rS.rM.appM.token,
    });
    request.fields.addAll({
      'product_id': productM.id.toString(),
    });

    request.files.add(
      await http.MultipartFile.fromPath('path', file.path),
    );

    request.send().then((response) async {
      var body = await response.stream.bytesToString();
      printInfo(info: body);

      if (response.statusCode == 200){
        var productPictureJs = jsonDecode(body)['productPicture'];
        var productPicture = ProductPicturesM.fromJson(productPictureJs);
        productM.images.add(productPicture);
        update();
        Get.back();
      } else {
        printInfo(info: 'failed');
      }
    });

  }

  getPicture(ProductM productM)async{
    var client = http.Client();
    try {
      var response = await client.post(
        Uri.https(SS().sApiHost, SS().sGetPictureFromProduct),
        headers: {
          HttpHeaders.authorizationHeader: rS.rM.appM.authorizationHeader+rS.rM.appM.token,
        },
        body: {
          'product_id': productM.id.toString(),
        },
      );
      debugPrint(response.body);
      if(response.statusCode == 200){
        var productPictureJs = jsonDecode(response.body)['productPictures'] as List;
        if(productPictureJs.isNotEmpty){
          for(var p in productPictureJs){
            var productPicture = ProductPicturesM.fromJson(p);
            productM.images.add(productPicture);
          }
          update();
          client.close();
          return productM;
        }else{
          return 0;
        }

      }else{
        client.close();
        return 0;
      }
    } finally {
      client.close();
    }
  }





  /// //////
  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }else{
      return null;
    }
  }

  /// ////Tem function
  addTempPict(ProductPicturesM u8){
    rS.rM.tempM.pictureUint8List.add(u8);
    update();
  }
  removePhoto(ProductPicturesM data){
    rS.rM.tempM.pictureUint8List.remove(data);
    update();
  }
  updateTempPhoto(ProductPicturesM data, int index){
    rS.rM.tempM.pictureUint8List[index] = data;
    update();
  }
  initialTemUint8List(){
    rS.rM.tempM.pictureUint8List = [];
    update();
  }
}