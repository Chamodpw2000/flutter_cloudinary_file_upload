// upload files to cloudinary

import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_cloudinary_file_upload/services/db_service.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';

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
      "extention": filePickerResult.files.first.extension!,
      "name": filePickerResult.files.first.name,
    };
    var dbService = DbService();
    await dbService.saveUploadedFileData(requiredData);
    return true;
  } else {
    return false;
  }
}

// Delete Specific file

Future<bool> deleteFromCloudinary(String publicId) async {
  String cloudName = dotenv.env["CLOUDINARY_CLOUD_NAME"] ?? "";
  String apiKey = dotenv.env["CLOUDINARY_API_KEY"] ?? "";
  String apiSecret = dotenv.env["CLOUDINARY_SECRET_KEY"] ?? "";

  int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  String toSign = 'public_id=$publicId&timestamp=$timestamp$apiSecret';

  var bytes = utf8.encode(toSign);
  var digest = sha1.convert(bytes);
  String signature = digest.toString();

  var uri =
      Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/raw/destroy/");

  var responce = await http.post(uri, body: {
    "public_id": publicId,
    "timestamp": timestamp.toString(),
    "api_key": apiKey,
    "signature": signature
  });

  if (responce.statusCode == 200) {
    var responceBody = jsonDecode(responce.body);
    print(responceBody);
    if (responceBody["result"] == "ok") {
      print("File Deleted Successfully");
      return true;
    } else {
      print("Failed to delete file");
      return false;
    }
  } else {
    print(
        "Failed to delete file, status: ${responce.statusCode} : ${responce.reasonPhrase}");
    return false;
  }
}

Future<bool> downloadFileFromCloudinary(String url, String fileName) async {
  try {
    // Request storage permission
    var status = await Permission.storage.request();
    var manageStatus = await Permission.manageExternalStorage.request();
    if (status == PermissionStatus.granted &&
        manageStatus == PermissionStatus.granted) {
      // The user has granted both permissions, so proceed
      print("Storage permissions granted");
    } else {
      // The user has permanently denied one or both permissions, so open the settings
      await openAppSettings();
    }

    // Get the Downloads directory
    Directory? downloadsDir = Directory('/storage/emulated/0/Download');
    if (!downloadsDir.existsSync()) {
      print("Downloads directory not found");
      return false;
    }

    // Create the file path
    String filePath = '${downloadsDir.path}/$fileName';

    // Make the HTTP GET request
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Write file to Downloads folder
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      print("File downloaded successfully! Saved at: $filePath");
      return true;
    } else {
      print("Failed to download file. Status code: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("Error downloading file: $e");
    return false;
  }
}
