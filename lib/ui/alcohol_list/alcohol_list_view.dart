import 'package:alcohol_collection/models/ocyake.dart';
import 'package:alcohol_collection/models/comment.dart';
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
            Image.network(ocyake.imageUrl),
            SizedBox(height: 14),
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
        ),
        Column(
          children: [SizedBox(height: 20), _Comment(comments: ocyake.comments)],
        )
      ],
    );
  }
}

/// TODO: 誰かリファクタリングしてえええええええええええええ
class _Comment extends ViewModelWidget<AlcoholListViewModel> {
  final List<Comment> comments;
  _Comment({this.comments});

  @override
  Widget build(BuildContext context, AlcoholListViewModel model) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Column(
          children: [_CommentList(context, model, comments), _CommentSubmit()]),
    );
  }
}

/// CommentList
/// - commentTiles
Widget _CommentList(
    context, AlcoholListViewModel model, List<Comment> comments) {
  return Container(
      height: 100,
      child: ListView.builder(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 5, bottom: 5),
          itemCount: comments.length,
          itemBuilder: (context, i) => _CommentTile(comments[i], i)));
}

/// CommentTile
Widget _CommentTile(Comment comment, int i) {
  Color tile_color;
  if (i % 2 == 0) {
    tile_color = Colors.white.withOpacity(0.5);
    ;
  } else {
    tile_color = Colors.black.withOpacity(0.5);
  }
  return ListTile(
    title: Text(
      comment.content,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
    ),
    dense: true,
    tileColor: tile_color,
  );
}

///  コメント送信
class _CommentSubmit extends ViewModelWidget<AlcoholListViewModel> {
  @override
  Widget build(BuildContext context, AlcoholListViewModel model) {
    final screenSize = MediaQuery.of(context).size;
    return new TextField(
        enabled: true,
        style: TextStyle(color: Colors.red),
        obscureText: false,
        maxLines: 1,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () => {},
            icon: Icon(Icons.send),
          ),
        ));
  }
}
