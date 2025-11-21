import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class UploadBox extends StatefulWidget {
  final void Function(File)? onImageSelected; // callback ke parent
  final File? image; // ✅ gambar dari parent (kamera)

  const UploadBox({super.key, this.onImageSelected, this.image});

  @override
  State<UploadBox> createState() => _UploadBoxState();
}

class _UploadBoxState extends State<UploadBox> {
  File? _localImage; // hanya untuk gambar galeri
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _localImage = file;
      });

      // Kirim ke parent
      widget.onImageSelected?.call(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Gunakan gambar dari parent jika ada, kalau tidak pakai lokal
    final displayImage = widget.image ?? _localImage;

    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(12),
      child: displayImage == null
          ? DottedBorder(
              color: Colors.grey,
              strokeWidth: 2,
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [8, 4],
              child: Container(
                height: 180,
                width: 180,
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 50, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      "Upload Gambar",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                displayImage,
                fit: BoxFit.cover,
                width: 180,
                height: 180,
              ),
            ),
    );
  }
}
