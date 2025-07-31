import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_whisperer/data/database_helper.dart';
import 'package:plant_whisperer/data/plant_repository_impl.dart';
import 'package:plant_whisperer/entities/plant_entity.dart';
import 'package:plant_whisperer/services/gemma_handler.dart';
import 'package:sqflite/sqflite.dart';

enum AddPlantWidgetStates { initial, loadingDataFromModel, confirmModelData }

class AddPlantWidget extends StatefulWidget {
  const AddPlantWidget({super.key, required this.gemmaHandler});
  final GemmaHandler gemmaHandler;
  @override
  _AddPlantWidgetState createState() => _AddPlantWidgetState();
}

class _AddPlantWidgetState extends State<AddPlantWidget> {
  Uint8List? imageData;
  PlantEntity? plantData;
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
    setState(() {
      plantData = result;
      WidgetState = AddPlantWidgetStates.confirmModelData;
    });
    print(json.encoder.convert(result));
  }

  Future<void> confirmPlantData() async{
    var helper = await DatabaseHelper();
    var plantRepo = PlantRepositoryImpl(databaseHelper: helper);
    String id = await plantRepo.addPlantEntity(plantData!);
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
    else if(WidgetState == AddPlantWidgetStates.confirmModelData){
      return Scaffold(
        appBar: AppBar(title: const Text('Plant Data')),
        body: Center(
          child: SizedBox(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(children: [
                  Text("Plant Details"),
                  Image.memory(imageData!),
                  SizedBox(height: 20),
                  Text("Plant Species: ${plantData!.species}"),
                  Text("Plant Name: ${plantData!.creativeName}"),
                  Text("Plant Watering Schedule: ${plantData!.wateringSchedule}"),
                  ElevatedButton(onPressed: confirmPlantData, child: Text("Confirm Data!"))
                ],)
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
