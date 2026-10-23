import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../payment/payment_screen.dart';
import '../payment/payment_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  int _selectedTab = 0; // 0: الأطباء والمواعيد, 1: مواعيدي الحالية

  // قائمة تحتوي على 10 أطباء في تخصصات مختلفة
  final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'د. أحمد السقاف',
      'specialty': 'استشاري أمراض القلب',
      'rating': '4.9',
      'experience': '12 سنة خبرة',
      'hospital': 'مستشفى الأمل التخصصي',
      'time': '04:00 مساءً - اليوم',
      'price': 15000.0,
      'icon': LucideIcons.stethoscope,
      'color': const Color(0xFF3B82F6),
    },
    {
      'name': 'د. عليا الكبسي',
      'specialty': 'أخصائية طب الأطفال',
      'rating': '4.8',
      'experience': '8 سنوات خبرة',
      'hospital': 'مركز الحياة الطبي',
      'time': '06:30 مساءً - غداً',
      'price': 12000.0,
      'icon': LucideIcons.user,
      'color': const Color(0xFF10B981),
    },
    {
      'name': 'د. محمد العريقي',
      'specialty': 'أخصائي العظام والعمود الفقري',
      'rating': '4.7',
      'experience': '10 سنوات خبرة',
      'hospital': 'المركز الطبي الحديث',
      'time': '10:00 صباحاً - الخميس',
      'price': 14000.0,
      'icon': LucideIcons.activity,
      'color': const Color(0xFF06B6D4),
    },
    {
      'name': 'د. ريم الخولاني',
      'specialty': 'استشارية الأمراض الجلدية وتجميل',
      'rating': '4.9',
      'experience': '9 سنوات خبرة',
      'hospital': 'مجمع العافية الجلدي',
      'time': '02:00 ظهراً - غداً',
      'price': 18000.0,
      'icon': LucideIcons.sparkles,
      'color': const Color(0xFFEC4899),
    },
    {
      'name': 'د. خالد باوزير',
      'specialty': 'أخصائي الباطنية والجهاز الهضمي',
      'rating': '4.6',
      'experience': '15 سنة خبرة',
      'hospital': 'مستشفى الشفاء العام',
      'time': '05:00 مساءً - الأحد',
      'price': 13000.0,
      'icon': LucideIcons.heartPulse,
      'color': const Color(0xFF8B5CF6),
    },
    {
      'name': 'د. أمين الذبحاني',
      'specialty': 'جراحة العيون واليزك',
      'rating': '4.9',
      'experience': '14 سنة خبرة',
      'hospital': 'مركز الرؤية التخصصي',
      'time': '09:00 صباحاً - السبت',
      'price': 16000.0,
      'icon': LucideIcons.eye,
      'color': const Color(0xFFF59E0B),
    },
    {
      'name': 'د. نادية المؤيد',
      'specialty': 'أخصائية طب وجراحة الأسنان',
      'rating': '4.8',
      'experience': '7 سنوات خبرة',
      'hospital': 'عيادات ابتسامة اللؤلؤ',
      'time': '03:30 مساءً - الغد',
      'price': 10000.0,
      'icon': LucideIcons.smile,
      'color': const Color(0xFF14B8A6),
    },
    {
      'name': 'د. ياسر الشامي',
      'specialty': 'استشاري المخ والأعصاب',
      'rating': '4.9',
      'experience': '18 سنة خبرة',
      'hospital': 'المستشفى التخصصي الحديث',
      'time': '11:00 صباحاً - الاثنين',
      'price': 20000.0,
      'icon': LucideIcons.brain,
      'color': const Color(0xFF6366F1),
    },
    {
      'name': 'د. خديجة صنعاني',
      'specialty': 'أخصائية النساء والتوليد',
      'rating': '4.7',
      'experience': '11 سنة خبرة',
      'hospital': 'مركز الأمومة والطفولة',
      'time': '01:00 ظهراً - الأربعاء',
      'price': 12000.0,
      'icon': LucideIcons.heart,
      'color': const Color(0xFFF43F5E),
    },
    {
      'name': 'د. طارق أنعم',
      'specialty': 'أخصائي الأنف والأذن والحنجرة',
      'rating': '4.6',
      'experience': '6 سنوات خبرة',
      'hospital': 'مستشفى السلام الطبي',
      'time': '07:00 مساءً - الخميس',
      'price': 11000.0,
      'icon': LucideIcons.headphones,
      'color': const Color(0xFF0284C7),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('حجز والمواعيد الطبية'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          // 1. أزرار التنقل بين الأطباء والمواعيد المحجوزة
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: _selectedTab == 0 ? AppColors.primaryGradient : null,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'حجز موعد جديد',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _selectedTab == 0 ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: _selectedTab == 1 ? AppColors.primaryGradient : null,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'مواعيدي القادمة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _selectedTab == 1 ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 2. قائمة الأطباء العشرة أو المواعيد المحجوزة
          Expanded(
            child: _selectedTab == 0
                ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _doctors.length,
              itemBuilder: (context, index) {
                final doc = _doctors[index];
                return FadeInUp(
                  duration: Duration(milliseconds: 400 + (index * 50)),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: (doc['color'] as Color).withOpacity(0.12),
                              child: Icon(doc['icon'], color: doc['color'], size: 28),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    doc['specialty'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${doc['hospital']} • ${doc['experience']}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                    const SizedBox(width: 2),
                                    Text(
                                      doc['rating'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${(doc['price'] as double).toInt()} ر.ي',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Divider(height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(LucideIcons.clock, size: 16, color: AppColors.primaryLight),
                                const SizedBox(width: 6),
                                Text(
                                  doc['time'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                // الانتقال المباشر لشاشة الدفع بالدفع الإلكتروني
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                      title: 'حجز موعد مع ${doc['name']}',
                                      amount: doc['price'],
                                    ),
                                  ),
                                );
                              },
                              child: const Text('حجز ودفع', style: TextStyle(fontSize: 13)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                : Center(
              child: FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.calendarCheck, size: 70, color: AppColors.primaryLight.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    const Text(
                      'لديك موعد قادم واحد مع د. أحمد السقاف',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'اليوم الساعة 04:00 مساءً - مستشفى الأمل',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}