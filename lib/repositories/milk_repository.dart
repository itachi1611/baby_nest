import 'package:firebase_database/firebase_database.dart';
import 'package:fx_flame/common/app_logger.dart';
import '../models/milk.dart';

abstract class MilkRepositoryImpl {
  /// This class handles CRUD operations for milk entries in the database.
  Stream<List<MilkGroup>> onFetchMilkLog();

  /// Delete an entry by id.
  Future<void> deleteMilk(String id);

  /// Adds a milk entry. If `milk.id` is empty, a push key will be created. Returns the id used for the saved record.
  Future<String> addMilk(Milk milk);

  /// Update an existing milk entry (id must be present).
  Future<void> updateMilk(Milk milk);

  /// Get a milk entry by id. Returns null if not found.
  Future<Milk?> getMilkById(String id);
}

class MilkRepository extends MilkRepositoryImpl {
  final ref = FirebaseDatabase.instance.ref('milk');

  /// Fetches the milk log stream.
  /// The stream emits a list of [MilkGroup] whenever the milk log changes.
  /// Each [MilkGroup] contains a list of [Milk] entries and a date string.
  /// The entries are sorted by timestamp in descending order.
  /// The dates are sorted in descending order.
  @override
  Stream<List<MilkGroup>> onFetchMilkLog() {
    return ref.onValue.map((event) {
      final raw = event.snapshot.value;
      logger.devLog('Firebase event: $raw');

      if (raw == null || raw is! Map) {
        logger.devLog('Milk: empty or invalid data');
        return <MilkGroup>[];
      }

      try {
        final map = Map<String, dynamic>.from(raw);

        final milkList = map.entries.map((entry) {
          return Milk.fromMap(entry.key, Map<String, dynamic>.from(entry.value));
        }).toList();

        /// sort milkList by timestamp DESC (newest first)
        milkList.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        /// group by date
        final Map<String, List<Milk>> grouped = {};
        for (final milk in milkList) {
          grouped.putIfAbsent(milk.date, () => []);
          grouped[milk.date]!.add(milk);
        }

        /// sort date DESC (newest date first)
        final sortDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

        /// group data with MilkGroup
        final result = sortDates.map((date) {
          return MilkGroup(
            date: date,
            items: grouped[date]!,
          );
        }).toList();

        return result;
      } catch (e) {
        logger.devLog('Error parsing milk data: $e');
        return [];
      }
    });
  }


  /// This method updates a milk entry in the database. The `id` of the
  /// [Milk] object must be present. Otherwise, an [ArgumentError] is thrown.
  /// If the update fails, the error is logged and rethrown.
  @override
  Future<void> deleteMilk(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('deleteMilk: id must not be empty');
    }

    try {
      await ref.child(id).remove();
      logger.devLog('deleteMilk succeeded: $id');
    } catch(e, st) {
      logger.devLog('deleteMilk error: $e\n$st');
      rethrow;
    }
  }

  /// Fetches a milk entry by id.
  /// Returns `null` if not found.
  /// Throws [ArgumentError] if `id` is empty.
  /// This method does not throw if the database operation fails.
  /// In such cases, logs the error and rethrows.
  @override
  Future<String> addMilk(Milk milk) async {
    try {
      // If id provided, use it. Otherwise create a push key.
      final String id = (milk.id.isNotEmpty) ? milk.id : (ref.push().key ?? DateTime.now().millisecondsSinceEpoch.toString());

      // Ensure the map includes the same id
      final data = milk.toMap()..['id'] = id;

      await ref.child(id).set(data);
      logger.devLog('addMilk succeeded: $id');
      return id;
    } catch (e, st) {
      logger.devLog('addMilk error: $e\n$st');
      rethrow;
    }
  }


  /// This method updates a milk entry in the database. The `id` of the
  /// [Milk] object must be present. Otherwise, an [ArgumentError] is thrown.
  ///
  /// If the update fails, the error is logged and rethrown.
  // TODO: Add a test for this method
  @override
  Future<void> updateMilk(Milk milk) async {
    if (milk.id.isEmpty) {
      throw ArgumentError('updateMilk: milk.id must not be empty');
    }

    try {
      final data = milk.toMap();
      await ref.child(milk.id).update(data);
      logger.devLog('updateMilk succeeded: ${milk.id}');
    } catch(e, st) {
      logger.devLog('updateMilk error: $e\n$st');
      rethrow;
    }
  }

  /// Fetches a milk entry by id.
  /// Returns `null` if not found.
  /// Throws [ArgumentError] if `id` is empty.
  /// This method does not throw if the database operation fails.
  /// In such cases, logs the error and rethrows.
  @override
  Future<Milk?> getMilkById(String id) async {
    final snapshot = await ref.child(id).get();

    if (!snapshot.exists || snapshot.value == null) {
      return null;
    }

    final map = Map<String, dynamic>.from(snapshot.value as Map);
    return Milk.fromMap(id, map);
  }
}
