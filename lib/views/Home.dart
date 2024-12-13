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
                    itemCount: userUploadedFiles.length, // Add this line

                    itemBuilder: (context, index) {
                      String name = userUploadedFiles[index]["name"];
                      String ext = userUploadedFiles[index]["extention"];
                      String public_id = userUploadedFiles[index]["public_id"];
                      String fileUrl = userUploadedFiles[index]["url"];
                      return Container(
                        color: Color.fromARGB(255, 186, 173, 173),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(ext == "png" || ext == "jpg" || ext == "jpeg"
                                ? Icons.image
                                : Icons.video_library),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Image.network(
                                fileUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.image),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
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
