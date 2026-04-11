import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:Deputado_Transparente/l10n/app_localizations.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerWidget extends StatefulWidget {
  final String document;
  const PdfViewerWidget({required this.document, super.key});

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  PdfControllerPinch? _pdfController;

  @override
  void initState() {
    super.initState();
    _initPdfController();
  }

  Future<void> _initPdfController() async {
    final file = await DefaultCacheManager().getSingleFile(widget.document);
    setState(() {
      _pdfController = PdfControllerPinch(document: PdfDocument.openFile(file.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
          title: Text(l10n.documentViewerTitle), elevation: 0),
      body: _pdfController == null
          ? const Center(child: CircularProgressIndicator())
          : PdfViewPinch(controller: _pdfController!),
    );
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }
}
