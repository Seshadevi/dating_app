class Industrymodel {
  bool? success;
  String? message;
  List<Data>? data;

  Industrymodel({this.success, this.message, this.data});

  /// Named constructor for empty initial values
  factory Industrymodel.initial() {
    return Industrymodel(
      success: false,
      message: '',
      data: [],
    );
  }

  /// Creates a new instance by copying the existing one and overriding specific fields
  Industrymodel copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return Industrymodel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Industrymodel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  int? id;
  String? industry;

  Data({this.id, this.industry});

  /// Named constructor for empty initial values
  factory Data.initial() {
    return Data(
      id: 0,
      industry: '',
    );
  }

  /// Creates a new instance by copying the existing one and overriding specific fields
  Data copyWith({
    int? id,
    String? industry,
  }) {
    return Data(
      id: id ?? this.id,
      industry: industry ?? this.industry,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    industry = json['industry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['industry'] = industry;
    return map;
  }
}
