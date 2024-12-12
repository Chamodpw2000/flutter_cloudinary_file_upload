import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_cloudinary_file_upload/services/cloudinary_service.dart";

class Uploadarea extends StatefulWidget {
  const Uploadarea({super.key});

  @override
  State<Uploadarea> createState() => _UploadareaState();
}

class _UploadareaState extends State<Uploadarea> {
  @override
  Widget build(BuildContext context) {
    final selectedFile =
        ModalRoute.of(context)!.settings.arguments as FilePickerResult;
    return Scaffold(
        appBar: AppBar(
          title: Text("Upload Area"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                readOnly: true,
                initialValue: selectedFile.files.first.name,
                decoration: InputDecoration(label: Text("File Name")),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                readOnly: true,
                initialValue: selectedFile.files.first.size.toString(),
                decoration: InputDecoration(label: Text("File Size")),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                readOnly: true,
                initialValue: selectedFile.files.first.extension,
                decoration: InputDecoration(label: Text("File Extension")),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await uploadToCloudinary(selectedFile);

                        if (result) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("File uploaded successfully")));
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("File upload failed")));
                        }
                      },
                      child: Text("Upload"),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
