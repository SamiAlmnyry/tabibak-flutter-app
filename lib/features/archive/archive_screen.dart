import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  // قائمة العناصر المؤرشفة (المحذوفة)
  final List<Map<String, String>> _archivedItems = [
    {
      'id': '1',
      'title': 'تذكير دواء بندول إكسترا',
      'date': 'تم الأرشفة: أمس 08:30 م',
    },
    {
      'id': '2',
      'title': 'موعد عيادة الباطنية الملغي',
      'date': 'تم الأرشفة: منذ 3 أيام',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أرشيف العناصر المحذوفة'),
        centerTitle: true,
      ),
      body: _archivedItems.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.archive, size: 60, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'الأرشيف فارغ حالياً',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      )
          : ListView.builder(

        padding: const EdgeInsets.all(16.0),
        itemCount: _archivedItems.length,
        itemBuilder: (context, index) {
          final item = _archivedItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.archive, color: AppColors.primary),
              ),
              title: Text(
                item['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              subtitle: Text(
                item['date']!,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
              trailing: IconButton(
                icon: const Icon(LucideIcons.rotateCcw, color: AppColors.secondary),
                tooltip: 'استعادة',
                onPressed: () {
                  setState(() {
                    _archivedItems.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تمت استعادة "${item['title']}" بنجاح!'),
                      backgroundColor: AppColors.secondary,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}