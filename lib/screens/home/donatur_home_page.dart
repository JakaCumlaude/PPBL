import 'dart:async';
import 'package:flutter/material.dart';
import '../../api_service.dart';
import '../../models/project_model.dart';
import '../project/project_list_screen.dart';
import '../gallery/gallery_hub_page.dart';
import '../volunteer/volunteer_list_page.dart';
import '../profile/profile_page.dart';
import '../../widgets/home_banner.dart';
import '../../widgets/project_card.dart';
import '../../widgets/quick_menu.dart';
import '../../widgets/donation_progress_card.dart';

enum MenuTab { home, gallery, project, volunteer, profile }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MenuTab _selectedTab = MenuTab.home;
  bool _showGreeting = true;

  final Color primaryBlue = const Color(0xFF4A90E2);

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _showGreeting = false);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedTab = MenuTab.values[index];
    });
  }

  Widget _buildSelectedBody() {
    switch (_selectedTab) {
      case MenuTab.home:
        return _buildHomeContent();
      case MenuTab.gallery:
        return const GalleryHubPage();
      case MenuTab.project:
        return const ProjectListScreen();
      case MenuTab.volunteer:
        return const VolunteerListPage();
      case MenuTab.profile:
        return const ProfilePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSelectedBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  /* =========================
        HOME CONTENT
  ========================== */

  Widget _buildHomeContent() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 120,
          backgroundColor: primaryBlue,
          flexibleSpace: const FlexibleSpaceBar(
            title: Text("Tangan Kebaikan"),
            centerTitle: false,
          ),
        ),

        // ===== BANNER =====
        SliverToBoxAdapter(
          child: const HomeBanner(),
        ),

        // ===== STATISTIK =====
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: _buildSummaryStats(),
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),

        // ===== MENU CEPAT =====
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                QuickMenu(
                  icon: Icons.favorite,
                  title: "Donasi",
                  onTap: () {},
                ),
                QuickMenu(
                  icon: Icons.volunteer_activism,
                  title: "Volunteer",
                  onTap: () {},
                ),
                QuickMenu(
                  icon: Icons.photo_library,
                  title: "Galeri",
                  onTap: () {},
                ),
                QuickMenu(
                  icon: Icons.person,
                  title: "Profil",
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),

        // ===== JUDUL PROJECT =====
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Proyek Bantuan Terbaru",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 12),
        ),

        _buildProjectGrid(),

        const SliverToBoxAdapter(
          child: SizedBox(height: 30),
        ),
      ],
    );
  }

  Widget _buildSummaryStats() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem("Rp150M+", "Donasi"),
        _StatItem("1.240", "Proyek"),
        _StatItem("45rb+", "Donatur"),
      ],
    );
  }

  Widget _buildProjectGrid() {
    return FutureBuilder<List<Project>>(
      future: ApiService.fetchProjects(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        final projects = snapshot.data ?? [];

        return SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProjectCard(
                project: projects[index],
                onDetail: () {
                  Navigator.pushNamed(
                    context,
                    '/project-detail',
                    arguments: projects[index],
                  );
                },
              ),
              childCount: projects.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedTab.index,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryBlue,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(
            icon: Icon(Icons.photo_library), label: 'Galeri'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Proyek'),
        BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism), label: 'Volunteer'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}

/* =========================
      WIDGET STAT ITEM
========================= */

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A90E2),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
