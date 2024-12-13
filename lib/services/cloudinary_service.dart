// upload files to cloudinary

import 'dart:convert';
import 'dart:io';
import 'package:flutter_cloudinary_file_upload/services/db_service.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<bool> uploadToCloudinary(FilePickerResult? filePickerResult) async {
  if (filePickerResult == null || filePickerResult.files.isEmpty) {
    print("No file selected");
    return false;
  }

  File file = File(filePickerResult.files.single.path!);

  String cloudName = dotenv.env["CLOUDINARY_CLOUD_NAME"] ?? "";

  var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/raw/upload");

  var requset = http.MultipartRequest("POST", uri);

  var fileBytes = await file.readAsBytes();

  var multipartFile = http.MultipartFile.fromBytes('file', fileBytes,
      filename: file.path.split("/").last);

  requset.files.add(multipartFile);

  requset.fields["upload_preset"] = "preset-for-file-upload";

  requset.fields["resource_type"] = "raw";

  var response = await requset.send();

  var responseBody = await response.stream.bytesToString();

  print(responseBody);

  if (response.statusCode == 200) {
    var jasonResponse = jsonDecode(responseBody);
    Map<String, String> requiredData = {
      "public_id": jasonResponse["public_id"],
      "resource_type": jasonResponse["resource_type"],
      "url": jasonResponse["secure_url"],
      "created_at": jasonResponse["created_at"],
      "bytes": jasonResponse["bytes"].toString(),
      "type": jasonResponse["type"],
      "name": filePickerResult.files.first.name,
    };
    var dbService = DbService();
    await dbService.saveUploadedFileData(requiredData);
    return true;
  } else {
    return false;
  }
}
