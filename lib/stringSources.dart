class SS{

  static const String _apiName = 'little devil';
  static const String _apiHost = '377a-109-235-39-60.ngrok-free.app';
      ///'1557-145-101-16-69.eu.ngrok.io';

  static const String _api = 'api/';

  static const String _user = 'users/';

  static const String _shop = 'shops/';

  static const String _products = 'products/';

  static const String _productPictures = 'productPictures/';

  static const String _getPictureFromProduct = 'getPictureFromProduct/';

  static const String _token = 'token/';

  static const String _detail = 'detail/';

  static const String _new = 'new/';

  static const String _get = 'get/';

  static const String _page = 'page';

  get sApiName => _apiName;
  get sApiHost => _apiHost;

  get sPage => _page;

  get sToken {
    return _api+_user+_token;
  }

  get sUser{
    return _api+_user+_detail;
  }

  get sNewUser{
    return _api+_user+_new;
  }

  get sNewShop{
    return _api+_shop+_new;
  }

  get sNewProductPictures{
    return _api+_productPictures+_new;
  }

  get sGetPictureFromProduct{
    return _api+_productPictures+_getPictureFromProduct;
  }

  get sNewProducts{
    return _api+_products+_new;
  }

  get sGetProducts{
    return _api+_products+_get;
  }

}