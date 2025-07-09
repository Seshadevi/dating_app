class LikeDislikeModel {
  String? message;
  Data? data;

  LikeDislikeModel({this.message, this.data});

  factory LikeDislikeModel.initial() => LikeDislikeModel(
        message: null,
        data: null,
      );

  LikeDislikeModel copyWith({
    String? message,
    Data? data,
  }) {
    return LikeDislikeModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  bool get isLoading => data == null;

  LikeDislikeModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['message'] = this.message;
    if (this.data != null) {
      map['data'] = this.data!.toJson();
    }
    return map;
  }
}

class Data {
  int? id;
  int? userId;
  String? likeDislike;
  String? updatedAt;
  String? createdAt;

  Data({
    this.id,
    this.userId,
    this.likeDislike,
    this.updatedAt,
    this.createdAt,
  });

  factory Data.initial() => Data(
        id: null,
        userId: null,
        likeDislike: null,
        updatedAt: null,
        createdAt: null,
      );

  Data copyWith({
    int? id,
    int? userId,
    String? likeDislike,
    String? updatedAt,
    String? createdAt,
  }) {
    return Data(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      likeDislike: likeDislike ?? this.likeDislike,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    likeDislike = json['LikeDislike'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = this.id;
    map['userId'] = this.userId;
    map['LikeDislike'] = this.likeDislike;
    map['updatedAt'] = this.updatedAt;
    map['createdAt'] = this.createdAt;
    return map;
  }
}
