import 'package:flutter/material.dart';
import 'camera_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Widget untuk membuat bullet point yang rapi
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "•",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _diseaseCard({
    required String title,
    required List<String> symptoms,
    IconData icon = Icons.eco,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF556B2F), size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF556B2F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...symptoms.map((symptom) => _buildBulletPoint(symptom)).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6D870),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo Jagung
                Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo_app.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.eco, size: 90, color: Color(0xFF556B2F));
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Judul
                const Text(
                  "Deteksi Penyakit Jagung",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF556B2F),
                  ),
                ),

                const SizedBox(height: 16),

                // Deskripsi
                Text(
                  "Unggah foto daun jagung Anda, kami akan deteksi penyakitnya dalam hitungan detik!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF556B2F).withOpacity(0.9),
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 32),

                // Daftar Penyakit
                _diseaseCard(
                  title: "Karat Daun Jagung",
                  icon: Icons.grass,
                  symptoms: [
                    "Bintik-bintik kecil berwarna coklat kekuningan atau kemerahan",
                    "Muncul terutama pada fase generatif",
                    "Dalam kondisi lembap menyebar sangat cepat",
                    "Daun menjadi kering, rapuh, dan fotosintesis terganggu",
                  ],
                ),
                const SizedBox(height: 16),

                _diseaseCard(
                  title: "Hawar Daun Jagung",
                  icon: Icons.warning_amber,
                  symptoms: [
                    "Bercak kuning memanjang, lalu berubah coklat",
                    "Jaringan daun mengering dan mati",
                    "Gejala mulai dari daun bawah menuju atas",
                    "Serangan berat dapat menyebabkan tanaman layu total",
                  ],
                ),
                const SizedBox(height: 16),

                _diseaseCard(
                  title: "Bercak Daun Jagung",
                  icon: Icons.coronavirus,
                  symptoms: [
                    "Bercak lonjong kuning kecoklatan dengan tepi jelas",
                    "Bercak dapat menyatu dan daun mengering",
                    "Sering muncul saat cuaca lembap dan berangin",
                    "Menular melalui percikan air hujan",
                  ],
                ),
                const SizedBox(height: 16),

                _diseaseCard(
                  title: "Bulai (Downy Mildew)",
                  icon: Icons.sick,
                  symptoms: [
                    "Tanaman kerdil, daun pucat dan menggulung",
                    "Tulang daun menonjol, daun kering dari ujung",
                    "Tongkol kecil atau tidak terbentuk",
                    "Infeksi sistemik, bisa gagal panen 100% jika dini",
                  ],
                ),
                const SizedBox(height: 16),

                _diseaseCard(
                  title: "Daun Sehat",
                  icon: Icons.sentiment_very_satisfied,
                  symptoms: [
                    "Warna hijau merata dan segar",
                    "Tidak ada bercak, garis, atau perubahan warna",
                    "Permukaan daun halus, tidak ada jamur",
                    "Fotosintesis berjalan optimal",
                  ],
                ),

                const SizedBox(height: 32),

                // Tombol Mulai Analisis
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CameraPage()),
                      );
                    },
                    icon: const Icon(Icons.camera_alt, size: 28),
                    label: const Text(
                      "Mulai Analisis Daun",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8FA31E),
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}