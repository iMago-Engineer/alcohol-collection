import 'package:alcohol_collection/models/comment.dart';
import 'package:alcohol_collection/models/ocyake.dart';
import 'package:alcohol_collection/services/style.dart';
import 'package:alcohol_collection/shared/loading.dart';
import 'package:alcohol_collection/ui/alcohol_list/alcohol_list_viewmodel.dart';
import 'package:alcohol_collection/ui/alcohol_list/camera_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endDocked,
              floatingActionButton:
                  model.isBusy ? null : CameraButton(model: model),
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

    final double _bottomCardHeight = 280.0 + 100.0 * ocyake.comments.length;

    return Container(
      padding: EdgeInsets.all(16),
      child: SlimyCard(
        color: Colors.white,
        topCardHeight: screenSize.width * 0.8,
        width: screenSize.width * 0.8,
        borderRadius: 10,
        topCardWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (ocyake.imageUrl != "")
              Container(
                  height: screenSize.width * 0.5,
                  child: Image.network(ocyake.imageUrl)),
            SizedBox(height: 8),
            Text(ocyake.name, style: style.cardTitle),
          ],
        ),
        bottomCardHeight: _bottomCardHeight,
        bottomCardWidget: Column(
          children: [
            _Details(ocyake: ocyake),
            SizedBox(height: 8),
            _RatingBar(ocyake: ocyake, rate: ocyake.likes.toDouble()),
            Divider(thickness: 2),
            _CommentTimeLine(comments: ocyake.comments),
            _CommentInputForm(ocyake: ocyake),
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
            SizedBox(height: 8),
            Text('品目', style: style.cardSubTitle),
            SizedBox(height: 8),
            Text('度数'.toString(), style: style.cardSubTitle),
            SizedBox(height: 8),
            Text('原産国', style: style.cardSubTitle),
            SizedBox(height: 8),
            Text('出会った回数', style: style.cardSubTitle),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(ocyake.type, style: style.cardSubText),
            SizedBox(height: 8),
            Text('${ocyake.alcohol.toString()}度', style: style.cardSubText),
            SizedBox(height: 8),
            Text(ocyake.madeIn, style: style.cardSubText),
            SizedBox(height: 8),
            Text('${ocyake.numberOfPhotosTaken}', style: style.cardSubText),
          ],
        )
      ],
    );
  }
}

class _RatingBar extends ViewModelWidget<AlcoholListViewModel> {
  final Ocyake ocyake;
  final double rate;
  _RatingBar({this.rate, this.ocyake});
  @override
  Widget build(BuildContext context, AlcoholListViewModel model) {
    return RatingBar.builder(
      initialRating: rate,
      minRating: 1,
      direction: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        model.updateRate(ocyake, rating);
      },
    );
  }
}

class _CommentTimeLine extends ViewModelWidget<AlcoholListViewModel> {
  final List<Comment> comments;
  _CommentTimeLine({this.comments});

  @override
  Widget build(BuildContext context, AlcoholListViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        for (var i = 0; i < comments.length; i++)
          Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    model.emoji,
                    style: TextStyle(fontSize: 28),
                  ),
                  SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          comments[i].content,
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                            model.formatDateTime(
                                comments[i].postedAt.toString()),
                            style: TextStyle(color: Colors.grey))
                      ],
                    ),
                  ),
                ]),
                SizedBox(height: 4),
                Divider(thickness: 1)
              ],
            ),
          ),
      ]),
    );
  }
}

class _CommentInputForm extends ViewModelWidget<AlcoholListViewModel> {
  final Ocyake ocyake;

  const _CommentInputForm({Key key, this.ocyake}) : super(key: key);

  @override
  Widget build(BuildContext context, AlcoholListViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_CommentInputArea(), _PostCommentButton(ocyake: ocyake)],
    );
  }
}

class _CommentInputArea extends ViewModelWidget<AlcoholListViewModel> {
  @override
  Widget build(BuildContext context, AlcoholListViewModel model) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.55,
      ),
      margin: EdgeInsets.only(left: 20),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4)),
      child: TextField(
        maxLines: 2,
        onChanged: model.setCommentInput,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: 'Enter a search term'),
      ),
    );
  }
}

class _PostCommentButton extends ViewModelWidget<AlcoholListViewModel> {
  final Ocyake ocyake;

  const _PostCommentButton({Key key, this.ocyake}) : super(key: key);

  @override
  Widget build(BuildContext context, AlcoholListViewModel model) {
    return IconButton(
      icon: Icon(Icons.send),
      onPressed: () async {
        await model.sendComment(ocyake);
      },
    );
  }
}
