import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'models/user_model.dart';
import 'user_controller.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserController _userController;
  late String _username;
  final _followController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userController = UserController(Hive.box<User>('users'));
    _loadUsername();
  }

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username')!;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _followUser() async {
    if (_followController.text.isNotEmpty) {
      await _userController.followUser(_username, _followController.text);
      _followController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _userController.getUser(_username);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Username: ${user.username}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _followController,
                    decoration: InputDecoration(labelText: 'Follow Username'),
                  ),
                ),
                ElevatedButton(
                  onPressed: _followUser,
                  child: Text('Follow'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: user.tweets.length,
                    itemBuilder: (context, index) {
                      final tweet = user.tweets[index];
                      return ListTile(
                        title: Text(tweet.text),
                        subtitle: Text('Likes: ${tweet.favorites}'),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}


