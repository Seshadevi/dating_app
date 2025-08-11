class MatchUserModel {
  final int matchId;
  final int userId;
  final String name;
  final String avatar;

  MatchUserModel({
    required this.matchId,
    required this.userId,
    required this.name,
    required this.avatar,
  });

  factory MatchUserModel.fromJson(Map<String, dynamic> json) {
    final profilePics = json['withUser']['profile_pics'] as List?;
    final avatar = (profilePics != null && profilePics.isNotEmpty)
        ? 'http://97.74.93.26:6100${profilePics[0]['url']}'
        : 'https://via.placeholder.com/150'; // fallback

    return MatchUserModel(
      matchId: json['matchId'],
      userId: json['withUser']['id'],
      name: json['withUser']['name'] ?? '',
      avatar: avatar,
    );
  }
}
