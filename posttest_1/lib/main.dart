import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class AppColors {
  static const primary = Color(0xFF6C4EF6);
  static const primaryDark = Color(0xFF4B32C3);
  static const background = Color(
    0xFFF7F6FB,
  ); // latar lembut, tidak putih polos
  static const card = Colors.white;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Widget wrapper utama aplikasi
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

// Halaman Placeholder
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Struktur dasar halaman placeholder
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        // SafeArea untuk memastikan konten tidak tertutup status bar perangkat
        child: Center(child: Text('Halaman "$title" belum tersedia')),
      ),
    );
  }
}

// HomePage StatefulWidget agar bottom navigation bisa berpindah tab tanpa hilang dari layar
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab =
      0; // 0 = Beranda, 1 = Favorit, 2 = Profil (index tab yang sedang aktif)

  // Fungsi navigasi ke halaman placeholder penuh
  void _goToPlaceholder(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlaceholderPage(title: title)),
    );
  }

  // Fungsi berpindah tab bawah
  void _onNavTap(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Struktur dasar halaman (body + bottomNavigationBar, dll)
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTab,
          children: [
            _buildBerandaTab(context),
            _buildSimpleTab('Favorit', Icons.favorite_rounded),
            _buildSimpleTab('Profil', Icons.person_rounded),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          // Row -> menyusun 3 menu navigasi secara horizontal
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // Expanded -> membagi rata lebar tiap item menu
              child: _NavItem(
                icon: Icons.home_rounded,
                label: 'Beranda',
                isActive: _selectedTab == 0,
                onTap: () => _onNavTap(0),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: Icons.favorite_rounded,
                label: 'Favorit',
                isActive: _selectedTab == 1,
                onTap: () => _onNavTap(1),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: Icons.person_rounded,
                label: 'Profil',
                isActive: _selectedTab == 2,
                onTap: () => _onNavTap(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Isi tab Favorit & Profil: halaman sederhana
  Widget _buildSimpleTab(String label, IconData icon) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'Halaman $label belum tersedia',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  // Isi tab Beranda: konten utama aplikasi (shape judul, menu, grid buku, tentang aplikasi)
  Widget _buildBerandaTab(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 224, 224),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Buku',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pahami inti sebuah buku tanpa perlu membaca semuanya',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari judul buku',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.search,
                    size: 24,
                    color: Colors.grey.shade400,
                  ),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 224, 224),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Menu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MenuFeature(
                    icon: Icons.trending_up_rounded,
                    label: 'Populer',
                    color: const Color(0xFF6C4EF6), // ungu
                    onTap: () => _goToPlaceholder(context, 'Populer'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MenuFeature(
                    icon: Icons.category_rounded,
                    label: 'Kategori',
                    color: const Color(0xFFFF8A5B), // oranye
                    onTap: () => _goToPlaceholder(context, 'Kategori'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MenuFeature(
                    icon: Icons.person_search_rounded,
                    label: 'Author',
                    color: const Color(0xFFFF5C8A), // pink
                    onTap: () => _goToPlaceholder(context, 'Author'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MenuFeature(
                    icon: Icons.history_rounded,
                    label: 'Riwayat',
                    color: const Color(0xFF2EC4B6), // teal
                    onTap: () => _goToPlaceholder(context, 'Riwayat'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MenuFeature(
                    icon: Icons.info_rounded,
                    label: 'Tentang',
                    color: const Color(0xFF3A86FF), // biru
                    onTap: () => _goToPlaceholder(context, 'Tentang'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MenuFeature(
                    icon: Icons.settings_rounded,
                    label: 'Pengaturan',
                    color: const Color(0xFFFFB627), // kuning keemasan
                    onTap: () => _goToPlaceholder(context, 'Pengaturan'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Buku Pilihan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 12),
            // Grid Buku: 2 kolom x 3 baris
            Row(
              children: [
                Expanded(
                  child: _BookGridItem(
                    title: 'Atomic Habits',
                    color: const Color(0xFF6C4EF6),
                    onTap: () => _goToPlaceholder(context, 'Atomic Habits'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BookGridItem(
                    title: 'Filosofi Teras',
                    color: const Color(0xFFFF8A5B),
                    onTap: () => _goToPlaceholder(context, 'Filosofi Teras'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _BookGridItem(
                    title: 'Sapiens',
                    color: const Color(0xFF2EC4B6),
                    onTap: () => _goToPlaceholder(context, 'Sapiens'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BookGridItem(
                    title: 'Deep Work',
                    color: const Color(0xFF3A86FF),
                    onTap: () => _goToPlaceholder(context, 'Deep Work'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _BookGridItem(
                    title: 'Ikigai',
                    color: const Color(0xFFFF5C8A),
                    onTap: () => _goToPlaceholder(context, 'Ikigai'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BookGridItem(
                    title: 'Sapiens Homo Deus',
                    color: const Color(0xFFFFB627),
                    onTap: () => _goToPlaceholder(context, 'Sapiens Homo Deus'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => _goToPlaceholder(context, 'Tentang Aplikasi'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_rounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tentang Aplikasi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Temukan ringkasan buku per bab agar lebih mudah dipahami tanpa harus membaca keseluruhan isi buku.', // Text -> isi deskripsi
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

//  Widget Kotak Menu Fitur
class _MenuFeature extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuFeature({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 6),
            Text(
              label, // Text -> nama menu fitur
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Item Grid Buku
class _BookGridItem extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _BookGridItem({
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title, // Text -> judul buku
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// Widget Item Navigasi Bawah
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isActive ? AppColors.primary : Colors.grey.shade400;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: activeColor),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: activeColor)),
        ],
      ),
    );
  }
}
