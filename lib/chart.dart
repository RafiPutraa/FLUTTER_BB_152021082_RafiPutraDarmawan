import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<Map<String, dynamic>> temperatureData = [];
  List<Map<String, dynamic>> feedingData = [];

  @override
  void initState() {
    super.initState();
    fetchDataTemp();
    fetchDataFeed();
  }

  Future<void> fetchDataTemp() async {
    try {
      final response = await http.get(Uri.parse(
          'https://kelompokd2iot.000webhostapp.com/petfeeder/api/getrataratasuhu.php'));

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedData =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        setState(() {
          temperatureData = fetchedData;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchDataFeed() async {
    try {
      final response = await http.get(Uri.parse(
          'https://kelompokd2iot.000webhostapp.com/petfeeder/api/getlast5days.php'));

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedData =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        setState(() {
          feedingData = fetchedData;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CHART",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF6BA35D),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 30),
            Text(
              'NUMBER OF FEEDINGS',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'LAST 5 DAYS',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 30),
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0xFF6BA35D),
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  minX: 0,
                  maxX: feedingData.length - 1.0,
                  minY: -20,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: false,
                      colors: [Color(0xFF406338)],
                      dotData: FlDotData(show: true),
                      barWidth: 5,
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Color(0xFF406338)]
                            .map((color) => color.withOpacity(0.3))
                            .toList(),
                      ),
                      spots: List.generate(
                        feedingData.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          double.parse(feedingData[index]["jumlah data"]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var data in feedingData)
                  Text(
                    '${data["jumlah data"]}x',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'AVERAGE TEMPERATURE',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'LAST 5 DAYS',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 30),
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0xFF6BA35D),
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  minX: 0,
                  maxX: temperatureData.length - 1.0,
                  minY: 0,
                  maxY: 50,
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: false,
                      colors: [Color(0xFF406338)],
                      dotData: FlDotData(show: true),
                      barWidth: 5,
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Color(0xFF406338)]
                            .map((color) => color.withOpacity(0.3))
                            .toList(),
                      ),
                      spots: List.generate(
                        temperatureData.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          double.parse(
                              temperatureData[index]["rata_rata_suhu"]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var data in temperatureData)
                  Text(
                    '${data["rata_rata_suhu"]} °C',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
