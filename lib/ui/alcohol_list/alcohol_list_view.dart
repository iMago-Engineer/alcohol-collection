import 'package:alcohol_collection/models/comment.dart';
import 'package:alcohol_collection/models/ocyake.dart';
import 'package:alcohol_collection/services/style.dart';
import 'package:alcohol_collection/shared/loading.dart';
import 'package:alcohol_collection/ui/alcohol_list/alcohol_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:stacked/stacked.dart';

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

  final style = StyleService();

  @override
  Widget build(BuildContext context, AlcoholListViewModel model) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(16),
      child: SlimyCard(
        color: Colors.white,
        width: screenSize.width * 0.8,
        borderRadius: 10,
        topCardWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.network(ocyake.imageUrl),
            // SizedBox(height: 14),
            Text(ocyake.name, style: style.cardTitle),
            SizedBox(height: 28),
          ],
        ),
        bottomCardWidget: Column(
          children: [
            _Details(ocyake: ocyake),
            Divider(thickness: 2),
          ],
        ),
        slimeEnabled: true,
      ),
    );
  }
}

class _Details extends ViewModelWidget<AlcoholListViewModel> {
  final Ocyake ocyake;
  _Details({this.ocyake});

  final style = StyleService();
  @override
  Widget build(BuildContext context, AlcoholListViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('品目', style: style.cardSubTitle),
            Text('度数'.toString(), style: style.cardSubTitle),
            Text('原産国', style: style.cardSubTitle)
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ocyake.type, style: style.cardSubText),
            Text('${ocyake.alcohol.toString()}度', style: style.cardSubText),
            Text(ocyake.madeIn, style: style.cardSubText)
          ],
        )
      ],
    );
  }
}

class _CommentTimeLine extends ViewModelWidget<AlcoholListViewModel> {
  final List<Comment> comments;
  _CommentTimeLine({this.comments});

  @override
  Widget build(BuildContext context, AlcoholListViewModel model) {
    return ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) =>
            Row(children: [Text('emoji'), Text(comments[index].content)]));
  }
}
