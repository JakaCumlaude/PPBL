import 'package:flutter/material.dart';
import 'package:tangankebaikan/screens/home/splash_screen.dart';
import 'package:tangankebaikan/screens/auth/login_screen.dart';
import 'package:tangankebaikan/screens/auth/register_screen.dart';
import 'package:tangankebaikan/screens/volunteer/volunteer_registration_page.dart';
import 'package:tangankebaikan/screens/volunteer/volunteer_list_page.dart';
import 'package:tangankebaikan/screens/registration_history_page.dart';
import 'package:tangankebaikan/screens/project/project_list_screen.dart';
import 'package:tangankebaikan/screens/project/project_detail_screen.dart';
import 'package:tangankebaikan/screens/project/donation_form_screen.dart';
import 'screens/home/donatur_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/donation/donation_history_page.dart';
import 'screens/volunteer_local/volunteer_local_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final isLogin = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    TanganKebaikanApp(
      isLoggedIn: isLogin,
    ),
  );
}

class TanganKebaikanApp extends StatelessWidget {
  final bool isLoggedIn;

  const TanganKebaikanApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TanganKebaikan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        // Anda bisa menambahkan font default di sini jika ada
        // fontFamily: 'NamaFont',
      ),
      initialRoute: isLoggedIn ? '/' : '/splash',
      routes: {
        '/': (context) => const HomePage(),
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/volunteer-list': (context) => const VolunteerListPage(),
        '/volunteer-registration': (context) =>
            const VolunteerRegistrationPage(),
        '/registration-history': (context) => const RegistrationHistoryPage(),
        '/projects': (_) => const ProjectListScreen(),
        '/project-detail': (_) => const ProjectDetailScreen(),
        '/donation-form': (context) => const DonationFormScreen(),
        '/donation-history': (_) => const DonationHistoryPage(),
        '/volunteer-local': (_) => const VolunteerLocalListPage(),
      },
    );
  }
}
