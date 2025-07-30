import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_whisperer/services/gemma_handler.dart';

enum AddPlantWidgetStates { initial, loadingDataFromModel }

class AddPlantWidget extends StatefulWidget {
  const AddPlantWidget({super.key, required this.gemmaHandler});
  final GemmaHandler gemmaHandler;
  @override
  _AddPlantWidgetState createState() => _AddPlantWidgetState();
}

class _AddPlantWidgetState extends State<AddPlantWidget> {
  Uint8List? imageData;
  AddPlantWidgetStates WidgetState = AddPlantWidgetStates.initial;

  Future<void> showCamera() async {
    final ImagePicker picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.camera);
    var bytes = await image!.readAsBytes();
    setState(() {
      imageData = bytes;
      WidgetState = AddPlantWidgetStates.loadingDataFromModel;
    });
    GemmaHandler gemmaHandler = widget.gemmaHandler;
    var result = await gemmaHandler.GetPlantData(bytes);
    print(json.encoder.convert(result));
  }

  @override
  Widget build(BuildContext context) {
    if (WidgetState == AddPlantWidgetStates.loadingDataFromModel) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add Plant')),
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
                    const SizedBox(height: 16),
                    Text(
                      "Processing plant image!",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Add Plant')),
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
                    Icons.camera_alt,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Discover Your Plants!",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Take a photo and watch AI magic unfold!",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textDirection: TextDirection.ltr,
                      children: const [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text('Add Plant'),
                      ],
                    ),
                    onPressed: () => (showCamera()),
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
