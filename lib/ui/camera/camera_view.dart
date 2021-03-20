import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'camera_viewmodel.dart';

class CameraView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CameraViewModel>.reactive(
        builder: (context, model, child) => Scaffold(body: _CameraScreen()),
        viewModelBuilder: () => CameraViewModel());
  }
}

class _CameraScreen extends ViewModelWidget<CameraViewModel> {
  @override
  Widget build(BuildContext context, CameraViewModel model) {
    return Container(
      child: Text('camera'),
    );
  }
}
