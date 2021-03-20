import 'package:alcohol_collection/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'alcohole_list_view.dart';

class AlcoholListView extends StatelessWidget {
  static const routeName = '/alcohol_list';
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AlcoholListViewModel>.reactive(
      viewModelBuilder: () => AlcoholListViewModel(),
      onModelReady: (model) => model.loadOcyake(),
      builder: (context, model, child) =>
          model.isBusy ? Loading() : Scaffold(body: _AlcoholListScreen()),
    );
  }
}

class _AlcoholListScreen extends ViewModelWidget<AlcoholListViewModel> {
  @override
  Widget build(BuildContext context, AlcoholListViewModel model) {
    return Container(
      child: Text('alcohole list'),
    );
  }
}
