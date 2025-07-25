class Starsignmodel {
  int? statusCode;
  bool? success;
  String? message;
  List<Data>? data;

  Starsignmodel({this.statusCode, this.success, this.message, this.data});

  factory Starsignmodel.initial() {
    return Starsignmodel(
      statusCode: 0,
      success: false,
      message: '',
      data: [],
    );
  }

  Starsignmodel copyWith({
    int? statusCode,
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return Starsignmodel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Starsignmodel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
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
    final Map<String, dynamic> json = {};
    json['statusCode'] = this.statusCode;
    json['success'] = this.success;
    json['message'] = this.message;
    if (this.data != null) {
      json['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

class Data {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  bool isLoading;

  Data({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.isLoading = false,
  });

  factory Data.initial() {
    return Data(
      id: 0,
      name: '',
      createdAt: '',
      updatedAt: '',
      isLoading: false,
    );
  }

  Data copyWith({
    int? id,
    String? name,
    String? createdAt,
    String? updatedAt,
    bool? isLoading,
  }) {
    return Data(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        isLoading = false;

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
    };
  }
}
