import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/cubit/app_cubit.dart';
import '../../core/theme/app_colors.dart';
import '../auth/login_screen.dart';
import '../archive/archive_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('الإعدادات'),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              SwitchListTile(
                secondary: Icon(
                  state.isDarkMode ? LucideIcons.moon : LucideIcons.sun,
                  color: AppColors.primary,
                ),
                title: const Text('الوضع الداكن (Dark Mode)'),
                value: state.isDarkMode,
                onChanged: (val) {
                  // استدعاء الدالة بدون تمرير arguments لتفادي الخطأ
                  context.read<AppCubit>().toggleTheme();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(LucideIcons.archive, color: AppColors.primary),
                title: const Text('أرشيف العناصر المحذوفة'),
                subtitle: const Text('عرض واستعادة العناصر المؤرشفة'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ArchiveScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(LucideIcons.logOut, color: Colors.red),
                title: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  context.read<AppCubit>().logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}