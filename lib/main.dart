// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

///????????!
class _HomeState extends State<Home> {
  late CameraController _controller;
  late CameraDescription _cameraDirection;
  File? _file;

  ///?
  late StreamSubscription subscription;
  @override
  void initState() {
    super.initState();
    _cameraDirection = _cameras.last;
    controllerInit();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
        appBar: AppBar(),
        body: _file == null
            ? CameraPreview(_controller)
            : Align(alignment: Alignment.topCenter, child: Image.file(_file!)),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(onPressed: () {}),
            FloatingActionButton(
                child: const Icon(Icons.cameraswitch_outlined),
                onPressed: () async {
                  if (_cameraDirection == _cameras.first) {
                    _cameraDirection = _cameras.last;
                  } else {
                    _cameraDirection = _cameras.first;
                  }
                  await controllerInit();
                  setState(() {});
                }),
            FloatingActionButton(
                child: Icon(_file == null ? Icons.camera : Icons.clear_all),
                onPressed: () async {
                  try {
                    if (_file != null) {
                      _file = null;
                      setState(() {});
                      return;
                    }
                    final xFile = await _controller.takePicture();
                    _file = File(xFile.path);
                    setState(() {});
                  } catch (e) {
                    print('e $e');
                  }
                }),
          ],
        ));
  }

  Future<void> controllerInit() async {
    _controller = CameraController(_cameraDirection, ResolutionPreset.max);
    await _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }
}
