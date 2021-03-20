import 'package:alcohol_collection/ui/alcohol_list/alcohol_list_viewmodel.dart';
import 'package:alcohol_collection/ui/root/root_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RootView extends StatelessWidget {
  static const routeName = '/root';
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RootViewModel>.reactive(
      viewModelBuilder: () => RootViewModel(),
      builder: (context, model, child) =>
          Scaffold(body: Scaffold(body: AlcoholListView())),
    );
  }
}
