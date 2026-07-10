import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scream Mirror',
      home: MirrorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MirrorScreen extends StatefulWidget {
  @override
  _MirrorScreenState createState() => _MirrorScreenState();
}

class _MirrorScreenState extends State<MirrorScreen> {
  final _localRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    initRenderer();
  }

  initRenderer() async {
    await _localRenderer.initialize();
    final stream = await navigator.mediaDevices.getUserMedia({
      'audio': false,
      'video': {
        'mandatory': {
          'minWidth': '1280',
          'minHeight': '720',
          'minFrameRate': '30',
        },
        'facingMode': 'environment',
      },
    });
    _localRenderer.srcObject = stream;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _localRenderer.srcObject != null
            ? RTCVideoView(_localRenderer)
            : Text("Iniciando espelhamento...", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    super.dispose();
  }
}
