class ShopMList{
  ShopMList({
    required this.shopMList,
});
  List<ShopM> shopMList;
}

class ShopM{
  ShopM({
    this.id = 0,
    this.userId = 0,
    this.name = '',
    this.description = '',
  });
  int id;
  int userId;
  String name;
  String description;

  factory ShopM.fromJson(Map<String, dynamic> json){


    return ShopM(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
    );

  }

  Map<String, dynamic> toJson() {

    Map<String, dynamic> json = <String, dynamic>{};

    json['id'] = id;
    json['user_id'] = userId;
    json['name'] = name;
    json['description'] = description;

    return json;
  }
}
