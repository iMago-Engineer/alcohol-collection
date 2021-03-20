import 'package:flutter/material.dart';

class CameraButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      margin: EdgeInsets.only(bottom: 12),
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            print('camera button');
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.camera_outlined, size: 30)],
          ),
        ),
      ),
    );
  }
}
