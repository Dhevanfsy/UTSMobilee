import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MaterialApp(
    home: StreamingDataPage(),
  ));
}

class Earthquake {
  final String date;
  final String time;
  final String coordinates;
  final String magnitude;
  final String depth;
  final String region;
  final String potential;

  Earthquake({
    required this.date,
    required this.time,
    required this.coordinates,
    required this.magnitude,
    required this.depth,
    required this.region,
    required this.potential,
  });

  factory Earthquake.fromJson(Map<String, dynamic> json) {
    return Earthquake(
      date: json['Tanggal'],
      time: json['Jam'],
      coordinates: json['Coordinates'],
      magnitude: json['Magnitude'],
      depth: json['Kedalaman'],
      region: json['Wilayah'],
      potential: json['Potensi'],
    );
  }
}

class StreamingDataPage extends StatefulWidget {
  @override
  _StreamingDataPageState createState() => _StreamingDataPageState();
}

class _StreamingDataPageState extends State<StreamingDataPage> {
  final StreamController<List<Earthquake>> _earthquakeStreamController =
      StreamController<List<Earthquake>>();

  Stream<List<Earthquake>> get earthquakeStream =>
      _earthquakeStreamController.stream;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _earthquakeStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    final response =
        await http.get(Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/gempaterkini.json'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['Infogempa']['gempa'];
      List<Earthquake> earthquakes =
          jsonData.map((data) => Earthquake.fromJson(data)).toList();

      _earthquakeStreamController.add(earthquakes);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earthquake Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<List<Earthquake>>(
              stream: earthquakeStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Earthquake> earthquakes = snapshot.data!;
                  return Column(
                    children: [
                      // Tambahkan chart di sini
                      LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: const Color(0xff37434d),
                              width: 1,
                            ),
                          ),
                          minX: 0,
                          maxX: earthquakes.length.toDouble() - 1,
                          minY: 0,
                          maxY: 10, // Sesuaikan dengan rentang data Anda
                          lineBarsData: [
                            LineChartBarData(
                              spots: earthquakes.asMap().entries.map((entry) {
                                final index = entry.key;
                                final earthquake = entry.value;
                                return FlSpot(index.toDouble(), double.parse(earthquake.magnitude));
                              }).toList(),
                              isCurved: true,
                              colors: [Colors.blue],
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      // Tampilkan data dalam bentuk daftar
                      Column(
                        children: earthquakes
                            .map((earthquake) => ListTile(
                                  title: Text('Magnitude: ${earthquake.magnitude}'),
                                  subtitle: Text('Region: ${earthquake.region}'),
                                ))
                            .toList(),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
