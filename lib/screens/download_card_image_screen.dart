import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:image_downloader/image_downloader.dart';

import '../settings/settings_color.dart';

class DownloadImageScreen extends StatefulWidget {
  const DownloadImageScreen({Key? key}) : super(key: key);

  @override
  _DownloadImageScreenState createState() => _DownloadImageScreenState();
}

class _DownloadImageScreenState extends State<DownloadImageScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late Map<String, dynamic> image;
  int progressDownload = 0;
  String _message = "";

  @override
  void initState() {
    super.initState();
    ImageDownloader.callback(onProgressUpdate: (String? imageId, int progress) {
      setState(() {
        progressDownload = progress;
      });
    });
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    image = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await downloadCard(image['imageUrl']);
                  ImageDownloader.callback(onProgressUpdate: (String? imageId, int progress) {
                    setState(() {
                      print(progress.toString());
                      progressDownload = progress;
                    });
                  });
                  final status = SnackBar(
                    content: Text(_message),
                    action: SnackBarAction(
                        textColor: SettingsColor.cardColor,
                        label: 'Hecho',
                        onPressed: (){}
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(status);
                },
                icon: Icon(Icons.download, color: SettingsColor.textColor)
            )
          ],
          backgroundColor: SettingsColor.backColor,
        ),
        body: Column(
            children: [
              Container(
                  child: Column(
                    children: [
                      hero(),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text("Progress", style: TextStyle(color: SettingsColor.textColor)),
                            SizedBox(height: 5),
                            FAProgressBar(currentValue: progressDownload.toDouble(), displayText: '%')
                          ],
                        )
                      )
                    ],
                  )
              )
            ]
        ),
        backgroundColor: SettingsColor.backColor
    );
  }

  Widget hero(){
    return Hero(
        tag: "image-card${image['name']}",
        child: FadeInImage(
          placeholder: const AssetImage('assets/placeholder.jpg'),
          image: NetworkImage('${image['imageUrl']}'),
          fadeInDuration: const Duration(milliseconds: 500),
        )
    );
  }

  Future<void> downloadCard(
      String url, {
        AndroidDestinationType? destination,
        bool whenError = false,
        String? outputMimeType,
      }) async {
    if(_connectionStatus.toString() == "ConnectivityResult.none"){
      _message = "No Internet Connection";
      return;
    }
    String? fileName;
    try {
      String? imageId;

      if (whenError) {
        imageId = await ImageDownloader.downloadImage(url,
            outputMimeType: outputMimeType)
            .catchError((error) {
          if (error is PlatformException) {
            if (error.code == "404") {
              return "Imagen no encontrada";
            } else if (error.code == "unsupported_file") {
              return "Archivo no soportado";
            }
          }

          print(error);
        }).timeout(Duration(seconds: 10), onTimeout: () {
          print("timeout");
          return;
        });
      } else {
        if (destination == null) {
          imageId = await ImageDownloader.downloadImage(
            url,
            outputMimeType: outputMimeType,
          );
        } else {
          imageId = await ImageDownloader.downloadImage(
            url,
            destination: destination,
            outputMimeType: outputMimeType,
          );
        }
      }

      if (imageId == null) {
        setState(() => _message = "Ninguna respuesta por parte del servidor");
        return;
      }
      fileName = await ImageDownloader.findName(imageId);
    } on PlatformException catch (error){
      setState(() => _message = error.message ?? '');
      return;
    }
    setState(() => _message = 'Saved as "$fileName"');
    return;
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }
}
