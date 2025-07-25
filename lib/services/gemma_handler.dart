import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_gemma/core/model.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma/mobile/flutter_gemma_mobile.dart';
import 'package:flutter_gemma/pigeon.g.dart';
import 'package:plant_whisperer/entities/PlantEntity.dart';
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
Analyze the image and return the following information in a single line of text, with fields separated by a pipe character `|`:
species | common name | personality | watering schedule (in hours) | health status | care tips | achievements
- The `care tips` field should be a semicolon-separated list of exactly 2 tips.
- The `achievements` field should be a semicolon-separated list of exactly 2 gamified milestones the user can unlock by caring for this plant.
Return format example:
Ficus lyrata | Fiddle Leaf Fig | Dramatic and high-maintenance | 72 | needs attention | Place in bright, indirect light;Avoid cold drafts | Survived 30 days without leaf drop;Perfect watering for 3 weeks
If the plant cannot be identified, return:
unknown
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
    return new PlantEntity();
  }
}
