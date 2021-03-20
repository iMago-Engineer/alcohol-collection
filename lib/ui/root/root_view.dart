import 'package:alcohol_correction/ui/root/root_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RootView extends StatelessWidget {
  static const routeName = '/root';
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RootViewModel>.reactive(
        builder: (context, model, child) =>
            Scaffold(appBar: AppBar(), body: _RootScreen()),
        viewModelBuilder: () => RootViewModel());
  }
}

class _RootScreen extends ViewModelWidget<RootViewModel> {
  @override
  Widget build(BuildContext context, RootViewModel model) {
    return Center(
      child: Text('root'),
    );
  }
}
