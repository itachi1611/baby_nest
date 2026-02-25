import 'package:flutter/material.dart';
import 'package:fx_flame/repositories/milk_repository.dart';
import 'package:go_router/go_router.dart';

import '../../models/milk.dart';
import '../../router/routers.dart';
import 'items/milk_item.dart' show MilkItem;

class MilkLogPage extends StatefulWidget {
  const MilkLogPage({super.key});

  @override
  State<MilkLogPage> createState() => _MilkLogPageState();
}

class _MilkLogPageState extends State<MilkLogPage> {
  final MilkRepository _repo = MilkRepository();

  final Map<String, ValueNotifier<bool>> _collapseMap = {};

  ValueNotifier<bool> _getNotifier(String date) {
    return _collapseMap.putIfAbsent(
      date,
      () => ValueNotifier<bool>(false),
    );
  }

  @override
  void dispose() {
    for (final notifier in _collapseMap.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  void _onAddMilk() {
    context.pushNamed(Routers.addMilk.routerName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Milk Log')),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add-milk',
        onPressed: _onAddMilk,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<MilkGroup>>(
        stream: _repo.onFetchMilkLog(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data'));
          }

          final groups = snapshot.data!;

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return MilkItem(
                group: group,
                collapsedNotifier: _getNotifier(group.date),
                onDelete: _repo.deleteMilk,
              );
            },
          );
        },
      ),
    );
  }
}




