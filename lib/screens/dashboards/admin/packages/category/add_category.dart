import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  Map<String, String?> selectedFiles = {
    "Profile Picture": null,
  };
  final _formKey = GlobalKey<FormState>();

  void _pickFile(String fileType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        setState(() {
          selectedFiles[fileType] = file.name; // 🔥 Save selected file name
        });

        Logger.info("Picked file for $fileType: ${file.name}");
      }
    } catch (e) {
      Logger.error("Error picking file: $e");
    }
  }

  void _removeFile(String fileType) {
    setState(() {
      selectedFiles[fileType] = null; // 🔥 Remove selected file
    });
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.blue.shade50,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Category',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blueAccent.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Name'),
                    _buildTextField('Description'),
                    SizedBox(height: 20),
                    Text(
                      "Attachments",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildUploadButton("Profile Picture"),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          "Save",
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
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
            icon: Icon(Icons.upload_file),
            label: Text("Upload $fileType"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          SizedBox(width: 10), // 🔥 Ensure spacing between button & file name

          if (selectedFiles[fileType] !=
              null) // 🔥 Show file name & remove button
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedFiles[fileType]!,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  overflow: TextOverflow.ellipsis, // 🔥 Avoid overflow issues
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () => _removeFile(fileType), // 🔥 Remove file
                ),
              ],
            ),
        ],
      ),
    );
  }
}
