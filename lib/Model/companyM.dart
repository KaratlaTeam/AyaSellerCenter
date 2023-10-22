class CompanyMList{
  CompanyMList({
    required this.companyMList,
  });
  List<CompanyM> companyMList;
}

class CompanyM{
  CompanyM({
    this.id = 0,
    this.name = '',
  });

  int id;
  String name;

  factory CompanyM.fromJson(Map<String, dynamic> json){

    return CompanyM(
      id: json['id'],
      name: json['name'],
    );

  }

  Map<String, dynamic> toJson() {

    Map<String, dynamic> json = <String, dynamic>{};

    json['id'] = id;
    json['name'] = name;

    return json;
  }
}