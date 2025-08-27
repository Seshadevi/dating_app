class Experiencemodel {
  bool? success;
  String? message;
  List<Data>? data;

  Experiencemodel({this.success, this.message, this.data});

  /// Initial (empty) object
  factory Experiencemodel.initial() {
    return Experiencemodel(
      success: false,
      message: '',
      data: [],
    );
  }

  /// Copy with new values
  Experiencemodel copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return Experiencemodel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Experiencemodel.fromJson(Map<String, dynamic> json) {
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
  String? experience;

  Data({this.id, this.experience});

  /// Initial (empty) object
  factory Data.initial() {
    return Data(
      id: 0,
      experience: '',
    );
  }

  /// Copy with new values
  Data copyWith({
    int? id,
    String? experience,
  }) {
    return Data(
      id: id ?? this.id,
      experience: experience ?? this.experience,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    experience = json['experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['experience'] = experience;
    return map;
  }
}
