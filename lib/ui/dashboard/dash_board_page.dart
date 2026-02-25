import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:fx_flame/common/app_theme.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../common/app_enums.dart' show DrawerMenu;

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final StreamController<int> _navigationBroadcast = StreamController<int>.broadcast();

  @override
  void dispose() {
    _navigationBroadcast.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _navigationBroadcast.stream,
      initialData: 0,
      builder: (context, snapshot) {
        final index = snapshot.data ?? 0;

        return Scaffold(
          appBar: AppBar(
            title: Text(DrawerMenu.values[index].title),
            backgroundColor: context.onPrimaryColor,
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: DrawerMenu.values[index].target,
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: Colors.grey),
                      ),
                      const Gap(10),
                      Text(
                        'Welcome!',
                        style: context.textTheme.titleLarge?.copyWith(
                          color: context.colors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(5),
                      Text(
                        'itachi1611@gmail.com',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colors.onPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                // Dynamic drawer items với selected state
                ...List.generate(DrawerMenu.values.length, (drawerIndex) {
                  final page = DrawerMenu.values[drawerIndex];
                  final isSelected = drawerIndex == index;
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? context.colors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        left: BorderSide(
                          color: isSelected 
                            ? context.colors.primary 
                            : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        page.icon,
                        color: isSelected 
                          ? context.colors.primary 
                          : Colors.grey[600],
                      ),
                      title: Text(
                        page.title,
                        style: TextStyle(
                          color: isSelected 
                            ? context.colors.primary 
                            : Colors.black87,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      onTap: () async {
                        context.pop();
                        _navigationBroadcast.sink.add(drawerIndex);
                      },
                    ),
                  );
                }),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.logout, color: context.colors.error),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: context.colors.error),
                  ),
                  onTap: () {
                    context.pop();
                    _showLogoutDialog();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                context.pop();
                await Future.delayed(const Duration(seconds: 1));
                exit(0);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
