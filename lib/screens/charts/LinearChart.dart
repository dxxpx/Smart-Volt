import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DamagePredictionCharts extends StatelessWidget {
  bool isMachineDamaged = false;

  final List<double> voltageData = [
    220,
    225,
    223,
    220,
    219,
    221,
    224,
    222,
    220,
    218
  ];
  final List<double> currentData = [
    10,
    10.5,
    11,
    10.3,
    10.7,
    10.2,
    10.8,
    10.9,
    10.6,
    10.1
  ];
  final List<double> temperatureData = [30, 32, 31, 33, 34, 35, 33, 32, 31, 30];
  final List<double> humidityData = [60, 62, 65, 64, 63, 61, 62, 64, 65, 63];
  final List<double> vibrationData = [
    0.2,
    0.25,
    0.3,
    0.27,
    0.26,
    0.3,
    0.33,
    0.28,
    0.25,
    0.24
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Damage Prediction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  buildChartCard(context, 'Voltage', voltageData),
                  buildChartCard(context, 'Current', currentData),
                  buildChartCard(context, 'Temperature', temperatureData),
                  buildChartCard(context, 'Humidity', humidityData),
                  buildChartCard(context, 'Vibration', vibrationData),
                ],
              ),
            ),
            SizedBox(height: 16),
            buildPredictionResult(),
          ],
        ),
      ),
    );
  }

  Widget buildPredictionResult() {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isMachineDamaged
            ? Colors.red[300]
            : Colors.green[300], // Dynamic color
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Center(
        child: Text(
          isMachineDamaged ? 'Machine is Damaged' : 'Machine is Not Damaged',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildChartCard(BuildContext context, String title, List<double> data) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2) - 15, // Two charts per row
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 140,
            child: LineChartWidget(data: data),
          ),
        ],
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<double> data;

  LineChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(
            show: true, border: Border.all(color: Colors.black, width: 0.3)),
        minX: 0,
        maxX: 9,
        minY: data.reduce((a, b) => a < b ? a : b) - 5,
        maxY: data.reduce((a, b) => a > b ? a : b) + 5,
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData:
                BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }
}
