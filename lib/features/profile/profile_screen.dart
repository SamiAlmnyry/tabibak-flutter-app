import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userPhone;

  const ProfileScreen({
    super.key,
    this.userName = 'سامي علي المنيري',
    this.userEmail = 'sami@example.com',
    this.userPhone = '770000000',
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  File? _imageFile; // متغير حفظ ملف الصورة المختارة
  final ImagePicker _picker = ImagePicker();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _emailController = TextEditingController(text: widget.userEmail);
    _phoneController = TextEditingController(text: widget.userPhone);
    _loadSavedData();
  }

  // تحميل البيانات ومسار الصورة المخزنة سابقاً
  void _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedName = prefs.getString('userName');
    final String? savedEmail = prefs.getString('userEmail');
    final String? savedPhone = prefs.getString('userPhone');
    final String? savedImagePath = prefs.getString('userImagePath');

    if (mounted) {
      setState(() {
        if (savedName != null && savedName.isNotEmpty) _nameController.text = savedName;
        if (savedEmail != null) _emailController.text = savedEmail;
        if (savedPhone != null) _phoneController.text = savedPhone;
        if (savedImagePath != null && savedImagePath.isNotEmpty) {
          _imageFile = File(savedImagePath);
        }
      });
    }
  }

  // دالة اختيار الصورة من الكاميرا أو المعرض
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });

        // حفظ مسار الصورة في ذاكرة الجهاز
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userImagePath', pickedFile.path);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تحديث الصورة الشخصية بنجاح! 📸'),
              backgroundColor: AppColors.secondary,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء اختيار الصورة: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // نافذة اختيار مصدر الصورة (معرض الصور أو الكاميرا)
  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'اختيار الصورة الشخصية',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPickerOption(
                    context,
                    icon: LucideIcons.camera,
                    label: 'الكاميرا',
                    color: const Color(0xFF0284C7),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _buildPickerOption(
                    context,
                    icon: LucideIcons.image,
                    label: 'معرض الصور',
                    color: const Color(0xFF10B981),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPickerOption(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  void _saveProfile() async {
    setState(() => _isSaving = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text.trim());
    await prefs.setString('userEmail', _emailController.text.trim());
    await prefs.setString('userPhone', _phoneController.text.trim());

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ البيانات والتغييرات بنجاح! 🎉'),
          backgroundColor: AppColors.secondary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي والحساب'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الحساب الشخصي مع خيار التغيير التفاعلي
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: Center(
                child: GestureDetector(
                  onTap: () => _showImagePickerOptions(context),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2.5),
                        ),
                        child: CircleAvatar(
                          radius: 46,
                          backgroundColor: AppColors.primaryLight,
                          backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                          child: _imageFile == null
                              ? const Icon(LucideIcons.user, size: 50, color: Colors.white)
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(LucideIcons.camera, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // المؤشرات الطبية الحيوية
            const Text(
              'المؤشرات الطبية الحيوية (الحالة الأخيرة)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildVitalMetricCard('نبض القلب', '72 bpm', 'منتظم', LucideIcons.heartPulse, const Color(0xFFEF4444), isDark),
                  _buildVitalMetricCard('ضغط الدم', '120/80', 'مثالي', LucideIcons.activity, const Color(0xFF0284C7), isDark),
                  _buildVitalMetricCard('نسبة السكر', '95 mg/dL', 'طبيعي', LucideIcons.lineChart, const Color(0xFF10B981), isDark),
                  _buildVitalMetricCard('أكسجين الدم', '98%', 'ممتاز', LucideIcons.stethoscope, const Color(0xFF8B5CF6), isDark),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'تعديل البيانات الشخصية',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),

            // حقول الإدخال
            FadeInUp(
              duration: const Duration(milliseconds: 650),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'الاسم الكامل',
                  prefixIcon: Icon(LucideIcons.user, color: AppColors.primaryLight),
                ),
              ),
            ),
            const SizedBox(height: 16),

            FadeInUp(
              duration: const Duration(milliseconds: 700),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: Icon(LucideIcons.mail, color: AppColors.primaryLight),
                ),
              ),
            ),
            const SizedBox(height: 16),

            FadeInUp(
              duration: const Duration(milliseconds: 750),
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  prefixIcon: Icon(LucideIcons.phone, color: AppColors.primaryLight),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // زر الحفظ
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _isSaving ? null : _saveProfile,
                  icon: _isSaving ? const SizedBox.shrink() : const Icon(LucideIcons.save, size: 18),
                  label: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : const Text('حفظ التعديلات', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalMetricCard(String title, String value, String status, IconData icon, Color color, bool isDark) {
    return Container(
      width: 135,
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[400] : const Color(0xFF64748B))),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}