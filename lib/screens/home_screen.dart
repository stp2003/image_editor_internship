import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'edit_image_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload an Image'),
        backgroundColor: const Color(0xFF2A2A2A),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(
        child: IconButton(
          onPressed: () async {
            XFile? file = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );
            if (file != null) {
              if (!context.mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditImageScreen(
                    selectedImage: file.path,
                  ),
                ),
              );
            }
          },
          icon: const Icon(
            Icons.upload_file,
            size: 32.0,
          ),
        ),
      ),
    );
  }
}
