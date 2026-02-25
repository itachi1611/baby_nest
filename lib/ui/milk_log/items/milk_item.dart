import 'package:flutter/material.dart';
import 'package:fx_flame/models/milk.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../../common/app_logger.dart';
import '../../../common/app_theme.dart';
import '../../../extensions/widget_extension.dart';
import '../../../router/routers.dart';

class MilkItem extends StatelessWidget {
  final MilkGroup group;
  final ValueNotifier<bool> collapsedNotifier;
  final Future<void> Function(String id) onDelete;

  const MilkItem({
    super.key,
    required this.group,
    required this.collapsedNotifier,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: GestureDetector(
        onTap: () => collapsedNotifier.value = !collapsedNotifier.value,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.centerLeft,
          color: context.colors.primary,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.date,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: context.textTheme.headlineSmall?.color,
                    ),
                  ),
                  /// Total format:
                  /// 650 ml (450 breast / 200 formula)
                  Text(
                    "${group.totalVolume} ml (🤱${group.motherVolume} mother / 🍼${group.formulaVolume} formula)",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ).expand,
              const Gap(8),
              ValueListenableBuilder(
                  valueListenable: collapsedNotifier,
                  child: const Icon(Icons.expand_more),
                  builder: (context, isCollapsed, child) {
                    return AnimatedRotation(
                      turns: isCollapsed ? 0.5 :0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: child,
                    );
                  }
              ),
            ],
          ),
        ),
      ),
      content: ValueListenableBuilder(
          valueListenable: collapsedNotifier,
          child: Column(
            children: group.items.map((item) => Dismissible(
              key: ValueKey(item.id),
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(right: 16),
                color: Colors.green,
                child: const Icon(Icons.update, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                if(direction == DismissDirection.endToStart) {
                  logger.i('From Right to Left');
                  final result = await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete?'),
                      content: const Text('Remove this milk log?'),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  return result ?? false;
                }

                if(direction == DismissDirection.startToEnd) {
                  logger.i('From Left to Right');
                  context.pushNamed(Routers.updateMilk.routerName,pathParameters: {'id': item.id});
                }
                return false;
              },
              onDismissed: (_) => onDelete(item.id),
              child: ListTile(
                title: Text(item.time),
                subtitle: Text(item.type),
                trailing: Text('${item.volume} ml'),
              ),
            )).toList(),
          ),
          builder: (context, isCollapsed, child) {
            return AnimatedOpacity(
              opacity: isCollapsed ? 0 : 1,
              duration: const Duration(milliseconds: 250),
              child: ClipRect(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: ConstrainedBox(
                      constraints: isCollapsed
                          ? const BoxConstraints(maxHeight: 0)
                          : const BoxConstraints(),
                      child: child
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
