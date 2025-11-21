import 'package:flutter/material.dart';

class DiseaseCard extends StatelessWidget {
  final String title;
  final String description;

  const DiseaseCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF556B2F),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class DiseaseCardList extends StatelessWidget {
  const DiseaseCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        DiseaseCard(
          title: "Common Rust",
          description:
              "Penyakit karat yang ditandai dengan pustul coklat kemerahan pada daun. Muncul pada kondisi lembab dengan suhu 16-25°C.",
        ),
        SizedBox(height: 12),
        DiseaseCard(
          title: "Northern Leaf Blight",
          description:
              "Hawar daun yang menyebabkan lesi berbentuk cerutu berwarna abu-abu hingga coklat. Berkembang pada kondisi lembab dan hujan.",
        ),
        SizedBox(height: 12),
        DiseaseCard(
          title: "Gray Leaf Spot",
          description:
              "Bercak daun abu-abu berbentuk persegi panjang. Sering muncul pada musim hujan dengan kelembaban tinggi.",
        ),
        SizedBox(height: 12),
        DiseaseCard(
          title: "Blight",
          description:
              "Hawar daun yang menyebabkan lesi oval berwarna coklat dengan tepi kuning. Dapat menyebar dengan cepat dalam kondisi hangat dan lembab.",
        ),
        SizedBox(height: 12),
        DiseaseCard(
          title: "Healthy",
          description:
              "Daun jagung sehat memiliki warna hijau merata, tidak ada bercak atau lesi, dan memiliki struktur yang normal.",
        ),
      ],
    );
  }
}
