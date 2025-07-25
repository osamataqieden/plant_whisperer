import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_whisperer/services/gemma_handler.dart';

class DownloadingModelWidget extends StatefulWidget {
  const DownloadingModelWidget({super.key});

  @override
  _DownloadingModelWidgetState createState() => _DownloadingModelWidgetState();
}

class _DownloadingModelWidgetState extends State<DownloadingModelWidget> {
  final GemmaHandler _gemmaHandler = GemmaHandler();
  bool _isModelDownloaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    downloadModel();
  }

  downloadModel() async {
    _isModelDownloaded = await _gemmaHandler.downloadModal();
    if (_isModelDownloaded) {
      context.go("/");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Downloading Model')),
      body: Center(
        child: SizedBox(
          height: 400,
          width: 360,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Downloading Model...",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please wait while the model is being downloaded.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
