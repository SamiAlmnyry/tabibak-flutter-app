import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../profile/profile_screen.dart';
import '../appointments/appointments_screen.dart';
import '../pharmacy/pharmacy_screen.dart';
import '../blood/blood_donation_screen.dart';
import '../ai_chat/ai_chat_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userPhone;

  const HomeScreen({
    super.key,
    this.userName = 'سامي  المنيري',
    this.userEmail = 'sami@example.com',
    this.userPhone = '770000000',
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _pulseController;
  int _selectedCategoryIndex = 0;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  File? _userImageFile; // قراءة وعرض ملف الصورة المختارة من الكاميرا/المعرض

  final List<String> _categories = ['الكل 🏥', 'أطباء 👨‍⚕️', 'صيدليات 💊', 'طوارئ 🚨', 'المساعد الذكي 🤖'];

  late final List<Map<String, dynamic>> _allServices;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _initServices();
    _loadUserImage(); // تحميل الصورة الشخصية من الذاكرة
  }

  void _loadUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString('userImagePath');
    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (file.existsSync()) {
        setState(() {
          _userImageFile = file;
        });
      }
    }
  }

  void _initServices() {
    _allServices = [
      {
        'id': 'appointments',
        'categoryIndex': 1,
        'title': 'حجز المواعيد',
        'subtitle': 'استشارة أطباء صنعاء والعيادات',
        'searchKeywords': [
          'حجز', 'موعد', 'طبيب', 'دكتور', 'أطباء', 'عيادة', 'استشارة', 'صنعاء',
          'أحمد الشامي', 'محمد العبسي', 'سامي', 'باطنية', 'أسنان', 'قلب', 'عظام'
        ],
        'icon': LucideIcons.calendar,
        'gradientColors': [const Color(0xFF0284C7), const Color(0xFF0369A1)],
        'onTap': (BuildContext context) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AppointmentsScreen()));
        },
      },
      {
        'id': 'pharmacy',
        'categoryIndex': 2,
        'title': 'دليل الصيدليات',
        'subtitle': 'طلب وتوصيل الأدوية والمستلزمات',
        'searchKeywords': [
          'صيدلية', 'صيدليات', 'دواء', 'أدوية', 'علاج', 'علاجات', 'توصيل', 'دليل',
          'النهدي', 'الرحمة', 'بن سينا', 'بندول', 'فيتامين', 'مضاد'
        ],
        'icon': LucideIcons.pill,
        'gradientColors': [const Color(0xFF10B981), const Color(0xFF047857)],
        'onTap': (BuildContext context) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const PharmacyScreen()));
        },
      },
      {
        'id': 'blood',
        'categoryIndex': 3,
        'title': 'التبرع بالدم',
        'subtitle': 'بنك الدم الإقليمي وطلبات الطوارئ',
        'searchKeywords': [
          'دم', 'تبرع', 'بنك', 'طوارئ', 'فصيلة', 'عاجل', 'إسعاف', 'o+', 'a+', 'b+'
        ],
        'icon': LucideIcons.droplet,
        'gradientColors': [const Color(0xFFEF4444), const Color(0xFFB91C1C)],
        'onTap': (BuildContext context) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const BloodDonationScreen()));
        },
      },
      {
        'id': 'ai_chat',
        'categoryIndex': 4,
        'title': 'مساعد طبي الذكي',
        'subtitle': 'تشخيص الأعراض واستشارات AI',
        'searchKeywords': [
          'ذكاء', 'اصطناعي', 'مساعد', 'شات', 'تشخيص', 'أعراض', 'روبوت', 'ai', 'chat', 'صداع', 'حرارة'
        ],
        'icon': LucideIcons.bot,
        'gradientColors': [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)],
        'onTap': (BuildContext context) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AiChatScreen()));
        },
      },
    ];
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> pages = [
      _buildUltraModernHomeBody(context, isDark),
      const AppointmentsScreen(),
      const PharmacyScreen(),
      const AiChatScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B).withOpacity(0.92) : Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF0284C7),
            unselectedItemColor: isDark ? Colors.grey[500] : Colors.grey[400],
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.layoutGrid),
                activeIcon: Icon(LucideIcons.layoutGrid, size: 26),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.calendar),
                activeIcon: Icon(LucideIcons.calendarCheck, size: 26),
                label: 'المواعيد',
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.pill),
                activeIcon: Icon(LucideIcons.pill, size: 26),
                label: 'الصيدليات',
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.bot),
                activeIcon: Icon(LucideIcons.bot, size: 26, color: Color(0xFF8B5CF6)),
                label: 'ذكاء طبي AI',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUltraModernHomeBody(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. الهيدر العلوي
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          userName: widget.userName,
                          userEmail: widget.userEmail,
                          userPhone: widget.userPhone,
                        ),
                      ),
                    );
                    _loadUserImage(); // تحديث الصورة عند العودة
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF0284C7), Color(0xFF10B981)],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFF0F172A),
                          backgroundImage: _userImageFile != null ? FileImage(_userImageFile!) : null,
                          child: _userImageFile == null
                              ? const Icon(LucideIcons.user, color: Colors.white, size: 22)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'أهلاً بك',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text('👋', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          Text(
                            widget.userName,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEF4444).withOpacity(0.3 * _pulseController.value),
                                blurRadius: 12 * _pulseController.value,
                                spreadRadius: 3 * _pulseController.value,
                              ),
                            ],
                          ),
                          child: child,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                        ),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            IconButton(
                              icon: Icon(LucideIcons.bell, size: 20, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                                );
                              },
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                      ),
                      child: IconButton(
                        icon: Icon(LucideIcons.settings, size: 20, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. شريط البحث الشامل والعميق
          FadeInDown(
            duration: const Duration(milliseconds: 700),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: _searchQuery.isNotEmpty
                      ? const Color(0xFF0284C7)
                      : (isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
                  width: _searchQuery.isNotEmpty ? 1.5 : 1.0,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim().toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'ابحث عن طبيب، صيدلية، دواء، أو أعراض...',
                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  border: InputBorder.none,
                  icon: const Icon(LucideIcons.search, color: Color(0xFF0284C7), size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(LucideIcons.x, size: 18, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                      : Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(LucideIcons.slidersHorizontal, color: Color(0xFF0284C7), size: 16),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // 3. أزرار الفئات السريعة
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final bool isSelected = _selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedCategoryIndex = index);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0284C7)
                          : (isDark ? const Color(0xFF1E293B) : Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : (isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Text(
                      _categories[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : (isDark ? Colors.grey[300] : const Color(0xFF64748B)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // 4. البطاقة الطبية الرقمية الموحدة
          if (_searchQuery.isEmpty)
            FadeInUp(
              duration: const Duration(milliseconds: 750),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF0284C7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E3A8A).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(LucideIcons.shieldCheck, color: Color(0xFF10B981), size: 16),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'البطاقة الطبية الرقمية الموحدة',
                              style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Row(
                            children: [
                              Icon(LucideIcons.droplet, color: Colors.cyanAccent, size: 12),
                              SizedBox(width: 4),
                              Text(
                                'فصيلة الدم: O+',
                                style: TextStyle(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(LucideIcons.qrCode, color: Colors.white, size: 26),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('رمز الملف الطبي (QR)', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                  Text('YEM-884920-SANAA', style: TextStyle(color: Colors.white60, fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF0F172A),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            onPressed: () => _showQrDialog(context),
                            child: const Text('عرض الكود', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 5. قسم الخدمات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _searchQuery.isNotEmpty ? 'نتائج البحث عن "$_searchQuery"' : 'الخدمات المتاحة',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'الفئة: ${_categories[_selectedCategoryIndex]}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF0284C7), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _buildDynamicSearchResults(context, isDark),
        ],
      ),
    );
  }

  Widget _buildDynamicSearchResults(BuildContext context, bool isDark) {
    final filteredList = _allServices.where((service) {
      final bool matchesCategory = _selectedCategoryIndex == 0 || service['categoryIndex'] == _selectedCategoryIndex;

      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final List<String> keywords = List<String>.from(service['searchKeywords']);
        final String title = service['title'].toString().toLowerCase();
        final String subtitle = service['subtitle'].toString().toLowerCase();

        matchesSearch = title.contains(_searchQuery) ||
            subtitle.contains(_searchQuery) ||
            keywords.any((kw) => kw.toLowerCase().contains(_searchQuery));
      }

      return matchesCategory && matchesSearch;
    }).toList();

    if (filteredList.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            const Icon(LucideIcons.searchX, size: 50, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              'عفواً، لم نجد نتائج مطابقة لـ "$_searchQuery"',
              style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'جرب البحث بـ: (أحمد الشامي، صيدلية، بندول، موعد، دم)',
              style: TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final service = filteredList[index];
        return _buildModernServiceCard(
          context,
          title: service['title'],
          subtitle: service['subtitle'],
          icon: service['icon'],
          gradientColors: service['gradientColors'],
          onTap: () => service['onTap'](context),
          isDark: isDark,
        );
      },
    );
  }

  Widget _buildModernServiceCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required List<Color> gradientColors,
        required VoidCallback onTap,
        required bool isDark,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: isDark ? Colors.grey[400] : const Color(0xFF64748B)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showQrDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('رمز الملف الطبي الموحد (QR)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(LucideIcons.qrCode, size: 170, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 14),
                Text('المعرف: YEM-884920 - ${widget.userName}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إغلاق'),
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