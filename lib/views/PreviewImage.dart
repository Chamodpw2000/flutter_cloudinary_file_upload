import 'package:flutter/material.dart ';


class Previewimage extends StatefulWidget {
    final String? url;

  const Previewimage({super.key, required this.url});





  @override
  State<Previewimage> createState() => _PreviewimageState();
}

class _PreviewimageState extends State<Previewimage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Preview Image")),
      body: Image.network(widget.url!,
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
      )
, 
    );
  }
}