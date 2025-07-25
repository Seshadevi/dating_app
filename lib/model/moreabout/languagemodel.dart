// language_model.dart

class LanguagesModel {
  final int? statusCode;
  final bool? success;
  final String? message;
  final List<Data>? data;

  LanguagesModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory LanguagesModel.fromJson(Map<String, dynamic> json) {
    return LanguagesModel(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
              .map((e) => Data.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }

  LanguagesModel copyWith({
    int? statusCode,
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return LanguagesModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory LanguagesModel.initial() {
    return LanguagesModel(
      statusCode: null,
      success: null,
      message: null,
      data: [],
    );
  }

  get isLoading => null;
}

class Data {
  final int? id;
  final String? name;
  final String? createdAt;
  final String? updatedAt;

  Data({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      name: json['name'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Data copyWith({
    int? id,
    String? name,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Data.initial() {
    return Data(
      id: null,
      name: null,
      createdAt: null,
      updatedAt: null,
    );
  }
}
