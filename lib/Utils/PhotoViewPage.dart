import 'dart:io';

import 'package:flutter/material.dart';

class PhotoViewPage extends StatefulWidget {
  PhotoViewPage({super.key,required this.imagePath});
  String imagePath;

  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Image",style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: InteractiveViewer(child: Center(child: Image.file(File(widget.imagePath)))),
      ),
    );
  }
}
