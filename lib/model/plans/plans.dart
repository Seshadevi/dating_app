class PlansModel {
  List<Data>? data;
  bool isLoading;

  PlansModel({this.data, this.isLoading = false});

  factory PlansModel.initial() {
    return PlansModel(data: [], isLoading: false);
  }

  PlansModel copyWith({
    List<Data>? data,
    bool? isLoading,
  }) {
    return PlansModel(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  PlansModel.fromJson(Map<String, dynamic> json)
      : isLoading = false {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    if (data != null) {
      dataMap['data'] = data!.map((v) => v.toJson()).toList();
    }
    return dataMap;
  }
}

class Data {
  int? id;
  String? planName;
  String? description;

  Data({this.id, this.planName, this.description});

  factory Data.initial() {
    return Data(id: 0, planName: '', description: '');
  }

  Data copyWith({
    int? id,
    String? planName,
    String? description,
  }) {
    return Data(
      id: id ?? this.id,
      planName: planName ?? this.planName,
      description: description ?? this.description,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planName = json['planName'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['id'] = id;
    dataMap['planName'] = planName;
    dataMap['description'] = description;
    return dataMap;
  }
}
