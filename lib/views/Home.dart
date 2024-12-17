import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cloudinary_file_upload/services/cloudinary_service.dart';
import 'package:flutter_cloudinary_file_upload/services/db_service.dart';
import 'package:flutter_cloudinary_file_upload/views/PreviewImage.dart';
import 'package:flutter_cloudinary_file_upload/views/PreviewVideo.dart';

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
                    itemCount: userUploadedFiles.length,
                    itemBuilder: (context, index) {
                      String name = userUploadedFiles[index]["name"];
                      String ext = userUploadedFiles[index]["extention"];
                      String public_id = userUploadedFiles[index]["public_id"];
                      String fileUrl = userUploadedFiles[index]["url"];

                      return GestureDetector(
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text("Delete file"),
                                    content: const Text(
                                        "Are you sure you want to delete?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No")),
                                      TextButton(
                                          onPressed: () async {
                                            final bool deleteResult =
                                                await DbService().deleteFile(
                                                    snapshot
                                                        .data!.docs[index].id,
                                                    public_id);
                                            if (deleteResult) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text("File deleted"),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Error in deleting file."),
                                                ),
                                              );
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Yes")),
                                    ],
                                  ));
                        },
                        onTap: () {
                          if (ext == "png" || ext == "jpg" || ext == "jpeg") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Previewimage(url: fileUrl)));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Previewvideo(videoUrl: fileUrl)));
                          }
                        },
                        child: Container(
                          color: const Color.fromARGB(255, 186, 173, 173),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              ext == "png" || ext == "jpg" || ext == "jpeg"
                                  ? Expanded(
                                      child: Image.network(
                                        fileUrl,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Center(
                                      child: Icon(Icons.video_library)),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.image),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          final download_result =
                                              await downloadFileFromCloudinary(
                                                  fileUrl, name);
                                          if (download_result) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "File downloaded successfully"),
                                            ));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Error downloading file"),
                                            ));
                                          }
                                        },
                                        icon: Icon(Icons.download))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _openFilePicker();
          },
          child: const Icon(Icons.add),
        ));
  }
}
