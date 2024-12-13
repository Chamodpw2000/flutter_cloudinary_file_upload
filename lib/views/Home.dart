import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cloudinary_file_upload/services/db_service.dart';

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

    if (_filePickerResult != null) {
      Navigator.pushNamed(context, "/upload", arguments: _filePickerResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Your Files Here"), actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
              icon: const Icon(Icons.logout))
        ]),
        body: StreamBuilder(
          stream: DbService().readUploadedFiles(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List userUploadedFiles = snapshot.data!.docs;

              if (userUploadedFiles.isEmpty) {
                return const Center(child: Text("No files uploaded yet"));
              } else {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      return Container();
                    });
              }
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _openFilePicker();
          },
          child: Icon(Icons.add),
        ));
  }
}
