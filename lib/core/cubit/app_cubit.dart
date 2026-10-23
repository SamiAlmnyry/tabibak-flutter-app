import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  final bool isDarkMode;
  final bool isLoggedIn;

  AppState({required this.isDarkMode, required this.isLoggedIn});
}

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState(isDarkMode: false, isLoggedIn: false)) {
    loadSettings();
  }

  // تحميل الإعدادات المحفوظة عند فتح التطبيق
  void loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    final isLogged = prefs.getBool('isLoggedIn') ?? false;
    emit(AppState(isDarkMode: isDark, isLoggedIn: isLogged));
  }

  // تبديل الثيم وحفظه
  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newTheme = !state.isDarkMode;
    await prefs.setBool('isDarkMode', newTheme);
    emit(AppState(isDarkMode: newTheme, isLoggedIn: state.isLoggedIn));
  }

  // حفظ حالة تسجيل الدخول
  void login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    emit(AppState(isDarkMode: state.isDarkMode, isLoggedIn: true));
  }

  // تسجيل الخروج
  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    emit(AppState(isDarkMode: state.isDarkMode, isLoggedIn: false));
  }
}