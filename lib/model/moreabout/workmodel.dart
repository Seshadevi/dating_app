class WorkModel {
  final int? statusCode;
  final bool? success;
  final String? message;
  final List<Data>? data;
  final bool isLoading;

  WorkModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
    this.isLoading = false,
  });

  factory WorkModel.fromJson(Map<String, dynamic> json) {
    return WorkModel(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? List<Data>.from(json['data'].map((v) => Data.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'message': message,
      'data': data?.map((v) => v.toJson()).toList(),
    };
  }

  WorkModel copyWith({
    int? statusCode,
    bool? success,
    String? message,
    List<Data>? data,
    bool? isLoading,
  }) {
    return WorkModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory WorkModel.initial() {
    return WorkModel(
      statusCode: null,
      success: null,
      message: '',
      data: [],
      isLoading: false,
    );
  }

  get id => null;
}

class Data {
  final int? id;
  final String? title;
  final String? company;
  final String? createdAt;
  final String? updatedAt;
  final bool isLoading;

  Data({
    this.id,
    this.title,
    this.company,
    this.createdAt,
    this.updatedAt,
    this.isLoading = false,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Data copyWith({
    int? id,
    String? title,
    String? company,
    String? createdAt,
    String? updatedAt,
    bool? isLoading,
  }) {
    return Data(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory Data.initial() {
    return Data(
      id: null,
      title: '',
      company: '',
      createdAt: '',
      updatedAt: '',
      isLoading: false,
    );
  }
}
