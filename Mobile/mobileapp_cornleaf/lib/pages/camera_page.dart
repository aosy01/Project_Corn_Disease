import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobileapp_cornleaf/widgets/camera_button.dart';
import 'package:mobileapp_cornleaf/widgets/uploadbox_button.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _image;
  String? _predictedClass;
  double? _confidence;
  String? _treatment;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  // Ganti dengan IP lokal atau URL backend Anda
  final String _apiUrl =
      "http://192.168.50.242:5000/predict"; // Contoh: http://192.168.1.100:5000/predict

  Future<void> _pickImage({ImageSource source = ImageSource.camera}) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        _predictedClass = null;
        _confidence = null;
        _treatment = null;
      });
      await _predictImage();
    }
  }

Future<void> _predictImage() async {
  if (_image == null) return;

  setState(() => _isLoading = true);

  try {
    var request = http.MultipartRequest('POST', Uri.parse(_apiUrl));
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

    var response = await request.send().timeout(const Duration(seconds: 30));
    var responseData = await response.stream.bytesToString();
    var jsonResponse = json.decode(responseData);

    print("RAW JSON dari server: $responseData"); // Tambah ini buat debug

    if (response.statusCode == 200) {
      setState(() {
        _predictedClass = jsonResponse['predicted_class'];   // FIXED
        _confidence = (jsonResponse['confidence'] as num).toDouble();
        _treatment = jsonResponse['treatment'];
      });
    } else {
      _showError("Server error: ${jsonResponse['error'] ?? response.reasonPhrase}");
    }
  } catch (e) {
    _showError("Koneksi gagal: $e");
  } finally {
    setState(() => _isLoading = false);
  }
}

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showTreatmentDialog() {
    if (_treatment == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.local_hospital, color: Colors.green),
            const SizedBox(width: 8),
            const Text("Penanganan"),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            _treatment!,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deteksi Penyakit Jagung"),
        backgroundColor: const Color(0xFF556B2F),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
           const SizedBox(height: 24),

           Text(  
              "Deteksi Penyakit Jagungmu Disini!",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF556B2F),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

           Text(
              "Ambil gambar daun jagung menggunakan kamera ataupun Unggah Gambar untuk mendeteksi penyakitnya secara otomatis.",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            // Preview Gambar
            GestureDetector(
              onTap: () => _pickImage(source: ImageSource.gallery),
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.file(
                            _image!,
                            height: 280,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: 280,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: 280,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[400]!, width: 2),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_library,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Ketuk untuk memilih dari galeri",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 20),
             // Tombol Kamera
            CameraButton(onPressed: _pickImage),
            const SizedBox(height: 24),
            // Loading Indicator
            if (_isLoading)
              const Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Color(0xFF8FA31E)),
                  ),
                  SizedBox(height: 12),
                  Text("Menganalisis gambar...",
                      style: TextStyle(fontSize: 16)),
                ],
              ),

            // Hasil Prediksi
            if (!_isLoading && _predictedClass != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Hasil Deteksi:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: _showTreatmentDialog,
                            child: const Icon(
                              Icons.error_outline,
                              color: Colors.orange,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _predictedClass!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF556B2F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Akurasi: ${(_confidence! * 100).toStringAsFixed(1)}%",
                        style: TextStyle(
                          fontSize: 16,
                          color: _confidence! >= 0.7
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Ketuk ikon ⚠️ untuk melihat cara penanganan",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                        textAlign: TextAlign.center,
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
