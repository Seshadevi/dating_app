class Reportsmodel {
  int? total;
  int? limit;
  int? offset;
  List<Reports>? reports;

  Reportsmodel({this.total, this.limit, this.offset, this.reports});

  // Initial/default constructor
  factory Reportsmodel.initial() {
    return Reportsmodel(
      total: 0,
      limit: 0,
      offset: 0,
      reports: [],
    );
  }

  // CopyWith method
  Reportsmodel copyWith({
    int? total,
    int? limit,
    int? offset,
    List<Reports>? reports,
  }) {
    return Reportsmodel(
      total: total ?? this.total,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      reports: reports ?? this.reports,
    );
  }

  Reportsmodel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['reports'] != null) {
      reports = <Reports>[];
      json['reports'].forEach((v) {
        reports!.add(Reports.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total'] = total;
    data['limit'] = limit;
    data['offset'] = offset;
    if (reports != null) {
      data['reports'] = reports!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reports {
  int? id;
  int? userId;
  int? categoryId;
  String? description;
  String? createdAt;
  String? updatedAt;
  Reporter? reporter;
  Category? category;

  Reports({
    this.id,
    this.userId,
    this.categoryId,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.reporter,
    this.category,
  });

  factory Reports.initial() {
    return Reports(
      id: 0,
      userId: 0,
      categoryId: 0,
      description: '',
      createdAt: '',
      updatedAt: '',
      reporter: Reporter.initial(),
      category: Category.initial(),
    );
  }

  Reports copyWith({
    int? id,
    int? userId,
    int? categoryId,
    String? description,
    String? createdAt,
    String? updatedAt,
    Reporter? reporter,
    Category? category,
  }) {
    return Reports(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reporter: reporter ?? this.reporter,
      category: category ?? this.category,
    );
  }

  Reports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    categoryId = json['categoryId'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    reporter =
        json['reporter'] != null ? Reporter.fromJson(json['reporter']) : null;
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['categoryId'] = categoryId;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (reporter != null) {
      data['reporter'] = reporter!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class Reporter {
  int? id;
  String? username;
  String? firstName;
  String? email;

  Reporter({this.id, this.username, this.firstName, this.email});

  factory Reporter.initial() {
    return Reporter(
      id: 0,
      username: '',
      firstName: '',
      email: '',
    );
  }

  Reporter copyWith({
    int? id,
    String? username,
    String? firstName,
    String? email,
  }) {
    return Reporter(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
    );
  }

  Reporter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['firstName'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['firstName'] = firstName;
    data['email'] = email;
    return data;
  }
}

class Category {
  int? id;

  Category({this.id});

  factory Category.initial() {
    return Category(id: 0);
  }

  Category copyWith({int? id}) {
    return Category(id: id ?? this.id);
  }

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
