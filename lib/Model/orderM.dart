class OrderMList{
  OrderMList({
    required this.orderMList,
  });
  List<OrderM> orderMList;
}

class OrderM{
  OrderM({
    this.id = 0,
    this.shopId = 0,
    this.clientId = 0,
    this.orderCode = '',
    this.amount = 0,
  });
  int id;
  int shopId;
  int clientId;
  String orderCode;
  int amount;

  factory OrderM.fromJson(Map<String, dynamic> json){

    return OrderM(
      id: json['id'],
      shopId: json['shop_id'],
      clientId: json['client_id'],
      orderCode: json['order_code'],
      amount: json['amount'],
    );

  }

  Map<String, dynamic> toJson() {

    Map<String, dynamic> json = <String, dynamic>{};

    json['id'] = id;
    json['shop_id'] = shopId;
    json['client_id'] = clientId;
    json['order_code'] = orderCode;
    json['amount'] = amount;
    return json;
  }
}