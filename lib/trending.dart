import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tpmresti/trend.dart';

class TrendingPage extends StatefulWidget {
  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  late Future<List<Trend>> trends;

  Future<List<Trend>> fetchTrends() async {
    final response = await http.get(Uri.parse(
        'http://twitter-trends-api.azharimm.dev/trends?location=indonesia'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      TrendResponse trendResponse = TrendResponse.fromJson(json);

      if (trendResponse.status) {
        return trendResponse.trendsData.first.trends;
      } else {
        throw Exception('Failed to load trends');
      }
    } else {
      throw Exception('Failed to load trends');
    }
  }

  @override
  void initState() {
    super.initState();
    trends = fetchTrends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trending in Indonesia'),
      ),
      body: FutureBuilder<List<Trend>>(
        future: trends,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load trends'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No trends available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Trend trend = snapshot.data![index];
                return ListTile(
                  title: Text(trend.name),
                  subtitle: Text('Tweets: ${trend.tweetCount}'),
                  onTap: () {
                    // Handle tap on trend
                    // For example, open the URL in a webview or browser
                    // launch(trend.url);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
