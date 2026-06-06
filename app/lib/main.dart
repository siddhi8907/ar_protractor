import 'package:ar_protractor/features/camera/view/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final status = await Permission.camera.request();
  runApp(MyApp(cameraGranted: status.isGranted));
}

class MyApp extends StatelessWidget {
  final bool cameraGranted;
  const MyApp({super.key, required this.cameraGranted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: cameraGranted
          ? const CameraScreen()
          : const _PermissionDeniedScreen(),
    );
  }
}

class _PermissionDeniedScreen extends StatelessWidget {
  const _PermissionDeniedScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Camera permission is required',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => openAppSettings(),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
