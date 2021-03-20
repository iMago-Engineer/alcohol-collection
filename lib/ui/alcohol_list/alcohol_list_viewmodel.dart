import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'alcohole_list_view.dart';

class AlcoholListView extends StatelessWidget {
  static const routeName = '/alcohol_list';
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AlcoholListViewModel>.reactive(
        builder: (context, model, child) =>
            Scaffold(body: _AlcoholListScreen()),
        viewModelBuilder: () => AlcoholListViewModel());
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
