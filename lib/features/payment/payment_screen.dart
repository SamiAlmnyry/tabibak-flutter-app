import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';

class PaymentScreen extends StatefulWidget {
  final String? title;
  final String? doctorName;
  final dynamic amount; // القبول لكافة أنواع الأرقام (int, double, num) لمنع الخطأ

  const PaymentScreen({
    super.key,
    this.title,
    this.doctorName,
    this.amount = 15000,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethodIndex = 0;
  final TextEditingController _accountController = TextEditingController();

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'title': 'الكريمي Express (حاسب)',
      'subtitle': 'الدفع السريع عبر حساب الكريمي',
      'icon': LucideIcons.building2,
      'color': const Color(0xFF1E3A8A),
    },
    {
      'title': 'محفظة جيب (Jeeb)',
      'subtitle': 'الدفع المباشر عبر محفظة جيب',
      'icon': LucideIcons.wallet,
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'محفظة جوالي (Jawwali)',
      'subtitle': 'الدفع السريع عبر تطبيق جوالي',
      'icon': LucideIcons.smartphone,
      'color': const Color(0xFF0284C7),
    },
  ];

  // تحويل المبلغ الآمن إلى رقم صحيح أو نص بدون أخطاء
  int get _parsedAmount {
    if (widget.amount is int) return widget.amount as int;
    if (widget.amount is double) return (widget.amount as double).toInt();
    if (widget.amount is String) return int.tryParse(widget.amount as String) ?? 15000;
    return 15000;
  }

  @override
  Widget build(BuildContext context) {
    final selectedMethod = _paymentMethods[_selectedMethodIndex];
    final int finalAmount = _parsedAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('بوابة الدفع الإلكتروني'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. كارت عرض المبلغ المطلوب والعنوان
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF0284C7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    widget.title ??
                        (widget.doctorName != null
                            ? 'حجز موعد مع ${widget.doctorName}'
                            : 'حجز موعد / إجمالي السداد'),
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$finalAmount ر.ي',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'اختر طريقة الدفع اليمنية',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 2. قائمة طرق الدفع
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final item = _paymentMethods[index];
                final bool isSelected = _selectedMethodIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMethodIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.08),
                            blurRadius: 10,
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                          color: isSelected ? AppColors.primary : Colors.grey[400],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                item['subtitle'],
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (item['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(item['icon'], color: item['color'], size: 22),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // 3. حقل إدخال رقم الحساب/المحفظة
            TextField(
              controller: _accountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'أدخل رقم الحساب/ المالي (مثال: 770000000)',
                prefixIcon: const Icon(LucideIcons.smartphone, color: AppColors.primaryLight),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),

            const SizedBox(height: 24),

            // 4. زر الدفع والتسديد
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  final String acc =
                  _accountController.text.trim().isEmpty ? '770000000' : _accountController.text.trim();
                  _showSuccessDialog(context, selectedMethod['title'], acc, finalAmount);
                },
                child: Text(
                  'تسديد ودفع $finalAmount ر.ي',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // نافذة إشعار الحوالة التأكيدية بمنتصف الشاشة
  void _showSuccessDialog(BuildContext context, String method, String account, int total) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // أيقونة النجاح المضيئة والبارزة
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.checkCircle2,
                    color: Color(0xFF10B981),
                    size: 55,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'تم إرسال الحوالة بنجاح! 🎉',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'إشعار إيداع وتأكيد تسديد إلكتروني',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 18),

                // كارت السند
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('طريقة الدفع:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          Text(method, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('رقم الحساب/المحفظة:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          Text(account, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('المبلغ المحول:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          Text('$total ر.ي', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('رقم العملية الترخيصية:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          Text('#YEM-774920', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'تم إرسال إشعار الدفع وتأكيد الحجز بنجاح.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 20),

                // زر الإغلاق والإنهاء
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(dialogContext); // إغلاق النافذة
                      Navigator.pop(context); // إغلاق شاشة الدفع والعودة للمواعيد
                    },
                    child: const Text('موافق، تم الاستلام', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}