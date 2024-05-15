// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<_ChartData> chartData = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchData();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => fetchData());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    // Fetch data from the server
    final response = await http.get(
      Uri.parse('${baseURLAPI}status.php'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final DateTime time = DateTime.parse(data['timestamp']);
      final int temperature = data['data']['temperature'];
      setState(() {
        chartData.add(_ChartData(time, temperature));
        if (chartData.length > 20) {
          chartData.removeAt(0);
        }
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCartesianChart(
        primaryXAxis: DateTimeAxis(),
        primaryYAxis: NumericAxis(),
        series: <ChartSeries>[
          AreaSeries<_ChartData, DateTime>(
            dataSource: chartData, 
            xValueMapper: (_ChartData data, _) => data.time, 
            yValueMapper: (_ChartData data, _) => data.value,
            color: Colors.teal.withOpacity(0.5),
            borderColor: Colors.teal,
            borderWidth: 3,
            onRendererCreated: (ChartSeriesController controller){},
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.time, this.value);
  final DateTime time;
  final int value;
}
