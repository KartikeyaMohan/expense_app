import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveTextButton extends StatelessWidget {

  final String text;
  final VoidCallback handler;

  const AdaptiveTextButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ?
            CupertinoButton(
              onPressed: handler,
              child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold
                  ),
                ), 
            ) :
            TextButton(
              onPressed: handler,
              child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold
                  ),
                ),
            );
  }
}