import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_gemma/core/model.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma/mobile/flutter_gemma_mobile.dart';
import 'package:flutter_gemma/pigeon.g.dart';
import 'package:plant_whisperer/entities/plant_entity.dart';
import 'package:plant_whisperer/services/file_handler.dart';

class GemmaHandler {
  static String modelFileName = 'gemma_model.task';
  static String modelNetworkPath =
      'https://storage.googleapis.com/plants-whisperer/gemma-3n-E2B-it-int4.task';

  FlutterGemma? gemma;
  InferenceModel? inferenceModel;

  Future<bool> downloadModal() async {
    FileHandler fileHandler = FileHandler();
    String localPath = await fileHandler.getLocalFilePath(modelFileName);
    print("Downloading model to: $localPath");
    Dio dio = Dio();
    await dio.download(
      modelNetworkPath,
      localPath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print("Downloading: ${(received / total * 100).toStringAsFixed(0)}%");
        }
      },
    );
    return true;
  }

  Future<bool> loadModel() async {
    print("Loading model from: $modelFileName");
    FileHandler fileHandler = FileHandler();
    String localPath = await fileHandler.getLocalFilePath(modelFileName);
    await FlutterGemmaPlugin.instance.modelManager.setModelPath(localPath);
    inferenceModel = await FlutterGemmaPlugin.instance.createModel(
      modelType: ModelType.gemmaIt, // Required, model type to create
      preferredBackend: PreferredBackend.gpu, // Optional, backend type
      maxTokens: 4096, // Recommended for multimodal models
      supportImage: true, // Enable image support
      maxNumImages: 1, // Optional, maximum number of images per message
    );
    print("Model loaded successfully from: $localPath");
    return true;
  }

  Future<bool> isModelDownloaded() async {
    final fileHandler = FileHandler();
    final modelPath = await fileHandler.CheckFileExists(modelFileName);
    return modelPath.isNotEmpty;
  }

  Future<PlantEntity> GetPlantData(Uint8List imageData) async {
    String prompt = '''
You are a plant expert. The user will provide an image of a plant.
The user is playing a game where they care for plants and earn achievements, and each plant has a distinct personality.
Analyze the image and return the following information in a single line of text, with fields separated by a pipe character |:
species | common name | creative name | personality | watering schedule (in days) | health status | care tips
- The care tips field should be a list of tips covering watering, light, repotting, fertilizing, pruning, pest control, and soil needs.
- The health status field should be on a scale of 1 to 10, where 1 is very unhealthy and 10 is very healthy.
- The watering schedule should be in days, indicating how often the plant needs to be watered - the user will receive push notifications based on this interval.
- The personality will dictate the user interaction with the plant later on, regarding user messages and notifications. They should be creative and engaging, and reflect the plant's nature.
Return format example:
Ficus lyrata | Fiddle Leaf Fig | Figrutave Leaf | Dramatic and high-maintenance | 7 | 6 | tips:Place in bright, indirect light | tips:Water when top inch of soil is dry | tips:Repot every 2-3 years in spring | tips:Fertilize monthly in growing season 
Do not include field names, extra explanation, or code formatting. Only return the formatted line.
    ''';

    final session = await inferenceModel!.createSession(
      enableVisionModality: true,
    );
    await session.addQueryChunk(
      Message.withImage(text: prompt, imageBytes: imageData),
    );

    String? result = await session.getResponse();
    print("Model response: $result");
    PlantEntity entity = ParsePlantEntity(result, imageData);
    return entity;
  }

  PlantEntity ParsePlantEntity(String result, Uint8List imgBytes) {
    var data = result.split('|');
    String species = data[0];
    var commonName = data[1];
    var creativeName = data[2];
    var personality = data[3];
    var wateringScheduleTemp = data[4];
    var healthStatusTemp = data[5];
    var wateringSchedule = int.parse(wateringScheduleTemp);
    var healthStatus = int.parse(healthStatusTemp);
    List<String> tips = new List.empty(growable: true);
    for (int x = 6; x < data.length; x++) {
      tips.add(data[x]);
    }
    var base64Img = base64Encode(imgBytes);
    PlantEntity entity = new PlantEntity(
      species,
      commonName,
      creativeName,
      personality,
      wateringSchedule,
      healthStatus,
      tips,
      new List.empty(),
      "",
      base64Img,
    );
    return entity;
  }
}
