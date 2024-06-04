import 'package:hive/hive.dart';
import 'models/user_model.dart';

class UserController {
  final Box<User> userBox;

  UserController(this.userBox);

  Future<void> addUser(User user) async {
    await userBox.put(user.username, user);
  }

  User? getUser(String username) {
    return userBox.get(username);
  }

  Future<void> addTweet(String username, Tweet tweet) async {
    final user = userBox.get(username);
    if (user != null) {
      user.tweets.add(tweet);
      await userBox.put(username, user);
    }
  }

  Future<void> likeTweet(String username, Tweet tweet) async {
    final user = userBox.get(username);
    if (user != null) {
      final tweetIndex = user.tweets.indexOf(tweet);
      if (tweetIndex != -1) {
        user.tweets[tweetIndex].favorites += 1;
        await userBox.put(username, user);
      }
    }
  }

  Future<void> followUser(String username, String userToFollow) async {
    final user = userBox.get(username);
    final userToFollowObj = userBox.get(userToFollow);

    if (user != null && userToFollowObj != null) {
      if (!user.following.contains(userToFollow)) {
        user.following.add(userToFollow);
        userToFollowObj.followers.add(username);

        await userBox.put(username, user);
        await userBox.put(userToFollow, userToFollowObj);
      }
    }
  }

  Future<void> unfollowUser(String username, String userToUnfollow) async {
    final user = userBox.get(username);
    final userToUnfollowObj = userBox.get(userToUnfollow);

    if (user != null && userToUnfollowObj != null) {
      if (user.following.contains(userToUnfollow)) {
        user.following.remove(userToUnfollow);
        userToUnfollowObj.followers.remove(username);

        await userBox.put(username, user);
        await userBox.put(userToUnfollow, userToUnfollowObj);
      }
    }
  }
}
