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

void main() {
  runApp(const TanganKebaikanApp());
}

class TanganKebaikanApp extends StatelessWidget {
  const TanganKebaikanApp({super.key});

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
      initialRoute: '/splash',
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
      },
    );
  }
}
