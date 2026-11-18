import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_lite_camera/flutter_lite_camera.dart';

class TirarFoto extends StatefulWidget {
  final bool iniciarAutomaticamente;

  const TirarFoto({super.key, this.iniciarAutomaticamente = false});

  @override
  State<TirarFoto> createState() => _CameraAppState();
}

class _CameraAppState extends State<TirarFoto> {
  final FlutterLiteCamera _flutterLiteCameraPlugin = FlutterLiteCamera();
  bool _isCameraOpened = false;
  int _textureId = -1;
  int _width = 0;
  int _height = 0;
  int _rotation = 0;
  ResolutionPreset _preset = ResolutionPreset.medium;

  @override
  void initState() {
    super.initState();
    _handleWindowClose();

    // Se o parâmetro for true, inicia a câmera automaticamente ao abrir a tela
    if (widget.iniciarAutomaticamente) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startCamera();
      });
    }
  }

  Future<void> _startCamera() async {
    try {
      List<String> devices = await _flutterLiteCameraPlugin.getDeviceList();
      if (devices.isEmpty) {
        debugPrint('Nenhum dispositivo de câmera encontrado.');
        return;
      }
      debugPrint("Dispositivos disponíveis: $devices");

      bool opened = await _flutterLiteCameraPlugin.open(0);
      if (!opened) {
        debugPrint("Falha ao abrir a câmera.");
        return;
      }

      int textureId = await _flutterLiteCameraPlugin.startPreview();
      int rotation = 0;
      try {
        rotation = await _flutterLiteCameraPlugin.getRotation();
      } catch (e) {
        debugPrint("Erro ao obter rotação, assumindo 0: $e");
      }

      int width = await _flutterLiteCameraPlugin.getWidth();
      int height = await _flutterLiteCameraPlugin.getHeight();

      debugPrint(
        "Tamanho negociado do frame: ${width}x$height, rotação: $rotation",
      );

      setState(() {
        _isCameraOpened = true;
        _textureId = textureId;
        if (width > 0 && height > 0) {
          _width = width;
          _height = height;
        }
        _rotation = rotation;
      });

      if (_preset != ResolutionPreset.medium) {
        await _applyResolution(_preset);
      }
    } catch (e) {
      debugPrint("Erro ao inicializar a câmera: $e");
    }
  }

  Future<void> _applyResolution(ResolutionPreset preset) async {
    setState(() => _preset = preset);
    bool ok = await _flutterLiteCameraPlugin.setResolutionPreset(preset);
    if (!ok) {
      debugPrint("Falha ao aplicar o preset de resolução: $preset");
      return;
    }

    int width = await _flutterLiteCameraPlugin.getWidth();
    int height = await _flutterLiteCameraPlugin.getHeight();
    if (width > 0 && height > 0) {
      setState(() {
        _width = width;
        _height = height;
      });
    }
  }

  Future<void> _stopCamera() async {
    if (_isCameraOpened) {
      await _flutterLiteCameraPlugin.stopPreview();
      await _flutterLiteCameraPlugin.release();
      setState(() {
        _isCameraOpened = false;
        _textureId = -1;
      });
    }

    // Fecha a tela atual (aba da câmera) e retorna para a página anterior
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleWindowClose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChannels.lifecycle.setMessageHandler((message) async {
        if (message == AppLifecycleState.detached.toString()) {
          await _stopCamera();
        }
        return null;
      });
    });
  }

  @override
  void dispose() {
    _stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Câmera Desktop')),
      body: Stack(
        children: [
          if (_textureId >= 0)
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final screenHeight = constraints.maxHeight;

                final frameWidth = _width > 0 ? _width : 4;
                final frameHeight = _height > 0 ? _height : 3;
                final rotated = _rotation % 180 == 90;
                final imageAspectRatio = rotated
                    ? frameHeight / frameWidth
                    : frameWidth / frameHeight;
                final screenAspectRatio = screenWidth / screenHeight;

                double drawWidth, drawHeight;
                if (imageAspectRatio > screenAspectRatio) {
                  drawWidth = screenWidth;
                  drawHeight = screenWidth / imageAspectRatio;
                } else {
                  drawHeight = screenHeight;
                  drawWidth = screenHeight * imageAspectRatio;
                }

                return Center(
                  child: SizedBox(
                    width: drawWidth,
                    height: drawHeight,
                    child: RotatedBox(
                      quarterTurns: (_rotation ~/ 90) % 4,
                      child: _flutterLiteCameraPlugin.buildPreview(_textureId),
                    ),
                  ),
                );
              },
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'A câmera está desligada.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _startCamera,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Ligar Câmera'),
                  ),
                ],
              ),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isCameraOpened ? _stopCamera : _startCamera,
                  icon: Icon(_isCameraOpened ? Icons.stop : Icons.play_arrow),
                  label: Text(
                    _isCameraOpened ? 'Parar Câmera' : 'Iniciar Câmera',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
