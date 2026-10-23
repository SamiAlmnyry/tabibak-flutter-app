import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'تذكير بموعد دواء',
      'body': 'يرجى تناول جرعة بندول إكسترا الساعة 8:00 مساءً',
      'time': 'قبل 10 دقائق',
      'type': 'medicine',
      'isRead': false,
    },
    {
      'id': '2',
      'title': 'تأكيد حجز موعد',
      'body': 'تم تأكيد حجزك مع د. أحمد الشامي في مستشفى جامعة الرازي',
      'time': 'قبل ساعة',
      'type': 'appointment',
      'isRead': true,
    },
    {
      'id': '3',
      'title': 'نداء طوارئ دم عاجل',
      'body': 'مطلوب متبرع بفصيلة الدم O+ بشكل عاجل في مستشفى الثورة',
      'time': 'قبل 3 ساعات',
      'type': 'emergency',
      'isRead': false,
    },
  ];

  void _addNotification(String title, String body, String type) {
    setState(() {
      _notifications.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title,
        'body': body,
        'time': 'الآن',
        'type': type,
        'isRead': false,
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تمت إضافة التنبيه بنجاح!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _editNotification(int index, String title, String body, String type) {
    setState(() {
      _notifications[index]['title'] = title;
      _notifications[index]['body'] = body;
      _notifications[index]['type'] = type;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تعديل التنبيه بنجاح!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _deleteNotification(int index) {
    final deletedItem = _notifications[index];
    setState(() {
      _notifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حذف تنبيه "${deletedItem['title']}"'),
        action: SnackBarAction(
          label: 'تراجع',
          textColor: Colors.amber,
          onPressed: () {
            setState(() {
              _notifications.insert(index, deletedItem);
            });
          },
        ),
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var item in _notifications) {
        item['isRead'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات والتنبيهات'),
        centerTitle: true,
        actions: [
          if (_notifications.any((element) => !element['isRead']))
            IconButton(
              icon: const Icon(LucideIcons.checkCheck, color: AppColors.primary),
              tooltip: 'تحديد الكل كمقروء',
              onPressed: _markAllAsRead,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => _showAddOrEditDialog(context),
        icon: const Icon(LucideIcons.bellPlus, size: 20),
        label: const Text('إضافة تنبيه', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _notifications.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.bellOff, size: 60, color: Colors.grey),
            SizedBox(height: 12),
            Text('لا توجد إشعارات أو تنبيهات حالية', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final item = _notifications[index];
          final bool isRead = item['isRead'];

          return Dismissible(
            key: Key(item['id']),
            direction: DismissDirection.startToEnd,
            background: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.trash2, color: Colors.white),
                  SizedBox(width: 8),
                  Text('حذف', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            onDismissed: (direction) => _deleteNotification(index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white, // خلفية بيضاء واضحة دائماً
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isRead ? const Color(0xFFE2E8F0) : AppColors.primary,
                  width: isRead ? 1 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: _buildTypeIcon(item['type']),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isRead ? Colors.black87 : AppColors.primary,
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      item['body'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF334155), // لون نص أسود داكن واضح للقراءة
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['time'],
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  icon: const Icon(LucideIcons.moreVertical, size: 20, color: Colors.black54),
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showAddOrEditDialog(context, index: index, existingData: item);
                    } else if (value == 'delete') {
                      _deleteNotification(index);
                    } else if (value == 'toggleRead') {
                      setState(() {
                        item['isRead'] = !item['isRead'];
                      });
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'toggleRead',
                      child: Row(
                        children: [
                          Icon(isRead ? LucideIcons.mail : LucideIcons.mailOpen, size: 18),
                          const SizedBox(width: 8),
                          Text(isRead ? 'تحديد كغير مقروء' : 'تحديد كمقروء'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(LucideIcons.edit2, size: 18, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('تعديل'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(LucideIcons.trash2, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('حذف', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeIcon(String type) {
    IconData iconData;
    Color color;

    switch (type) {
      case 'medicine':
        iconData = LucideIcons.pill;
        color = const Color(0xFF10B981);
        break;
      case 'appointment':
        iconData = LucideIcons.calendar;
        color = const Color(0xFF0284C7);
        break;
      case 'emergency':
        iconData = LucideIcons.siren;
        color = const Color(0xFFEF4444);
        break;
      default:
        iconData = LucideIcons.bell;
        color = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 22),
    );
  }

  void _showAddOrEditDialog(BuildContext context, {int? index, Map<String, dynamic>? existingData}) {
    final isEditing = index != null;
    final titleController = TextEditingController(text: isEditing ? existingData!['title'] : '');
    final bodyController = TextEditingController(text: isEditing ? existingData!['body'] : '');
    String selectedType = isEditing ? existingData!['type'] : 'medicine';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                isEditing ? 'تعديل التنبيه' : 'إضافة تنبيه جديد',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'عنوان التنبيه',
                        hintText: 'مثال: موعد دواء الضغط',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: bodyController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'تفاصيل التنبيه',
                        hintText: 'أدخل تفاصيل ووقت التنبيه...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: 'نوع التنبيه',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'medicine', child: Text('تذكير دواء 💊')),
                        DropdownMenuItem(value: 'appointment', child: Text('حجز موعد 📅')),
                        DropdownMenuItem(value: 'emergency', child: Text('تنبيه طوارئ 🚨')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedType = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    final title = titleController.text.trim();
                    final body = bodyController.text.trim();

                    if (title.isNotEmpty && body.isNotEmpty) {
                      Navigator.pop(context);
                      if (isEditing) {
                        _editNotification(index, title, body, selectedType);
                      } else {
                        _addNotification(title, body, selectedType);
                      }
                    }
                  },
                  child: Text(isEditing ? 'حفظ التعديل' : 'إضافة التنبيه'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}