import 'package:alcohol_collection/models/ocyake.dart';
import 'package:alcohol_collection/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:stacked/stacked.dart';

import 'alcohole_list_view.dart';

class AlcoholListView extends StatelessWidget {
  static const routeName = '/alcohol_list';
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AlcoholListViewModel>.reactive(
      viewModelBuilder: () => AlcoholListViewModel(),
      onModelReady: (model) => model.loadOcyake(),
      builder: (context, model, child) => model.isBusy
          ? Loading()
          : Scaffold(
              appBar: AppBar(
                title: Text('Alcohol collection',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                centerTitle: false,
                backgroundColor: Theme.of(context).accentColor,
              ),
              body: _AlcoholListScreen(),
              backgroundColor: Color(0xff191414),
            ),
    );
  }
}

class _AlcoholListScreen extends ViewModelWidget<AlcoholListViewModel> {
  @override
  Widget build(BuildContext context, AlcoholListViewModel model) {
    return SafeArea(
      child: ListView.builder(
          itemCount: model.osyakes.length,
          itemBuilder: (context, i) => _OcyakeCard(ocyake: model.osyakes[i])),
    );
  }
}

class _OcyakeCard extends ViewModelWidget<AlcoholListViewModel> {
  final Ocyake ocyake;
  _OcyakeCard({this.ocyake});
  @override
  Widget build(BuildContext context, AlcoholListViewModel model) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(16),
      child: SlimyCard(
        color: Colors.grey,
        width: screenSize.width * 0.7,
        topCardHeight: screenSize.width * 0.7,
        bottomCardHeight: 300,
        borderRadius: 10,
        topCardWidget: Text(ocyake.name),
        bottomCardWidget: Column(
          children: [
            Text(ocyake.type),
            Text(ocyake.madeIn),
            Text(ocyake.likes.toString())
          ],
        ),
        slimeEnabled: true,
      ),
    );
  }
}
