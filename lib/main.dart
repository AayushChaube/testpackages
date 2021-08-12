import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo'),
        ),
        body: const MyStatefullWidget(),
      ),
    );
  }
}

class MyStatefullWidget extends StatefulWidget {
  const MyStatefullWidget({Key? key}) : super(key: key);

  @override
  _MyStatefullWidgetState createState() => _MyStatefullWidgetState();
}

class _MyStatefullWidgetState extends State<MyStatefullWidget> {
  double progress = 0;
  double speed = 0;
  int diffByte = 0;

  void calculateProgress(int received, int total) {
    var result = (received / total) * 100;
    setState(() {
      progress = result;
      print('Progress:  $progress');
    });
  }

  // void calculateSpeed(int received) {
  //   Timer(
  //     const Duration(seconds: 1),
  //     () {
  //       speed = received - diffByte;
  //       var diffByte = received;
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Dummy PDF'),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('PDF'),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                Response response;
                Dio dio = Dio();

                response = await dio.download(
                  'https://research.nhm.org/pdfs/10840/10840.pdf',
                  'D:/dummy.pdf',
                  onReceiveProgress: (current, total) {
                    calculateProgress(current, total);
                    Timer.periodic(
                      const Duration(
                        seconds: 3,
                      ),
                      (t) {
                        var result = 0;
                        setState(() {
                          result = current - diffByte;
                          speed = result / 1024;  //bytes to kilobytes
                          diffByte = current;
                          print('Speed:   $speed');
                        });
                      },
                    );
                  },
                  deleteOnError: true,
                );
              },
              child: const Text('DOWNLOAD'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Progress:   ${progress.round().toString()}%'),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: LinearProgressIndicator(
              minHeight: 30.0,
              value: progress / 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child:
                Text('Download Speed:   ${speed.toStringAsFixed(2)} bytes/s'),
          ),
        ],
      ),
    );
  }
}
