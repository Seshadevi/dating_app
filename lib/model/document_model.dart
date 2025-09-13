class DocumentID {
  String? message;
  int? userId;
  bool? isVerified;
  List<Verifications>? verifications;

  // Sentinel: lets copyWith distinguish "not provided" vs "set to null"
  static const Object _unset = Object();

  DocumentID({
    this.message,
    this.userId,
    this.isVerified,
    this.verifications,
  });

  /// Convenient empty/initial instance
  factory DocumentID.initial() => DocumentID(
        message: '',
        userId: null,
        isVerified: false,
        verifications: <Verifications>[],
      );

  /// Safe copyWith. To clear a field, pass `null` explicitly.
  DocumentID copyWith({
    Object? message = _unset,
    Object? userId = _unset,
    Object? isVerified = _unset,
    Object? verifications = _unset,
  }) {
    return DocumentID(
      message: identical(message, _unset) ? this.message : message as String?,
      userId: identical(userId, _unset) ? this.userId : userId as int?,
      isVerified:
          identical(isVerified, _unset) ? this.isVerified : isVerified as bool?,
      verifications: identical(verifications, _unset)
          ? this.verifications
          : (verifications as List<Verifications>?),
    );
  }

  DocumentID.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userId = json['userId'];
    isVerified = json['isVerified'];
    if (json['verifications'] is List) {
      verifications = (json['verifications'] as List)
          .map((v) => Verifications.fromJson(v as Map<String, dynamic>))
          .toList();
    } else {
      verifications = <Verifications>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['userId'] = userId;
    data['isVerified'] = isVerified;
    if (verifications != null) {
      data['verifications'] = verifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Verifications {
  int? id;
  bool? verified;
  List<String>? images;
  String? createdAt;
  String? updatedAt;

  static const Object _unset = Object();

  Verifications({
    this.id,
    this.verified,
    this.images,
    this.createdAt,
    this.updatedAt,
  });

  /// Initial/empty instance
  factory Verifications.initial() => Verifications(
        id: null,
        verified: false,
        images: <String>[],
        createdAt: '',
        updatedAt: '',
      );

  Verifications copyWith({
    Object? id = _unset,
    Object? verified = _unset,
    Object? images = _unset,
    Object? createdAt = _unset,
    Object? updatedAt = _unset,
  }) {
    return Verifications(
      id: identical(id, _unset) ? this.id : id as int?,
      verified:
          identical(verified, _unset) ? this.verified : verified as bool?,
      images: identical(images, _unset)
          ? this.images
          : (images as List<String>?),
      createdAt:
          identical(createdAt, _unset) ? this.createdAt : createdAt as String?,
      updatedAt:
          identical(updatedAt, _unset) ? this.updatedAt : updatedAt as String?,
    );
  }

  Verifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    verified = json['verified'];

    final dynamic imgs = json['images'];
    if (imgs is List) {
      images = imgs.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    } else {
      images = <String>[];
    }

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['verified'] = verified;
    data['images'] = images;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
