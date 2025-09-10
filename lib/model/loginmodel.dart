import 'package:dating/model/signupprocessmodels/lookingModel.dart';

class UserModel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  UserModel({this.statusCode, this.success, this.messages, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = json['messages']?.cast<String>();
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['messages'] = messages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  UserModel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return UserModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }

  static UserModel initial() {
    return UserModel(
      statusCode: null,
      success: null,
      messages: null,
      data: null,
    );
  }
}

class Data {
  String? accessToken;
  String? refreshToken;
  User? user;

  Data({this.accessToken, this.refreshToken, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }

  Data copyWith({
    String? accessToken,
    String? refreshToken,
    User? user,
  }) {
    return Data(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
    );
  }

  static Data initial() {
    return Data(
      accessToken: null,
      refreshToken: null,
      user: null,
    );
  }
}

class User {
  int? id;
  String? mobile;
  String? role;
  String? email;
  String? firstName;
  String? lastName;
  String? gender;
  String? pronouns;
  bool? showOnProfile;
  String? headLine;
  bool? termsAndConditions;
  List<Modes>? mode;
  List<Qualities>? qualities;
  List<Drinking>? drinking;
  List<Kids>? kids;
  List<Religions>? religions;
  List<Interests>? interests;
  List<LookingFor>? lookingFor;
  List<CausesAndCommunities>? causesAndCommunities;
  List<Prompts>? prompts;
  List<DefaultMessages>? defaultMessages;
  List<ProfilePics>? profilePics;
  StarSign? starSign;
  Education? education;
  Work? work;
  List<Language>? spokenLanguages;
  Location? location;
  String? educationLevel;
  String? exercise;
  String? haveKids;
  List<GenderIdentities>? genderIdentities;
  String? smoking;
  String? politics;
  String? hometown;
  int? height;
  List<Experiences>? experiences;
  List<Industries>? industries;
  String? newToArea;
  List<Relationships>? relationships;

  User(
      {this.id,
      this.mobile,
      this.role,
      this.email,
      this.firstName,
      this.lastName,
      this.gender,
      this.pronouns,
      this.showOnProfile,
      this.headLine,
      this.termsAndConditions,
      // this.mode,
      this.qualities,
      this.drinking,
      this.kids,
      this.religions,
      this.interests,
      this.lookingFor,
      this.causesAndCommunities,
      this.prompts,
      this.defaultMessages,
      this.profilePics,
      this.starSign,
      this.education,
      this.work,
      this.spokenLanguages,
      this.location,
      this.educationLevel,
      this.exercise,
      this.haveKids,
      this.genderIdentities,
      this.smoking,
      this.politics,
      this.hometown,
      this.height,
      this.newToArea,
      this.experiences,
      this.industries,
      this.relationships,
      this.mode});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobile = json['mobile'];
    role = json['role'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    pronouns = json['pronouns'];
    showOnProfile = json['showOnProfile'];
    headLine = json['headLine'];
    termsAndConditions = json['termsAndConditions'];
    // mode = json['mode'];
    if (json['qualities'] != null) {
      qualities = <Qualities>[];
      json['qualities'].forEach((v) {
        qualities!.add(Qualities.fromJson(v));
      });
    }
    if (json['drinking'] != null) {
      drinking = <Drinking>[];
      json['drinking'].forEach((v) {
        drinking!.add(Drinking.fromJson(v));
      });
    }
    if (json['kids'] != null) {
      kids = <Kids>[];
      json['kids'].forEach((v) {
        kids!.add(Kids.fromJson(v));
      });
    }
    if (json['religions'] != null) {
      religions = <Religions>[];
      json['religions'].forEach((v) {
        religions!.add(Religions.fromJson(v));
      });
    }
    if (json['modes'] != null) {
      mode = <Modes>[];
      json['modes'].forEach((v) {
        mode!.add(Modes.fromJson(v));
      });
    }
     if (json['industries'] != null) {
      industries = <Industries>[];
      json['industries'].forEach((v) {
        industries!.add(Industries.fromJson(v));
      });
    }
     if (json['experiences'] != null) {
      experiences = <Experiences>[];
      json['experiences'].forEach((v) {
        experiences!.add(Experiences.fromJson(v));
      });
    }
     if (json['relationships'] != null) {
      relationships = <Relationships>[];
      json['relationships'].forEach((v) {
        relationships!.add(Relationships.fromJson(v));
      });
    }
    if (json['interests'] != null) {
      interests = <Interests>[];
      json['interests'].forEach((v) {
        interests!.add(Interests.fromJson(v));
      });
    }
    if (json['lookingFor'] != null) {
      lookingFor = <LookingFor>[];
      json['lookingFor'].forEach((v) {
        lookingFor!.add(LookingFor.fromJson(v));
      });
    }
    if (json['causesAndCommunities'] != null) {
      causesAndCommunities = <CausesAndCommunities>[];
      json['causesAndCommunities'].forEach((v) {
        causesAndCommunities!.add(CausesAndCommunities.fromJson(v));
      });
    }
    if (json['prompts'] != null) {
      prompts = <Prompts>[];
      json['prompts'].forEach((v) {
        prompts!.add(Prompts.fromJson(v));
      });
    }
    if (json['defaultMessages'] != null) {
      defaultMessages = <DefaultMessages>[];
      json['defaultMessages'].forEach((v) {
        defaultMessages!.add(DefaultMessages.fromJson(v));
      });
    }
    if (json['profile_pics'] != null) {
      profilePics = <ProfilePics>[];
      json['profile_pics'].forEach((v) {
        profilePics!.add(ProfilePics.fromJson(v));
      });
    }
    starSign =
        json['starSign'] != null ? StarSign.fromJson(json['starSign']) : null;
    education = json['education'] != null
        ? Education.fromJson(json['education'])
        : null;
    work = json['work'] != null ? Work.fromJson(json['work']) : null;
    // spokenLanguages =
    //     json['spokenLanguages'] != null ? Language.fromJson(json['spokenLanguages']) : null;
    if (json['spokenLanguages'] != null) {
      spokenLanguages = <Language>[];
      json['spokenLanguages'].forEach((v) {
        spokenLanguages!.add(Language.fromJson(v));
      });
    }
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    educationLevel = json['educationLevel'];
    exercise = json['exercise'];
    haveKids = json['haveKids'];
    newToArea = json['newToArea'];
    if (json['genderIdentities'] != null) {
      genderIdentities = <GenderIdentities>[];
      json['genderIdentities'].forEach((v) {
        genderIdentities!.add(GenderIdentities.fromJson(v));
      });
    }
    smoking = json['smoking'];
    politics = json['politics'];
    hometown = json['hometown'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mobile'] = mobile;
    data['role'] = role;
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['gender'] = gender;
    data['pronouns'] = pronouns;
    data['showOnProfile'] = showOnProfile;
    data['headLine'] = headLine;
    data['termsAndConditions'] = termsAndConditions;
    // data['mode'] = mode;
    if (qualities != null) {
      data['qualities'] = qualities!.map((v) => v.toJson()).toList();
    }
    if (drinking != null) {
      data['drinking'] = drinking!.map((v) => v.toJson()).toList();
    }
    if (kids != null) {
      data['kids'] = kids!.map((v) => v.toJson()).toList();
    }
    if (religions != null) {
      data['religions'] = religions!.map((v) => v.toJson()).toList();
    }
     if (mode != null) {
      data['modes'] = mode!.map((v) => v.toJson()).toList();
    }
     if (industries != null) {
      data['industries'] = industries!.map((v) => v.toJson()).toList();
    }
     if (experiences != null) {
      data['experiences'] = experiences!.map((v) => v.toJson()).toList();
    }
     if (relationships != null) {
      data['relationships'] = relationships!.map((v) => v.toJson()).toList();
    }
    if (interests != null) {
      data['interests'] = interests!.map((v) => v.toJson()).toList();
    }
    if (lookingFor != null) {
      data['lookingFor'] = lookingFor!.map((v) => v.toJson()).toList();
    }
    if (causesAndCommunities != null) {
      data['causesAndCommunities'] =
          causesAndCommunities!.map((v) => v.toJson()).toList();
    }
    if (prompts != null) {
      data['prompts'] = prompts!.map((v) => v.toJson()).toList();
    }
    if (defaultMessages != null) {
      data['defaultMessages'] =
          defaultMessages!.map((v) => v.toJson()).toList();
    }
    if (profilePics != null) {
      data['profile_pics'] = profilePics!.map((v) => v.toJson()).toList();
    }
    if (starSign != null) {
      data['starSign'] = starSign!.toJson();
    }
    if (education != null) {
      data['education'] = education!.toJson();
    }
    if (work != null) {
      data['work'] = work!.toJson();
    }
    if (spokenLanguages != null) {
      data['language'] = spokenLanguages!.map((v) => v.toJson()).toList();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['educationLevel'] = educationLevel;
    data['exercise'] = exercise;
    data['haveKids'] = haveKids;
    data['newToArea'] = newToArea;
    if (genderIdentities != null) {
      data['genderIdentities'] =
          genderIdentities!.map((v) => v.toJson()).toList();
    }
    data['smoking'] = smoking;
    data['politics'] = politics;
    data['hometown'] = hometown;
    data['height'] = height;
    return data;
  }

  User copyWith({
    int? id,
    String? mobile,
    String? role,
    String? email,
    String? firstName,
    String? lastName,
    String? gender,
    String? pronouns,
    bool? showOnProfile,
    String? headLine,
    bool? termsAndConditions,
    List<Modes>? mode,
    List<Qualities>? qualities,
    List<Drinking>? drinking,
    List<Kids>? kids,
    List<Religions>? religions,


    List<Interests>? interests,
    List<LookingFor>? lookingFor,
    List<CausesAndCommunities>? causesAndCommunities,
    List<Prompts>? prompts,
    List<DefaultMessages>? defaultMessages,
    List<ProfilePics>? profilePics,
    StarSign? starSign,
    Education? education,
    Work? work,
    List<Language>? spokenLanguages,
    Location? location,
    String? educationLevel,
    String? exercise,
    String? haveKids,
    List<GenderIdentities>? genderIdentities,
    String? smoking,
    String? politics,
    String? hometown,
    int? height,
    String? newToArea,
    List<Experiences>? experiences,
    List<Industries>? industries,
    
    List<Relationships>? relationships,

  }) {
    return User(
      id: id ?? this.id,
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      pronouns: pronouns ?? this.pronouns,
      showOnProfile: showOnProfile ?? this.showOnProfile,
      headLine: headLine ?? this.headLine,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      mode: mode ?? this.mode,
      qualities: qualities ?? this.qualities,
      drinking: drinking ?? this.drinking,
      kids: kids ?? this.kids,
      religions: religions ?? this.religions,
      industries: industries?? this.industries,
      experiences: experiences?? this.experiences,
      relationships: relationships?? this.relationships,
      interests: interests ?? this.interests,
      lookingFor: lookingFor ?? this.lookingFor,
      causesAndCommunities: causesAndCommunities ?? this.causesAndCommunities,
      prompts: prompts ?? this.prompts,
      defaultMessages: defaultMessages ?? this.defaultMessages,
      profilePics: profilePics ?? this.profilePics,
      starSign: starSign ?? this.starSign,
      education: education ?? this.education,
      work: work ?? this.work,
      spokenLanguages: spokenLanguages ?? this.spokenLanguages,
      location: location ?? this.location,
      educationLevel: educationLevel ?? this.educationLevel,
      exercise: exercise ?? this.exercise,
      haveKids: haveKids ?? this.haveKids,
      newToArea:newToArea??this.newToArea,
      genderIdentities: genderIdentities ?? this.genderIdentities,
      smoking: smoking ?? this.smoking,
      politics: politics ?? this.politics,
      hometown: hometown ?? this.hometown,
      height: height ?? this.height,
    );
  }

  static User initial() {
    return User();
  }
}

class Experiences {
  int? id;
  String? experience;
  UserExperiences? userExperiences;

  Experiences({
    this.id,
    this.experience,
    this.userExperiences,
  });

  factory Experiences.fromJson(Map<String, dynamic> json) {
    return Experiences(
      id: json['id'],
      experience: json['experience'],
      userExperiences: json['user_experiences'] != null
          ? UserExperiences.fromJson(json['user_experiences'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['experience'] = experience;
    if (userExperiences != null) {
      data['user_experiences'] = userExperiences!.toJson();
    }
    return data;
  }

  Experiences copyWith({
    int? id,
    String? experiences,
    UserExperiences? userExperiences,
  }) {
    return Experiences(
      id: id ?? this.id,
      experience: experiences ?? this.experience,
      userExperiences: userExperiences ?? this.userExperiences,
    );
  }

  factory Experiences.initial() {
    return Experiences(
      id: 0,
      experience: '',
      userExperiences: UserExperiences.initial(),
    );
  }
}

class UserExperiences {
  int? userId;
  int? experiencesId;

  UserExperiences({
    this.userId,
    this.experiencesId,
  });

  factory UserExperiences.fromJson(Map<String, dynamic> json) {
    return UserExperiences(
      userId: json['user_id'],
      experiencesId: json['experiences_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['experiences_id'] = experiencesId;
    return data;
  }

  UserExperiences copyWith({
    int? userId,
    int? experiencesId,
  }) {
    return UserExperiences(
      userId: userId ?? this.userId,
      experiencesId: experiencesId ?? this.experiencesId,
    );
  }

  factory UserExperiences.initial() {
    return UserExperiences(
      userId: 0,
      experiencesId: 0,
    );
  }
}


class Industries {
  int? id;
  String? industrie;
  UserIndustries? userIndustries;

  Industries({this.id, this.industrie, this.userIndustries});

  factory Industries.fromJson(Map<String, dynamic> json) {
    return Industries(
      id: json['id'],
      industrie: json['industry'],
      userIndustries: json['user_industries'] != null
          ? UserIndustries.fromJson(json['user_industries'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['industry'] = industrie;
    if (userIndustries != null) {
      data['user_industries'] = userIndustries!.toJson();
    }
    return data;
  }

  Industries copyWith({
    int? id,
    String? industrie,
    UserIndustries? userIndustries,
  }) {
    return Industries(
      id: id ?? this.id,
      industrie: industrie ?? this.industrie,
      userIndustries: userIndustries ?? this.userIndustries,
    );
  }

  factory Industries.initial() {
    return Industries(
      id: 0,
      industrie: '',
      userIndustries: UserIndustries.initial(),
    );
  }
}


class UserIndustries {
  int? userId;
  int? industriesId;

  UserIndustries({this.userId, this.industriesId});

  UserIndustries.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    industriesId = json['industries_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['industries_id'] = industriesId;
    return data;
  }

  UserIndustries copyWith({
    int? userId,
    int? industriesId,
  }) {
    return UserIndustries(
      userId: userId ?? this.userId,
      industriesId: industriesId ?? this.industriesId,
    );
  }

  static UserIndustries initial() {
    return UserIndustries();
  }
}
class Relationships {
  int? id;
  String? relation;
  UserRelation? userRelation;

  Relationships({this.id, this.relation, this.userRelation});

  factory Relationships.fromJson(Map<String, dynamic> json) {
    return Relationships(
      id: json['id'],
      relation: json['relation'],
      userRelation: json['user_relation'] != null
          ? UserRelation.fromJson(json['user_relation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['relation'] = relation;
    if (userRelation != null) {
      data['user_relation'] = userRelation!.toJson();
    }
    return data;
  }

  Relationships copyWith({
    int? id,
    String? relation,
    UserRelation? userRelation,
  }) {
    return Relationships(
      id: id ?? this.id,
      relation: relation ?? this.relation,
      userRelation: userRelation ?? this.userRelation,
    );
  }

  factory Relationships.initial() {
    return Relationships(
      id: 0,
      relation: '',
      userRelation: UserRelation.initial(),
    );
  }
}

class UserRelation {
  int? userId;
  int? relationId;

  UserRelation({this.userId, this.relationId});

  factory UserRelation.fromJson(Map<String, dynamic> json) {
    return UserRelation(
      userId: json['user_id'],
      relationId: json['relation_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['relation_id'] = relationId;
    return data;
  }

  UserRelation copyWith({
    int? userId,
    int? relationId,
  }) {
    return UserRelation(
      userId: userId ?? this.userId,
      relationId: relationId ?? this.relationId,
    );
  }

  factory UserRelation.initial() {
    return UserRelation(
      userId: 0,
      relationId: 0,
    );
  }
}


class Qualities {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  UserQualities? userQualities;

  Qualities(
      {this.id, this.name, this.createdAt, this.updatedAt, this.userQualities});

  Qualities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userQualities = json['user_qualities'] != null
        ? UserQualities.fromJson(json['user_qualities'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (userQualities != null) {
      data['user_qualities'] = userQualities!.toJson();
    }
    return data;
  }

  Qualities copyWith({
    int? id,
    String? name,
    String? createdAt,
    String? updatedAt,
    UserQualities? userQualities,
  }) {
    return Qualities(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userQualities: userQualities ?? this.userQualities,
    );
  }

  static Qualities initial() {
    return Qualities();
  }
}

class UserQualities {
  int? userId;
  int? qualitiesId;

  UserQualities({this.userId, this.qualitiesId});

  UserQualities.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    qualitiesId = json['qualities_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['qualities_id'] = qualitiesId;
    return data;
  }

  UserQualities copyWith({
    int? userId,
    int? qualitiesId,
  }) {
    return UserQualities(
      userId: userId ?? this.userId,
      qualitiesId: qualitiesId ?? this.qualitiesId,
    );
  }

  static UserQualities initial() {
    return UserQualities();
  }
}

class Drinking {
  int? id;
  String? preference;
  String? createdAt;
  String? updatedAt;
  UserDrinking? userDrinking;

  Drinking(
      {this.id,
      this.preference,
      this.createdAt,
      this.updatedAt,
      this.userDrinking});

  Drinking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    preference = json['preference'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userDrinking = json['user_drinking'] != null
        ? UserDrinking.fromJson(json['user_drinking'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['preference'] = preference;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (userDrinking != null) {
      data['user_drinking'] = userDrinking!.toJson();
    }
    return data;
  }

  Drinking copyWith({
    int? id,
    String? preference,
    String? createdAt,
    String? updatedAt,
    UserDrinking? userDrinking,
  }) {
    return Drinking(
      id: id ?? this.id,
      preference: preference ?? this.preference,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userDrinking: userDrinking ?? this.userDrinking,
    );
  }

  static Drinking initial() {
    return Drinking();
  }
}

class UserDrinking {
  int? userId;
  int? drinkingId;

  UserDrinking({this.userId, this.drinkingId});

  UserDrinking.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    drinkingId = json['drinking_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['drinking_id'] = drinkingId;
    return data;
  }

  UserDrinking copyWith({
    int? userId,
    int? drinkingId,
  }) {
    return UserDrinking(
      userId: userId ?? this.userId,
      drinkingId: drinkingId ?? this.drinkingId,
    );
  }

  static UserDrinking initial() {
    return UserDrinking();
  }
}

class Kids {
  int? id;
  String? kids;
  String? createdAt;
  String? updatedAt;
  UserKids? userKids;

  Kids({this.id, this.kids, this.createdAt, this.updatedAt, this.userKids});

  Kids.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kids = json['kids'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userKids =
        json['user_kids'] != null ? UserKids.fromJson(json['user_kids']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['kids'] = kids;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (userKids != null) {
      data['user_kids'] = userKids!.toJson();
    }
    return data;
  }

  Kids copyWith({
    int? id,
    String? kids,
    String? createdAt,
    String? updatedAt,
    UserKids? userKids,
  }) {
    return Kids(
      id: id ?? this.id,
      kids: kids ?? this.kids,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userKids: userKids ?? this.userKids,
    );
  }

  static Kids initial() {
    return Kids();
  }
}

class UserKids {
  int? userId;
  int? kidsId;

  UserKids({this.userId, this.kidsId});

  UserKids.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    kidsId = json['kids_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['kids_id'] = kidsId;
    return data;
  }

  UserKids copyWith({
    int? userId,
    int? kidsId,
  }) {
    return UserKids(
      userId: userId ?? this.userId,
      kidsId: kidsId ?? this.kidsId,
    );
  }

  static UserKids initial() {
    return UserKids();
  }
}
class Modes {
  int? id;
  String? mode;
  UserMode? usermode;

  Modes({this.id, this.mode, this.usermode});

  Modes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mode = json['value'];
    usermode= json['user_rvalue'] != null
        ? UserMode.fromJson(json['user_value'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = mode;
    if (usermode != null) {
      data['user_value'] = usermode!.toJson();
    }
    return data;
  }

  Modes copyWith({
    int? id,
    String? mode,
    UserMode? usermode,
  }) {
    return Modes(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      usermode: usermode ?? this.usermode,
    );
  }

  static Modes initial() {
    return Modes();
  }
}
class UserMode {
  int? userId;
  int? modeId;

  UserMode({this.userId, this.modeId});

  UserMode.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    modeId = json['value_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['value_id'] = modeId;
    return data;
  }

 UserMode copyWith({
    int? userId,
    int? modeId,
  }) {
    return UserMode(
      userId: userId ?? this.userId,
      modeId: modeId ?? this.modeId,
    );
  }

  static UserMode initial() {
    return UserMode();
  }
}

class Religions {
  int? id;
  String? religion;
  UserReligion? userReligion;

  Religions({this.id, this.religion, this.userReligion});

  Religions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    religion = json['religion'];
    userReligion = json['user_religion'] != null
        ? UserReligion.fromJson(json['user_religion'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['religion'] = religion;
    if (userReligion != null) {
      data['user_religion'] = userReligion!.toJson();
    }
    return data;
  }

  Religions copyWith({
    int? id,
    String? religion,
    UserReligion? userReligion,
  }) {
    return Religions(
      id: id ?? this.id,
      religion: religion ?? this.religion,
      userReligion: userReligion ?? this.userReligion,
    );
  }

  static Religions initial() {
    return Religions();
  }
}


class UserReligion {
  int? userId;
  int? religionId;

  UserReligion({this.userId, this.religionId});

  UserReligion.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    religionId = json['religion_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['religion_id'] = religionId;
    return data;
  }

  UserReligion copyWith({
    int? userId,
    int? religionId,
  }) {
    return UserReligion(
      userId: userId ?? this.userId,
      religionId: religionId ?? this.religionId,
    );
  }

  static UserReligion initial() {
    return UserReligion();
  }
}

class Interests {
  int? id;
  String? interests;
  UserInterest? userInterest;

  Interests({this.id, this.interests, this.userInterest});

  Interests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    interests = json['interests'];
    userInterest = json['user_interest'] != null
        ? UserInterest.fromJson(json['user_interest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['interests'] = interests;
    if (userInterest != null) {
      data['user_interest'] = userInterest!.toJson();
    }
    return data;
  }

  Interests copyWith({
    int? id,
    String? interests,
    UserInterest? userInterest,
  }) {
    return Interests(
      id: id ?? this.id,
      interests: interests ?? this.interests,
      userInterest: userInterest ?? this.userInterest,
    );
  }

  static Interests initial() {
    return Interests();
  }
}

class UserInterest {
  int? userId;
  int? interestId;

  UserInterest({this.userId, this.interestId});

  UserInterest.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    interestId = json['interest_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['interest_id'] = interestId;
    return data;
  }

  UserInterest copyWith({
    int? userId,
    int? interestId,
  }) {
    return UserInterest(
      userId: userId ?? this.userId,
      interestId: interestId ?? this.interestId,
    );
  }

  static UserInterest initial() {
    return UserInterest();
  }
}

class LookingFor {
  int? id;
  String? value;
  UserLookingFor? userLookingFor;

  LookingFor({this.id, this.value, this.userLookingFor});

  LookingFor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    userLookingFor = json['user_lookingFor'] != null
        ? UserLookingFor.fromJson(json['user_lookingFor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    if (userLookingFor != null) {
      data['user_lookingFor'] = userLookingFor!.toJson();
    }
    return data;
  }

  LookingFor copyWith({
    int? id,
    String? value,
    UserLookingFor? userLookingFor,
  }) {
    return LookingFor(
      id: id ?? this.id,
      value: value ?? this.value,
      userLookingFor: userLookingFor ?? this.userLookingFor,
    );
  }

  static LookingFor initial() {
    return LookingFor();
  }
}

class UserLookingFor {
  int? userId;
  int? lookingForId;

  UserLookingFor({this.userId, this.lookingForId});

  UserLookingFor.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    lookingForId = json['lookingFor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['lookingFor_id'] = lookingForId;
    return data;
  }

  UserLookingFor copyWith({
    int? userId,
    int? lookingForId,
  }) {
    return UserLookingFor(
      userId: userId ?? this.userId,
      lookingForId: lookingForId ?? this.lookingForId,
    );
  }

  static UserLookingFor initial() {
    return UserLookingFor();
  }
}

class GenderIdentities {
  int? id;
  String? value;
  String? createdAt;
  String? updatedAt;
  UserGenders? userGenders;

  GenderIdentities({
    this.id,
    this.value,
    this.createdAt,
    this.updatedAt,
    this.userGenders,
  });

  GenderIdentities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userGenders = json['user_genders'] != null
        ? UserGenders.fromJson(json['user_genders'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (userGenders != null) {
      data['user_genders'] = userGenders!.toJson();
    }
    return data;
  }

  GenderIdentities copyWith({
    int? id,
    String? value,
    String? createdAt,
    String? updatedAt,
    UserGenders? userGenders,
  }) {
    return GenderIdentities(
      id: id ?? this.id,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userGenders: userGenders ?? this.userGenders,
    );
  }

  static GenderIdentities initial() {
    return GenderIdentities();
  }
}

class UserGenders {
  int? userId;
  int? genderId;

  UserGenders({this.userId, this.genderId});

  UserGenders.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    genderId = json['gender_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['gender_id'] = genderId;
    return data;
  }

  UserGenders copyWith({
    int? userId,
    int? genderId,
  }) {
    return UserGenders(
      userId: userId ?? this.userId,
      genderId: genderId ?? this.genderId,
    );
  }

  static UserGenders initial() {
    return UserGenders();
  }
}

class CausesAndCommunities {
  int? id;
  String? causesAndCommunities;
  String? createdAt;
  String? updatedAt;
  UserCauseAndCommunities? userCauseAndCommunities;

  CausesAndCommunities({
    this.id,
    this.causesAndCommunities,
    this.createdAt,
    this.updatedAt,
    this.userCauseAndCommunities,
  });

  CausesAndCommunities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    causesAndCommunities = json['causesAndCommunities'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userCauseAndCommunities = json['user_causeAndCommunities'] != null
        ? UserCauseAndCommunities.fromJson(json['user_causeAndCommunities'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['causesAndCommunities'] = causesAndCommunities;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (userCauseAndCommunities != null) {
      data['user_causeAndCommunities'] = userCauseAndCommunities!.toJson();
    }
    return data;
  }

  CausesAndCommunities copyWith({
    int? id,
    String? causesAndCommunities,
    String? createdAt,
    String? updatedAt,
    UserCauseAndCommunities? userCauseAndCommunities,
  }) {
    return CausesAndCommunities(
      id: id ?? this.id,
      causesAndCommunities: causesAndCommunities ?? this.causesAndCommunities,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userCauseAndCommunities:
          userCauseAndCommunities ?? this.userCauseAndCommunities,
    );
  }

  static CausesAndCommunities initial() {
    return CausesAndCommunities();
  }
}

class UserCauseAndCommunities {
  int? userId;
  int? causesAndCommunitiesId;

  UserCauseAndCommunities({this.userId, this.causesAndCommunitiesId});

  UserCauseAndCommunities.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    causesAndCommunitiesId = json['causesAndCommunities_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['causesAndCommunities_id'] = causesAndCommunitiesId;
    return data;
  }

  UserCauseAndCommunities copyWith({
    int? userId,
    int? causesAndCommunitiesId,
  }) {
    return UserCauseAndCommunities(
      userId: userId ?? this.userId,
      causesAndCommunitiesId:
          causesAndCommunitiesId ?? this.causesAndCommunitiesId,
    );
  }

  static UserCauseAndCommunities initial() {
    return UserCauseAndCommunities();
  }
}

class Prompts {
  int? id;
  String? prompt;
  String? response;

  Prompts({this.id, this.prompt, this.response});

  Prompts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prompt = json['prompt'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['prompt'] = prompt;
    data['response'] = response;
    return data;
  }

  Prompts copyWith({
    int? id,
    String? prompt,
    String? response,
  }) {
    return Prompts(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      response: response ?? this.response,
    );
  }

  static Prompts initial() {
    return Prompts();
  }
}

class Language {
  int? id;
  String? name;

  Language({this.id, this.name});

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class DefaultMessages {
  int? id;
  String? message;

  DefaultMessages({this.id, this.message});

  DefaultMessages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    return data;
  }

  DefaultMessages copyWith({
    int? id,
    String? message,
  }) {
    return DefaultMessages(
      id: id ?? this.id,
      message: message ?? this.message,
    );
  }

  static DefaultMessages initial() {
    return DefaultMessages();
  }
}

class ProfilePics {
  int? id;
  String? url;
  bool? isPrimary;
  int? userId;
  String? createdAt;
  String? updatedAt;

  ProfilePics({
    this.id,
    this.url,
    this.isPrimary,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  ProfilePics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    isPrimary = json['isPrimary'];
    userId = json['user_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['isPrimary'] = isPrimary;
    data['user_id'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  ProfilePics copyWith({
    int? id,
    String? url,
    bool? isPrimary,
    int? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    return ProfilePics(
      id: id ?? this.id,
      url: url ?? this.url,
      isPrimary: isPrimary ?? this.isPrimary,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static ProfilePics initial() {
    return ProfilePics();
  }
}

class StarSign {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  StarSign({this.id, this.name, this.createdAt, this.updatedAt});

  StarSign.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  StarSign copyWith({
    int? id,
    String? name,
    String? createdAt,
    String? updatedAt,
  }) {
    return StarSign(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static StarSign initial() {
    return StarSign();
  }
}

class Education {
  int? id;
  String? institution;
  int? gradYear;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Education({
    this.id,
    this.institution,
    this.gradYear,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  Education.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    institution = json['institution'];
    gradYear = json['gradYear'];
    userId = json['user_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['institution'] = institution;
    data['gradYear'] = gradYear;
    data['user_id'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Education copyWith({
    int? id,
    String? institution,
    int? gradYear,
    int? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    return Education(
      id: id ?? this.id,
      institution: institution ?? this.institution,
      gradYear: gradYear ?? this.gradYear,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Education initial() {
    return Education();
  }
}

class Work {
  int? id;
  String? title;
  String? company;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Work({
    this.id,
    this.title,
    this.company,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  Work.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    company = json['company'];
    userId = json['user_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['company'] = company;
    data['user_id'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Work copyWith({
    int? id,
    String? title,
    String? company,
    int? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    return Work(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Work initial() {
    return Work();
  }
}

class Location {
  double? latitude;
  double? longitude;
  String? name;

  Location({this.latitude, this.longitude, this.name});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude']?.toDouble();
    longitude = json['longitude']?.toDouble();
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['name'] = name;
    return data;
  }

  Location copyWith({
    double? latitude,
    double? longitude,
    String? name,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
    );
  }

  static Location initial() {
    return Location();
  }
}
