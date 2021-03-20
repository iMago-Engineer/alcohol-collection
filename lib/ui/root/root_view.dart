import 'package:alcohol_correction/ui/root/root_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RootView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RootViewModel>.reactive(
        builder: (context, model, child) => Scaffold(body: _RootScreen()),
        viewModelBuilder: () => RootViewModel());
  }
}

class _RootScreen extends ViewModelWidget<RootViewModel> {
  @override
  Widget build(BuildContext context, RootViewModel model) {
    return Container(
      child: Text('root'),
    );
  }
}
