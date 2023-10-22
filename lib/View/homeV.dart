import 'dart:io';
import 'dart:typed_data';
import 'package:aya_seller_center/Logic/rootL.dart';
import 'package:aya_seller_center/Model/companyM.dart';
import 'package:aya_seller_center/Model/productM.dart';
import 'package:aya_seller_center/Model/productPicturesM.dart';
import 'package:aya_seller_center/State/rootS.dart';
import 'package:aya_seller_center/View/profileV.dart';
import 'package:aya_seller_center/main.dart';
import 'package:aya_seller_center/plugin/functions.dart';
import 'package:aya_seller_center/stringSources.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>{

  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _selectedIndex = index);
          },
          children: const <Widget>[
            HomeMainView(),
            ProfileView(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        }),
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            activeColor: Colors.black,
          ),
          BottomNavyBarItem(
              icon: const Icon(Icons.person),
              title: const Text('Profile'),
              activeColor: Colors.black
          ),
        ],
      ),
    );
  }

}

class HomeMainView extends StatefulWidget {
  const HomeMainView({super.key});

  @override
  State<HomeMainView> createState() => _HomeMainViewState();
}

class _HomeMainViewState extends State<HomeMainView> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    var _ = Get.find<RL>();
    // monitor network fetch

    await _.getProducts(_.rS.rM.shopMList.shopMList[0].id);

    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //items.add((items.length+1).toString());
    if(mounted) {
      setState(() {

      });
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);

    return GetBuilder<RL>(
      builder: (_){

        var products = _.rS.rM.productMList.productMList;//.reversed.toList();

        return Scaffold(
          body: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            header: const WaterDropHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            footer: CustomFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              builder: (BuildContext context, LoadStatus? mode) {
                Widget body ;
                if(mode==LoadStatus.idle){
                  body =  const Text("pull up load");
                }
                else if(mode==LoadStatus.loading){
                  body =  const CupertinoActivityIndicator();
                }
                else if(mode == LoadStatus.failed){
                  body = const Text("Load Failed!Click retry!");
                }
                else if(mode == LoadStatus.canLoading){
                  body = const Text("release to load more");
                }
                else{
                  body = const Text("No more Data");
                }
                return SizedBox(
                  height: 55.0,
                  child: Center(child:body),
                );
              },
            ),
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 5,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: products.length,
              itemBuilder: (context,index){

                return InkWell(
                  onTap: (){
                    Get.toNamed(RN.productDetail, arguments: products[index]);
                  },
                  child: Container(
                    //color: Colors.blue,
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        child: Column(
                          children: [
                            Flexible(
                              flex: 4,
                              fit: FlexFit.tight,
                              child: Container(
                                //color: Colors.amber,
                                //margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                child: FastCachedImage(
                                  url: MyF().backImageApiPath(products[index], _, 0),
                                  errorBuilder: (context, exception, stacktrace) {
                                    return Text(stacktrace.toString());
                                  },
                                  loadingBuilder: (context, progress) {
                                    return Container(
                                      // color: Colors.yellow,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          /*Shimmer.fromColors(
                                            baseColor: Colors.red,
                                            highlightColor: Colors.yellow,
                                            child: const Text(
                                              'Shimmer',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 40.0,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ),*/
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
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Container(
                                //color: Colors.red,
                                //margin: EdgeInsets.only(bottom: 5, left: 5, right: 5),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(products[index].title,maxLines: 2,),
                                        ),
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.only(top: Get.height*5/1000)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text('Stock: 10'),
                                        Text('data'),
                                        Text('data'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Get.to(()=>const NewProductView());
            },
            child: const Text('Add'),
          ),
        );
      },
    );
  }

}

class NewProductView extends StatefulWidget {
  const NewProductView({super.key});

  @override
  State<NewProductView> createState() => _NewProductViewState();
}
class _NewProductViewState extends State<NewProductView>{

  String title = '';
  CompanyM company = CompanyM();
  String color = '';
  String description = '';
  //List<File> pictureXFile = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RL>(
      builder: (_){
        return WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Create new Product'),
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(vertical: 40),
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width*80/100,
                        child: ListTile(
                          //title: Text('Shop Name'),
                          subtitle: FormBuilder(
                            //key: _formKey1,
                            child: Column(
                              children: [

                                FormBuilderTextField(
                                  name: 'Product title',
                                  decoration: const InputDecoration(
                                    labelText: 'Product title',
                                  ),
                                  onChanged: (val) {
                                    title = val!;
                                  },
                                ),
                                const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                                FormBuilderDropdown<CompanyM>(
                                  name: 'Company',
                                  decoration: const InputDecoration(
                                    labelText: 'Company',
                                    hintText: 'Select Company',
                                  ),
                                  items: _.rS.rM.companyMList.companyMList.map((company) => DropdownMenuItem(
                                    alignment: AlignmentDirectional.center,
                                    value: company,
                                    child: Text(company.name,style: const TextStyle(fontSize: 10),),
                                  )).toList(),
                                  onChanged: (val) {
                                    company = val!;
                                  },
                                  valueTransformer: (val) => val?.name,
                                ),
                                const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                                FormBuilderTextField(
                                  name: 'color',
                                  decoration: const InputDecoration(
                                    labelText: 'color',
                                  ),
                                  onChanged: (val) {
                                    color = val!;
                                  },
                                ),
                                const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                                FormBuilderTextField(
                                  name: 'Description',
                                  maxLines: 5,
                                  decoration: const InputDecoration(
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
                Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: _.rS.rM.tempM.pictureUint8List.map((e) {
                    return _myImage(_, e);
                  }).toList(),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: ()async{

                          if(_.rS.rM.tempM.pictureUint8List.length < 5){
                            final ImagePicker picker = ImagePicker();
                            final XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);
                            if(imageFile != null){
                              var image = File(imageFile.path);
                              ProductPicturesM productPicturesM = ProductPicturesM(path: image.path);
                              productPicturesM.uint8list = image.readAsBytesSync();
                              Get.toNamed(RN.pictureCrop,arguments: productPicturesM);
                              //pictureXFile.add(image);
                            }

                          }

                          setState(() {

                          });
                        },
                        child: const Text('Add Picture'),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          ProductM product = ProductM(images: []);
                          product.shopId = _.rS.rM.shopMList.shopMList[0].id;
                          product.companyId = company.id;
                          product.title = title;
                          product.color = color;
                          product.description = description;

                          if(_.rS.rM.tempM.pictureUint8List.isNotEmpty){
                            _.newProduct(product, _.rS.rM.tempM.pictureUint8List);
                          }

                        },
                        child: const Text('Create'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onWillPop: ()async{
            _.initialTemUint8List();
            return true;
          },

        );
      },
    );
  }

  Widget _myImage(RL _, ProductPicturesM file){
    return Container(
      child: Column(
        children: [
          Container(
            child: IconButton(
              onPressed: (){
                _.removePhoto(file);
              },
              icon: const Icon(Icons.close,size: 15,color: Colors.red,),
            ),
          ),
          Image.memory(file.uint8list,width: Get.width*2/7,height: Get.height*1/7,fit: BoxFit.contain,),
          /*InkWell(
            child: Image.memory(file,width: Get.width*2/7,height: Get.height*1/7,fit: BoxFit.cover,),
            onTap: (){
              Get.toNamed(RN.picture,arguments: file);
            },
          ),*/

        ],
      ),
    );
  }

}

