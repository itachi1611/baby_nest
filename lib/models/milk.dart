import 'package:fx_flame/extensions/string_extension.dart';

class MilkGroup {
  final String date;
  final List<Milk> items;

  final int totalVolume;
  final int motherVolume;
  final int formulaVolume;

  MilkGroup({
    required this.date,
    required this.items,
  }) : totalVolume = items.fold<int>(0, (sum, e) => sum + e.volume),
        motherVolume = items.where((e) => e.type.lower == 'mother').fold<int>(0, (sum, e) => sum + e.volume),
        formulaVolume = items.where((e) => e.type.lower == 'formula').fold<int>(0, (sum, e) => sum + e.volume);
}

class Milk {
  final String id;
  final String date;
  final String time;
  final String type;
  final int volume;
  final int timestamp;

  Milk({
    required this.id,
    required this.date,
    required this.time,
    required this.type,
    required this.volume,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'type': type,
      'volume': volume,
      'timestamp': timestamp,
    };
  }

  factory Milk.fromMap(String id, Map<String, dynamic> map) {
    return Milk(
      id: id,
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      type: map['type'] ?? '',
      volume: (map['volume'] ?? 0) as int,
      timestamp: (map['timestamp'] ?? 0) as int,
    );
  }
}