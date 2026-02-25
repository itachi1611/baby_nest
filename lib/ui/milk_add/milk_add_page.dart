import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fx_flame/extensions/context_extension.dart';
import 'package:fx_flame/extensions/string_extension.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../common/app_enums.dart';
import '../../common/app_validator.dart' show volumeValidator, dateValidator;
import '../../extensions/datetime_extension.dart';
import '../../models/milk.dart';
import '../../repositories/milk_repository.dart';
import '../../common/app_theme.dart';

class MilkAddPage extends StatefulWidget {
  const MilkAddPage({super.key});

  @override
  State<MilkAddPage> createState() => _MilkAddPageState();
}

class _MilkAddPageState extends State<MilkAddPage> {
  // Repository
  final _repo = MilkRepository();

  // Form related
  final _formKey = GlobalKey<FormState>();

  // Notifier
  final _dateNotifier = ValueNotifier(DateTime.now());
  final _typeNotifier = ValueNotifier('mother');

  // Controller
  final _volumeController = TextEditingController();

  @override
  void dispose() {
    _dateNotifier.dispose();
    _typeNotifier.dispose();
    _volumeController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await context.onPickDateTime(_dateNotifier.value);
    if (pickedDate == null) return;

    _dateNotifier.value = pickedDate;
  }

  Future<void> _onSubmit() async {
    if(_formKey.currentState!.validate()) {
      final dt = _dateNotifier.value;

      final milk = Milk(
        id: '',
        date: dt.formatDate,
        time: dt.formatTime,
        type: _typeNotifier.value,
        volume: int.tryParse(_volumeController.text.trim())!,
        timestamp: dt.millisecondsSinceEpoch,
      );

      await _repo.addMilk(milk);

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
      appBar: AppBar(title: const Text('Add Milk')),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addMilk',
        onPressed: _onSubmit,
        child: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                          leading: Icon(Icons.schedule,
                              color: context.colors.primary),
                          title: Text(
                            "Date & Time",
                            style: context.textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            "${dt.formatDate} ${dt.formatTime}",
                            style: context.textTheme.bodyMedium,
                          ),
                          onTap: () async {
                            await _pickDateTime();
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
                      children: [
                        RadioListTile(
                          title: Text(MilkType.mother.title),
                          value: MilkType.mother.title.lower,
                        ),
                        RadioListTile(
                          title: Text(MilkType.formula.title),
                          value: MilkType.formula.title.lower,
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
      ),
    );
  }
}
