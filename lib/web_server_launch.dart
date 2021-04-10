import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart' as ShelfRouter;
import 'package:shelf/shelf_io.dart' as io;

class WebServerLauncher extends StatefulWidget {
  @override
  _WebServerLauncherState createState() => _WebServerLauncherState();
}

class _WebServerLauncherState extends State<WebServerLauncher> {
  var msg = '';
  HttpServer? server;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (msg == 'success')
          Text('Server Started')
        else if (msg == 'failed')
          Text('Failed to start server')
        else
          Text('Click to start'),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: msg == 'success'
              ? null
              : () async {
                  try {
                    final app = ShelfRouter.Router();

                    app.get('/hello', (req) {
                      return Response.ok('request accepted');
                    });

                    server = await io.serve(app, 'localhost', 8090);

                    setState(() {
                      msg = 'success';
                    });
                  } catch (e) {
                    setState(() {
                      msg = 'failed';
                    });
                  }
                },
          child: Text('Launch Web Server'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: msg != 'success'
              ? null
              : () async {
                  try {
                    server?.close();

                    setState(() {
                      msg = '';
                    });
                  } catch (e) {
                    print(e);
                  }
                },
          child: Text('Stop Server'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                states.any((element) => element == MaterialState.disabled)
                    ? null
                    : Colors.red),
          ),
        )
      ],
    );
  }
}
