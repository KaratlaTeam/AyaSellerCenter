class UserM{
  UserM({
    this.email = '',
    this.createdAt = '',
    //this.emailVerifiedAt = '',
    this.id = 0,
    this.name = '',
    this.updatedAt = '',
    //required this.deviceName,
  });
  int id;
  String name;
  String email;
  //String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  //String deviceName;

  factory UserM.fromJson(Map<String, dynamic> json){

    return UserM(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      //emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      //deviceName: json['device_name'],
    );

  }

  Map<String, dynamic> toJson() {

    Map<String, dynamic> json = <String, dynamic>{};

    json['id'] = id;
    json['name'] = name;
    json['email'] = email;
    //json['email_verified_at'] = emailVerifiedAt;
    json['created_at'] = createdAt;
    json['updated_at'] = updatedAt;
    //json['device_name'] = deviceName;

    return json;
  }

}