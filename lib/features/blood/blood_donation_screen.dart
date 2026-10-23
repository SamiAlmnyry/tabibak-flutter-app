import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';

class BloodDonationScreen extends StatefulWidget {
  const BloodDonationScreen({super.key});

  @override
  State<BloodDonationScreen> createState() => _BloodDonationScreenState();
}

class _BloodDonationScreenState extends State<BloodDonationScreen> {
  int _selectedTab = 0; // 0: المستشفيات بصنعاء, 1: المتبرعين المسجلين

  final List<Map<String, dynamic>> _hospitalsInSanaa = [
    {
      'name': 'هيئة مستشفى الثورة العام',
      'location': 'صنعاء - باب اليمن',
      'bloodBankPhone': '01-246800',
      'availableTypes': 'O+ • A+ • B+ • AB-',
      'status': 'بنك الدم الإقليمي مفتوح 24 ساعة',
    },
    {
      'name': 'المستشفى التخصصي الحديث',
      'location': 'صنعاء - شارع الستين الغربي',
      'bloodBankPhone': '01-445566',
      'availableTypes': 'A+ • O- • B-',
      'status': 'يتوفر مركز نقل الدم',
    },
    {
      'name': 'مستشفى جامعة الرازي الطبية',
      'location': 'صنعاء - شارع الرباط',
      'bloodBankPhone': '01-211222',
      'availableTypes': 'جميع الفصائل متوفرة',
      'status': 'قسم الطوارئ والاستقبال',
    },
    {
      'name': 'مستشفى العلوم والتكنولوجيا',
      'location': 'صنعاء - شارع ستين الشمالي',
      'bloodBankPhone': '01-373100',
      'availableTypes': 'B+ • AB+ • O+',
      'status': 'بنك الدم المركزي',
    },
  ];

  final List<Map<String, dynamic>> _donorsList = [
    {'name': 'سامي المنيري', 'bloodType': 'A+', 'phone': '772883045', 'location': 'صنعاء - الرباط'},
    {'name': 'سفير الوصابي', 'bloodType': 'A+', 'phone': '771111111', 'location': 'صنعاء - الصافية'},
    {'name': 'عزام المحبشي', 'bloodType': 'B+', 'phone': '772222222', 'location': 'صنعاء - حدة'},
    {'name': 'شاكر المغاربي', 'bloodType': 'O-', 'phone': '773333333', 'location': 'صنعاء - مذبح'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طوارئ الدم والمستشفيات'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
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
                          'مستشفيات صنعاء',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
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
                          'المتبرعين المسجلين',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
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
          const SizedBox(height: 16),
          Expanded(
            child: _selectedTab == 0
                ? ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _hospitalsInSanaa.length,
              itemBuilder: (context, index) {
                final h = _hospitalsInSanaa[index];
                return FadeInUp(
                  duration: Duration(milliseconds: 400 + (index * 100)),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.textLight.withOpacity(0.12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          h['name'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                        const SizedBox(height: 4),
                        Text(h['location'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.droplet, color: Color(0xFFF43F5E), size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'الفصائل المتاحة: ${h['availableTypes']}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF9F1239)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _donorsList.length,
              itemBuilder: (context, index) {
                final d = _donorsList[index];
                return FadeInUp(
                  duration: Duration(milliseconds: 400 + (index * 100)),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFF43F5E).withOpacity(0.12),
                          child: Text(d['bloodType'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF43F5E))),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              Text(d['location'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.phoneCall, color: AppColors.secondary),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('جاري الاتصال بـ ${d['name']}...')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}