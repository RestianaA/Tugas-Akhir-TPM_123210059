class Trend {
  final String name;
  final String tweetCount;

  Trend({required this.name, required this.tweetCount});

  factory Trend.fromJson(Map<String, dynamic> json) {
    return Trend(
      name: json['name'],
      tweetCount: json['tweet_count'],
    );
  }
}

class TrendData {
  final String datetime;
  final String time;
  final List<Trend> trends;

  TrendData({required this.datetime, required this.time, required this.trends});

  factory TrendData.fromJson(Map<String, dynamic> json) {
    var trendsList = json['data'] as List;
    List<Trend> trends = trendsList.map((trendJson) => Trend.fromJson(trendJson)).toList();

    return TrendData(
      datetime: json['datetime'],
      time: json['time'],
      trends: trends,
    );
  }
}

class TrendResponse {
  final bool status;
  final String location;
  final List<TrendData> trendsData;

  TrendResponse({required this.status, required this.location, required this.trendsData});

  factory TrendResponse.fromJson(Map<String, dynamic> json) {
    var trendsDataList = json['data']['trends'] as List;
    List<TrendData> trendsData = trendsDataList.map((dataJson) => TrendData.fromJson(dataJson)).toList();

    return TrendResponse(
      status: json['status'],
      location: json['data']['location'],
      trendsData: trendsData,
    );
  }
}
