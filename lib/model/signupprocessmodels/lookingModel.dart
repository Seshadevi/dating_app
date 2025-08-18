class LookingForUser {
  bool? success;
  String? message;
  List<Data>? data;

  LookingForUser({this.success, this.message, this.data});

  /// Initial factory
  factory LookingForUser.initial() => LookingForUser(
        success: false,
        message: "",
        data: [],
      );

  /// CopyWith method
  LookingForUser copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return LookingForUser(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  LookingForUser.fromJson(Map<String, dynamic> json) {
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
  String? value;
  int? modeId;
  Mode? mode;

  Data({this.id, this.value, this.modeId, this.mode});

  /// Initial factory
  factory Data.initial() => Data(
        id: 0,
        value: "",
        modeId: 0,
        mode: Mode.initial(),
      );

  /// CopyWith method
  Data copyWith({
    int? id,
    String? value,
    int? modeId,
    Mode? mode,
  }) {
    return Data(
      id: id ?? this.id,
      value: value ?? this.value,
      modeId: modeId ?? this.modeId,
      mode: mode ?? this.mode,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    modeId = json['modeId'];
    mode = json['mode'] != null ? Mode.fromJson(json['mode']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['value'] = value;
    map['modeId'] = modeId;
    if (mode != null) {
      map['mode'] = mode!.toJson();
    }
    return map;
  }
}

class Mode {
  int? id;
  String? value;

  Mode({this.id, this.value});

  /// Initial factory
  factory Mode.initial() => Mode(
        id: 0,
        value: "",
      );

  /// CopyWith method
  Mode copyWith({
    int? id,
    String? value,
  }) {
    return Mode(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }

  Mode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['value'] = value;
    return map;
  }
}
