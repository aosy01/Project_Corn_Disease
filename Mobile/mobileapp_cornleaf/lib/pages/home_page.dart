import 'package:flutter/material.dart';
import 'camera_page.dart';
import '../widgets/disease_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            const Color(0xFFC6D870), // hijau muda sebagai background
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // Logo atau Gambar Jagung
                  Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/corn_leaf.png', // Ganti dengan aset gambar jagung/daun
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.eco,
                            size: 80,
                            color: Color(0xFF556B2F),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Judul Utama
                  const Text(
                    "Deteksi Penyakit Jagung",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF556B2F), // hijau tua
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Deskripsi
                  Text(
                    "Aplikasi ini membantu petani mendeteksi penyakit pada daun jagung "
                    "seperti hawar daun, karat, dan busuk batang hanya dengan foto.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xFF556B2F).withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Penjelasan Penyakit
                  Column(
                    children: [
                      // Card 1 - Common Rust
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Common Rust",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF556B2F),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Penyakit karat yang ditandai dengan pustul coklat kemerahan pada daun. Muncul pada kondisi lembab dengan suhu 16-25°C.",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Card 2 - Northern Leaf Blight
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Northern Leaf Blight",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF556B2F),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Hawar daun yang menyebabkan lesi berbentuk cerutu berwarna abu-abu hingga coklat. Berkembang pada kondisi lembab dan hujan.",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Card 3 - Gray Leaf Spot
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Gray Leaf Spot",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF556B2F),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Bercak daun abu-abu berbentuk persegi panjang. Sering muncul pada musim hujan dengan kelembaban tinggi.",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Card 4 - Blight
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Blight",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF556B2F),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Hawar daun yang menyebabkan lesi oval berwarna coklat dengan tepi kuning. Dapat menyebar dengan cepat dalam kondisi hangat dan lembab.",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Card 5 - Healthy
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Healthy",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF556B2F),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Daun jagung sehat memiliki warna hijau merata, tidak ada bercak atau lesi, dan memiliki struktur yang normal.",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Tombol Aksi Utama
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CameraPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8FA31E), // hijau olive
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 24),
                          SizedBox(width: 12),
                          Text(
                            "Mulai Analisis Daun",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ));
  }
}
