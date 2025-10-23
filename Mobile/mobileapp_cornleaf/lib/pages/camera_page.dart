import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'camera_button.dart';
import 'uploadbox_button.dart';

class CameraGalleryPage extends StatefulWidget {
  const CameraGalleryPage({super.key});

  @override
  State<CameraGalleryPage> createState() => _CameraGalleryPageState();
}

class _CameraGalleryPageState extends State<CameraGalleryPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String _result = "";

  // ⚙️ Ganti IP sesuai alamat Flask server kamu
  final String flaskUrl = "http://10.133.39.54:5000/predict"; 
  // untuk emulator Android. kalau di HP fisik, pakai IP LAN laptop, contoh:
  // final String flaskUrl = "http://192.168.1.7:5000/predict";

  /// 🔹 Upload gambar ke Flask dan ambil hasil prediksi
  Future<void> _runModel(File image) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(flaskUrl));
      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var respStr = await response.stream.bytesToString();
        var jsonResponse = json.decode(respStr);

        setState(() {
          _result =
              "Kelas: ${jsonResponse['class']}\nAkurasi: ${(jsonResponse['confidence'] * 100).toStringAsFixed(2)}%";
        });
      } else {
        setState(() {
          _result = "⚠️ Gagal memproses gambar (Error ${response.statusCode})";
        });
      }
    } catch (e) {
      setState(() {
        _result = "❌ Terjadi kesalahan: $e";
      });
    }
  }

  /// 📸 Ambil gambar dari kamera
  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });

      _showSnackBar("📸 Capture Image Successfully!");
      await _runModel(_image!);
    }
  }

  /// 🖼️ Callback dari UploadBox (galeri)
  void _onImageSelected(File image) async {
    setState(() {
      _image = image;
    });

    _showSnackBar("🖼️ Upload Image Successfully!");
    await _runModel(image);
  }

  /// 🎨 SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analisis Daun"),
        backgroundColor: const Color(0xFF8FA31E),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Text(
                "Masukkan gambar daun yang ingin dianalisis",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 30),

              // 📂 Upload dari galeri
              UploadBox(onImageSelected: _onImageSelected, image: _image),

              const SizedBox(height: 20),

              // 📸 Tombol kamera
              CameraButton(onPressed: _openCamera),

              const SizedBox(height: 30),

              // 📊 Hasil prediksi
              if (_result.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF8FA31E)),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _result,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
