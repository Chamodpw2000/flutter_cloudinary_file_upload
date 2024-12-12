import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FilePickerResult? _filePickerResult;
  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ["jpg", "jpeg", "png", "mp4", "pdf"],
        type: FileType.custom);
    setState(() {
      _filePickerResult = result;
    });

    Navigator.pushNamed(context, "/upload", arguments: _filePickerResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Your Files Here")),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _openFilePicker();
          },
          child: Icon(Icons.add),
        ));
  }
}
