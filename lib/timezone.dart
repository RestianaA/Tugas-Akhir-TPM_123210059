import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class WorldClockPage extends StatefulWidget {
  @override
  _WorldClockPageState createState() => _WorldClockPageState();
}

class _WorldClockPageState extends State<WorldClockPage> {
  late Timer _timer;
  late DateTime _jakartaTime;
  late DateTime _londonTime;
  late DateTime _tokyoTime;
  late DateTime _seoulTime;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _fetchWorldTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _fetchWorldTime();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _fetchWorldTime() {
    _jakartaTime = tz.TZDateTime.now(tz.getLocation('Asia/Jakarta'));
    _londonTime = tz.TZDateTime.now(tz.getLocation('Europe/London'));
    _tokyoTime = tz.TZDateTime.now(tz.getLocation('Asia/Tokyo'));
    _seoulTime = tz.TZDateTime.now(tz.getLocation('Asia/Seoul'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('World Clock'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClockCard('Jakarta', _jakartaTime),
            _buildClockCard('London', _londonTime),
            _buildClockCard('Tokyo', _tokyoTime),
            _buildClockCard('Seoul', _seoulTime),
          ],
        ),
      ),
    );
  }

  Widget _buildClockCard(String location, DateTime time) {
    String formattedTime = DateFormat.Hm().format(time); // Format waktu tanpa detik
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Membuat sudut kartu lebih lebar
      ),
      child: Container(
        width: double.infinity, // Mengatur lebar kartu menjadi lebar layar
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              formattedTime,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
