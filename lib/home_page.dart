import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:tpmresti/timezone.dart';
import 'package:tpmresti/currency.dart'; 
import 'package:tpmresti/trending.dart';
import 'dart:js' as js;
import 'models/user_model.dart';
import 'user_controller.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserController _userController;
  late String _username;
  final _tweetController = TextEditingController();
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

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

  void _addTweet() async {
    if (_tweetController.text.isNotEmpty) {
      if (_username.isNotEmpty) {
        final tweet = Tweet(text: _tweetController.text);
        await _userController.addTweet(_username, tweet);
        _tweetController.clear();
        js.context.callMethod('showNotification');
        setState(() {});
      } else {
        print('Error: _username is not initialized');
      }
    }
  }

  void _likeTweet(Tweet tweet) async {
    await _userController.likeTweet(_username, tweet);
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  } // Tambahkan tanda kurung kurawal untuk menutup fungsi ini

  @override
  Widget build(BuildContext context) {
    final user = _userController.getUser(_username);
    final tweets = <Tweet>[];

    if (user != null) {
      for (var following in user.following) {
        final followingUser = _userController.getUser(following);
        if (followingUser != null) {
          tweets.addAll(followingUser.tweets);
        }
      }
      tweets.addAll(user.tweets);
      tweets.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }

    // Pages for bottom navigation
    final List<Widget> _pages = [
      // HomePage
      Scaffold(
        appBar: AppBar(
          title: Text('Home'), 
        ),
        body: user == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _tweetController,
                      decoration:
                          InputDecoration(labelText: 'What\'s happening?'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _addTweet,
                    child: Text('Tweet'),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (context, index) {
                        final tweet = tweets[index];
                        return ListTile(
                          title: Text(tweet.text),
                          subtitle: Text('Likes: ${tweet.favorites}'),
                          trailing: IconButton(
                            icon: Icon(Icons.thumb_up),
                            onPressed: () => _likeTweet(tweet),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      TrendingPage(), 
      CurrencyConverterPage(), 
      WorldClockPage(), 
      ProfilePage()
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: 
      BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Currency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'World Clock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey, // Tambahkan warna abu-abu untuk ikon tidak aktif
      ),
    );
  }
}
