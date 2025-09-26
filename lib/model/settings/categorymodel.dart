class Categorymodel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;
  Pagination? pagination;

  Categorymodel({
    this.statusCode,
    this.success,
    this.messages,
    this.data,
    this.pagination,
  });

  // Initial factory
  factory Categorymodel.initial() {
    return Categorymodel(
      statusCode: 0,
      success: false,
      messages: [],
      data: [],
      pagination: Pagination.initial(),
    );
  }

  // CopyWith method
  Categorymodel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
    Pagination? pagination,
  }) {
    return Categorymodel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }

  Categorymodel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = json['messages'] != null ? List<String>.from(json['messages']) : [];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['statusCode'] = statusCode;
    dataMap['success'] = success;
    dataMap['messages'] = messages;
    if (data != null) {
      dataMap['data'] = data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      dataMap['pagination'] = pagination!.toJson();
    }
    return dataMap;
  }
}

class Data {
  int? id;
  String? category;
  String? createdAt;
  String? updatedAt;

  Data({this.id, this.category, this.createdAt, this.updatedAt});

  factory Data.initial() {
    return Data(
      id: 0,
      category: '',
      createdAt: '',
      updatedAt: '',
    );
  }

  Data copyWith({
    int? id,
    String? category,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final dataMap = <String, dynamic>{};
    dataMap['id'] = id;
    dataMap['category'] = category;
    dataMap['createdAt'] = createdAt;
    dataMap['updatedAt'] = updatedAt;
    return dataMap;
  }
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  Pagination({this.total, this.page, this.limit, this.totalPages});

  factory Pagination.initial() {
    return Pagination(
      total: 0,
      page: 1,
      limit: 10,
      totalPages: 1,
    );
  }

  Pagination copyWith({
    int? total,
    int? page,
    int? limit,
    int? totalPages,
  }) {
    return Pagination(
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final dataMap = <String, dynamic>{};
    dataMap['total'] = total;
    dataMap['page'] = page;
    dataMap['limit'] = limit;
    dataMap['totalPages'] = totalPages;
    return dataMap;
  }
}
