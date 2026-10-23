import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';

class MedicinesScreen extends StatefulWidget {
  const MedicinesScreen({super.key});

  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {
  final List<Map<String, dynamic>> _medicines = [
    {
      'id': 1,
      'name': 'بنادول إكسترا',
      'dosage': '500 ملجم - حبة واحدة',
      'time': '08:00 صباحاً',
      'taken': true,
      'icon': LucideIcons.pill,
      'color': const Color(0xFF3B82F6),
    },
    {
      'id': 2,
      'name': 'أوميجابراس',
      'dosage': '20 ملجم - قبل الأكل',
      'time': '01:30 ظهراً',
      'taken': false,
      'icon': LucideIcons.stethoscope,
      'color': const Color(0xFF10B981),
    },
  ];

  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _timeController = TextEditingController();

  void _showAddMedicineDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'إضافة دواء / جرعة جديدة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'اسم الدواء (مثال: فيتامين سي)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _dosageController,
                decoration: const InputDecoration(hintText: 'الجرعة (مثال: حبة واحدة)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(hintText: 'الوقت (مثال: 09:00 مساءً)'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isEmpty) return;
                    setState(() {
                      _medicines.add({
                        'id': DateTime.now().millisecondsSinceEpoch,
                        'name': _nameController.text.trim(),
                        'dosage': _dosageController.text.trim().isEmpty ? 'جرعة واحدة' : _dosageController.text.trim(),
                        'time': _timeController.text.trim().isEmpty ? '08:00 مساءً' : _timeController.text.trim(),
                        'taken': false,
                        'icon': LucideIcons.pill,
                        'color': const Color(0xFF06B6D4),
                      });
                    });
                    _nameController.clear();
                    _dosageController.clear();
                    _timeController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('إضافة الدواء'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مواعيد الأدوية'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plusCircle, color: AppColors.primary),
            onPressed: _showAddMedicineDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _medicines.length,
              itemBuilder: (context, index) {
                final med = _medicines[index];
                final bool isTaken = med['taken'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isTaken ? AppColors.secondary.withOpacity(0.4) : AppColors.textLight.withOpacity(0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (med['color'] as Color).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(med['icon'], color: med['color'], size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              med['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: isTaken ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            Text(
                              '${med['dosage']} • ${med['time']}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isTaken ? LucideIcons.checkCircle2 : LucideIcons.circle,
                          color: isTaken ? AppColors.secondary : AppColors.textLight,
                        ),
                        onPressed: () {
                          setState(() {
                            _medicines[index]['taken'] = !isTaken;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}