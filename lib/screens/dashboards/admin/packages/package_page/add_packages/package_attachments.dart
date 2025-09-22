import 'package:bizzmirth_app/utils/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PackageAttachmentScreen extends StatefulWidget {
  const PackageAttachmentScreen({super.key});

  @override
  State<PackageAttachmentScreen> createState() =>
      _PackageAttachmentScreenState();
}

class _PackageAttachmentScreenState extends State<PackageAttachmentScreen> {
  final _formKey = GlobalKey<FormState>();
// Default selection
  List<String> selectedHotelStars = [];
  List<String> selectedHotelStars1 = [];

  Map<String, String?> selectedFiles = {
    'Package Picture': null,
  };

  Future<void> _pickFile(String fileType) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        final PlatformFile file = result.files.first;

        setState(() {
          selectedFiles[fileType] = file.name; // 🔥 Save selected file name
        });

        Logger.info('Picked file for $fileType: ${file.name}');
      }
    } catch (e) {
      Logger.error('Error picking file: $e');
    }
  }

  void _removeFile(String fileType) {
    setState(() {
      selectedFiles[fileType] = null; // 🔥 Remove selected file
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blueAccent.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Package Images:',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 10),
                  _buildUploadButton('Package Picture'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton(String fileType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10), // 🔥 Add spacing
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () => _pickFile(fileType),
            icon: const Icon(Icons.upload_file),
            label: Text('Upload $fileType'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          const SizedBox(
              width: 10), // 🔥 Ensure spacing between button & file name

          if (selectedFiles[fileType] !=
              null) // 🔥 Show file name & remove button
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedFiles[fileType]!,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  overflow: TextOverflow.ellipsis, // 🔥 Avoid overflow issues
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _removeFile(fileType), // 🔥 Remove file
                ),
              ],
            ),
        ],
      ),
    );
  }
}
