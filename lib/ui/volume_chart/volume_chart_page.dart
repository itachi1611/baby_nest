import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fx_flame/common/app_theme.dart';
import 'package:fx_flame/models/milk.dart';
import 'package:fx_flame/repositories/milk_repository.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class VolumeChartPage extends StatefulWidget {
  const VolumeChartPage({super.key});

  @override
  State<VolumeChartPage> createState() => _VolumeChartPageState();
}

class _VolumeChartPageState extends State<VolumeChartPage> {
  final _repo = MilkRepository();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: StreamBuilder<List<MilkGroup>>(
              stream: _repo.onFetchMilkLog(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final allGroups = snapshot.data ?? [];
                final filteredGroups = allGroups.where((group) {
                  final date = DateTime.tryParse(group.date);
                  return date != null &&
                      date.year == _selectedDate.year &&
                      date.month == _selectedDate.month;
                }).toList();

                return _buildChart(filteredGroups);
              },
            ),
          ),
          _buildLegend(),
          const Gap(24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMMM yyyy').format(_selectedDate),
            style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          ElevatedButton.icon(
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_month),
            label: const Text('Select Month'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildChart(List<MilkGroup> groups) {
    final daysInMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    final Map<int, MilkGroup> groupMap = {
      for (var g in groups) DateTime.parse(g.date).day: g
    };

    final List<BarChartGroupData> barGroups = List.generate(daysInMonth, (index) {
      final day = index + 1;
      final group = groupMap[day];
      final motherVolume = group?.motherVolume.toDouble() ?? 0.0;
      final formulaVolume = group?.formulaVolume.toDouble() ?? 0.0;
      final totalVolume = motherVolume + formulaVolume;

      return BarChartGroupData(
        x: day,
        barRods: [
          BarChartRodData(
            toY: totalVolume,
            width: 8,
            borderRadius: BorderRadius.circular(4),
            rodStackItems: [
              BarChartRodStackItem(0, motherVolume, Colors.blue),
              BarChartRodStackItem(motherVolume, totalVolume, Colors.redAccent.withValues(alpha: 0.6)),
            ],
          ),
        ],
      );
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _calculateMaxY(groups),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final day = group.x;
                final g = groupMap[day];
                return BarTooltipItem(
                  'Day $day\n',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'Mother: ${g?.motherVolume ?? 0} ml\n',
                      style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: 'Formula: ${g?.formulaVolume ?? 0} ml\n',
                      style: TextStyle(color: Colors.redAccent.withValues(alpha: 0.8), fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: 'Total: ${(g?.totalVolume ?? 0)} ml',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value % 5 == 0 || value == 1 || value == daysInMonth) {
                    return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 22,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}', style: const TextStyle(fontSize: 10));
                },
                reservedSize: 30,
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          barGroups: barGroups,
        ),
      ),
    );
  }

  double _calculateMaxY(List<MilkGroup> groups) {
    if (groups.isEmpty) return 1000;
    final maxVolume = groups.map((g) => g.totalVolume).reduce((a, b) => a > b ? a : b);
    return (maxVolume / 100).ceil() * 100.0 + 100;
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendItem('Mother', Colors.blue),
          const Gap(20),
          _legendItem('Formula', Colors.redAccent.withValues(alpha: 0.6)),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const Gap(8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
