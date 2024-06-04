import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String password;

  @HiveField(2)
  List<Tweet> tweets;

  @HiveField(3)
  List<String> followers;

  @HiveField(4)
  List<String> following;

  User({
    required this.username,
    required this.password,
    List<Tweet>? tweets,
    List<String>? followers,
    List<String>? following,
  })  : tweets = tweets ?? [],
        followers = followers ?? [],
        following = following ?? [];
}

@HiveType(typeId: 1)
class Tweet {
  @HiveField(0)
  final String text;

  @HiveField(1)
  int favorites;

  @HiveField(2)
  final DateTime timestamp;

  Tweet({
    required this.text,
    this.favorites = 0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
