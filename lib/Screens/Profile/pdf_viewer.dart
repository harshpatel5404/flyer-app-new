import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewerPage extends StatefulWidget {
  final File? file;
  const PDFViewerPage({Key? key, required this.file,}) : super(key: key);

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  @override
  Widget build(BuildContext context) {
  final name = Path.basename(widget.file!.path);
  return Scaffold(
    appBar: AppBar(
      title: Text(name),
    ),
    body: PDFView(
      filePath: widget.file!.path,
    ),
  );
  }
}
