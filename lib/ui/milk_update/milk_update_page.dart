import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fx_flame/common/app_enums.dart';
import 'package:fx_flame/extensions/context_extension.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../common/app_validator.dart';
import '../../extensions/datetime_extension.dart' show PickerExtension;
import '../../extensions/string_extension.dart';
import '../../models/milk.dart';
import '../../repositories/milk_repository.dart';
import '../../common/app_theme.dart';

class MilkUpdatePage extends StatefulWidget {
  final String id;

  const MilkUpdatePage({super.key, required this.id});

  @override
  State<MilkUpdatePage> createState() => _MilkUpdatePageState();
}

class _MilkUpdatePageState extends State<MilkUpdatePage> {
  // Repository
  final _repo = MilkRepository();

  // Form related
  final _formKey = GlobalKey<FormState>();

  // Notifier
  late final ValueNotifier<DateTime> _dateNotifier;
  late final ValueNotifier<String> _typeNotifier;
  final _loadingNotifier = ValueNotifier(true);

  // Controller
  final _volumeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMilk();
  }

  @override
  void dispose() {
    _volumeController.dispose();
    _dateNotifier.dispose();
    _typeNotifier.dispose();
    _loadingNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadMilk() async {
    final milk = await _repo.getMilkById(widget.id);

    if (milk == null) {
      if (mounted) context.pop();
      return;
    }

    _volumeController.text = milk.volume.toString();
    _dateNotifier = ValueNotifier(DateTime.fromMillisecondsSinceEpoch(milk.timestamp));
    _typeNotifier = ValueNotifier(milk.type.lower);
    _loadingNotifier.value = false;
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await context.onPickDateTime(_dateNotifier.value);
    if (pickedDate == null) return;

    _dateNotifier.value = pickedDate;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final dt = _dateNotifier.value;

      final updated = Milk(
        id: widget.id,
        date: "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}",
        time: "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}",
        type: _typeNotifier.value,
        volume: int.tryParse(_volumeController.text.trim())!,
        timestamp: dt.millisecondsSinceEpoch,
      );

      await _repo.updateMilk(updated);

      if (mounted) context.pop();
    } else {
      return context.showSnackBar(
        message: 'Please fill all fields',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Milk")),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSubmit,
        child: const Icon(Icons.update),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _loadingNotifier,
        builder: (_, isLoading, __) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  /// DATE
                  ValueListenableBuilder<DateTime>(
                    valueListenable: _dateNotifier,
                    builder: (_, dt, __) {
                      return FormField<DateTime>(
                        initialValue: dt,
                        validator: dateValidator,
                        builder: (formFieldState) {
                          return Card(
                            color: context.colors.surfaceContainerHigh,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                            child: ListTile(
                              leading: Icon(
                                Icons.schedule,
                                color: context.colors.primary,
                              ),
                              title: Text(
                                "Date & Time",
                                style: context.textTheme.titleMedium,
                              ),
                              subtitle: Text(
                                "${dt.day}/${dt.month}/${dt.year} "
                                    "${dt.hour.toString().padLeft(2, '0')}:"
                                    "${dt.minute.toString().padLeft(2, '0')}",
                                style: context.textTheme.bodyMedium,
                              ),
                              onTap: () async {
                                _pickDateTime();
                                formFieldState.didChange(_dateNotifier.value);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),

                  const Gap(24),

                  Text("Milk Type", style: context.textTheme.titleMedium),
                  const Gap(8),

                  ValueListenableBuilder<String>(
                    valueListenable: _typeNotifier,
                    builder: (_, selected, __) {
                      return RadioGroup<String>(
                        groupValue: selected,
                        onChanged: (value) {
                          if (value != null) {
                            _typeNotifier.value = value;
                          }
                        },
                        child: Column(
                          children: const [
                            RadioListTile(
                              title: Text("Mother"),
                              value: "mother",
                            ),
                            RadioListTile(
                              title: Text("Formula"),
                              value: "formula",
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const Gap(24),

                  TextFormField(
                    controller: _volumeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: volumeValidator,
                    decoration: InputDecoration(
                      labelText: "Volume (ml)",
                      filled: true,
                      fillColor: context.colors.surfaceContainerHigh,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
