import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_whisperer/screens/add-plant/add_plant_widget.dart';
import 'package:plant_whisperer/screens/downloading-model/downloading_model_widget.dart';
import 'package:plant_whisperer/services/gemma_handler.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MyHomePage(title: 'Plant Whisperer');
      },
    ),
    GoRoute(
      path: '/add-plant',
      builder: (BuildContext context, GoRouterState state) {
        var gemmaHandler = state.extra as GemmaHandler;
        return AddPlantWidget(gemmaHandler: gemmaHandler);
      },
    ),
    GoRoute(
      path: '/download-model',
      builder: (BuildContext context, GoRouterState state) {
        return const DownloadingModelWidget();
      },
    ),
  ],
);

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Plant Whisperer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      routerConfig: router,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool IsInitialized = false;
  bool IsModelLoading = true;
  GemmaHandler? gemmaHandler;

  @override
  void initState() {
    super.initState();
    gemmaHandler = GemmaHandler();
    checkModalStatus();
  }

  void checkModalStatus() async {
    bool isDownloaded = await gemmaHandler!.isModelDownloaded();
    FlutterNativeSplash.remove();
    if (!isDownloaded) {
      context.go('/download-model');
    } else {
      print("Here");
      await gemmaHandler!.loadModel();
      print("Model loaded successfully");
      setState(() {
        IsModelLoading = false;
      });
      //load the modal
    }
  }

  void _addPlant() {
    // Navigate to the Add Plant screen
    context.push(
      '/add-plant',
      extra: gemmaHandler,
    ); // Pass the gemmaHandler to the AddPlantWidget
  }

  List<Widget> GetMainBody() {
    if (IsModelLoading) {
      return [const Center(child: CircularProgressIndicator())];
    } else {
      return [const Center(child: Text('No plants added yet.'))];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green, title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: GetMainBody(),
        ),
      ),
      floatingActionButton: IsModelLoading
          ? null
          : FloatingActionButton(
              onPressed: _addPlant,
              tooltip: 'Add Plant',
              child: const Icon(Icons.add),
            ),
    );
  }
}
