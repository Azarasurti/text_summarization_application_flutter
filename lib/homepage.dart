import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _summary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_summary != null) ...[
              displaySummary(_summary!),
            ] else
              chooseFileButton(),
          ],
        ),
      ),
    );
  }

  Widget chooseFileButton() {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );

        if (result != null) {
          File file = File(result.files.single.path!);
          String summary = await uploadFile(file);
          setState(() {
            _summary = summary;
          });
        }
      },
      child: Container(
        width: 300,
        height: 50,
        color: Colors.blue,
        child: const Center(
          child: Text(
            'Choose File',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }

  Widget displaySummary(String summary) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Text(
        'Summary:' + summary,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<String> uploadFile(File file) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.0.2.2:5000/summarize'));
      print('File path: ${file.path}');
      request.files.add(
        http.MultipartFile(
          'file',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path.split("/").last,
          contentType: MediaType('application', 'pdf'),
        ),
      );
      var streamedResponse =
          await request.send().timeout(Duration(seconds: 10));
      var response = await http.Response.fromStream(streamedResponse);
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('File uploaded successfully');
        return response.body; // Return the response body (summary text)
      } else {
        throw Exception('Failed to upload file: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error uploading file: $e');
      throw Exception('Error uploading file: $e');
    }
  }

  Widget displayError() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Text(
        'Error generating summary',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.red, // Display error message in red color
        ),
      ),
    );
  }
}
