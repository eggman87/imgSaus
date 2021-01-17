import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:imgsrc/model/gallery_tag.dart';
import 'package:imgsrc/ui/account_page_container.dart';
import 'package:imgsrc/ui/gallery_page_container.dart';
import 'package:imgsrc/ui/home_page_container.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  HomePage(this.viewModel, {Key key}) : super(key: key);

  final HomeViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  HomeViewModel _vm;
  List<HandPickedGallery> _handPickedGalleries = new List();
  AnimationController _animationController;
  AnimationController _tagsAnimationController;
  Animation<Offset> _scaleInAnimation;
  Animation<Offset> _tagsScaleInAnimation;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();

    _handPickedGalleries
        .add(HandPickedGallery("front page", "graphics/keyboard_cat.gif", GalleryFilter.IMGUR_FRONT_PAGE));
    _handPickedGalleries
        .add(HandPickedGallery("usersub new", "graphics/arthur_fist.jpg", GalleryFilter.IMGUR_USER_SUB_NEW));
    _handPickedGalleries
        .add(HandPickedGallery("usersub viral", "graphics/tips_hat.gif", GalleryFilter.IMGUR_USER_SUB_VIRAL));
    _handPickedGalleries
        .add(HandPickedGallery("top of month", "graphics/front_page.jpg", GalleryFilter.IMGUR_TOP_MONTH));

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 750));
    _tagsAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 750));

    _scaleInAnimation = new Tween(begin: Offset(2, 0), end: Offset(0, 0)).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _tagsScaleInAnimation = new Tween(begin: Offset(2, 0), end: Offset(0, 0)).animate(CurvedAnimation(parent: _tagsAnimationController, curve: Interval(0, 1.0, curve: Curves.easeIn)));
    _animationController.forward();

  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _openGallery(BuildContext context, GalleryFilter filter) {
    StoreProvider.of<AppState>(context).dispatch(UpdateFilterAction(filter));
    Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryPageContainer()));
  }

  @override
  Widget build(BuildContext context) {
    _vm = widget.viewModel;

    if (!_hasStarted && _vm.tags.length > 0) {
      _tagsAnimationController.forward();
      _hasStarted = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('imgSaus'),
        actions: [
          IconButton(icon: Icon(Icons.account_circle_sharp), onPressed:this.goToAccount)
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
              child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              color: Colors.grey.shade400,
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Container(
                  child: Text(
                    "hand picked galleries",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  padding: EdgeInsets.all(12),
                )
              ])),
          SlideTransition(position: _scaleInAnimation, child:SizedBox(
            height: 175,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _handPickedGalleries.length,
                itemBuilder: (context, position) {
                  return _galleryCard(_handPickedGalleries[position]);
                }),
          )), Container(
              color: Colors.grey.shade400,
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Container(
                  child: Text(
                    "galleries by tag",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  padding: EdgeInsets.all(12),
                )
              ])),
          _hasStarted ? SlideTransition(position: _tagsScaleInAnimation, child:SizedBox(
            height: 240,
            width: MediaQuery.of(context).size.width,
            child: _vm.tags.length == 0
                ? Container(color: Colors.black, child: Center(child: CircularProgressIndicator()))
                : StaggeredGridView.countBuilder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _vm.tags.length,
                    itemBuilder: itemBuilder(_vm.tags),
                    crossAxisCount: 2,
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.extent(1, tileWidthFromText(_vm.tags[index].displayName)),
                  ),
          )):Container(height:240, color: Colors.black, child: Center(child: CircularProgressIndicator())),
          Container(
              color: Colors.grey.shade400,
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Container(
                  child: Text(
                    "subreddits",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  padding: EdgeInsets.all(12),
                )
              ])),
          SizedBox(
            height: 240,
            width: MediaQuery.of(context).size.width,
            child: StaggeredGridView.countBuilder(
              scrollDirection: Axis.horizontal,
              itemCount: GalleryFilter.SUB_REDDITS.length,
              itemBuilder: (BuildContext context, int index) => _subredditTile(GalleryFilter.SUB_REDDITS[index]),
              crossAxisCount: 2,
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.extent(1, tileWidthFromText(GalleryFilter.SUB_REDDITS[index])),
            ),
          ),
        ],
      ))),
    );
  }

  Widget Function(BuildContext context, int index) itemBuilder(List<GalleryTag> tags) {
    return (context, position) {
      var tag = tags[position];

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
              height: 120,
              width: tileWidthFromText(tag.displayName),
              child: Ink.image(
                image: NetworkImage('https://i.imgur.com/${tag.backgroundHash}b.jpg'),
                fit: BoxFit.cover,
                child: InkWell(
                    child: Container(
                      child: _tileLabel(tag.displayName),
                      alignment: Alignment.bottomRight,
                    ),
                    onTap: () =>
                        _openGallery(context, GalleryFilter(GallerySort.viral, GalleryWindow.all, 0, tag: tag))),
              ))
        ],
      );
    };
  }

  double tileWidthFromText(String text) {
    return max((text.length * 17).toDouble(), 120);
  }

  SliverGridDelegate delegate() {
    return SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 0.0, crossAxisSpacing: 0.0);
  }

  Widget _galleryLabel(String label) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Color(0x60000000),
                child: Text(
                  label,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20, letterSpacing: 2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _galleryCard(HandPickedGallery gallery) {
    return Container(
      height: double.infinity,
      width: 160,
      child: Stack(children: <Widget>[
        Ink.image(
          height: double.infinity,
          width: 180,
          image: AssetImage(gallery.galleryImage),
          fit: BoxFit.cover,
          child: InkWell(
            child: _galleryLabel(gallery.galleryName),
            onTap: () => _openGallery(context, gallery.galleryFilter),
          ),
        ),
      ]),
    );
  }

  Widget _subredditTile(String subreddit) {
    var randomColor = Color((subreddit.hashCode * 0xFFFFFF).toInt() << 0).withOpacity(1.0);
    var filter = GalleryFilter.fromSubredditName(subreddit);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
            height: 120,
            width: tileWidthFromText(subreddit),
            child: Container(
              color: randomColor,
              child: InkWell(
                  child: Container(
                    child: _tileLabel(subreddit),
                    alignment: Alignment.bottomRight,
                  ),
                  onTap: () => _openGallery(context, filter)),
            ))
      ],
    );
  }

  Widget _tileLabel(String label) {
    return SizedBox(
        width: double.infinity,
        child: Container(
            color: Color(0x39000000),
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20, letterSpacing: 2),
            )));
  }

  void goToAccount() {
    StoreProvider.of<AppState>(context).dispatch(GetAccountAction());
    Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPageContainer()));
  }
}

class HandPickedGallery {
  String galleryName;
  String galleryImage;
  GalleryFilter galleryFilter;

  HandPickedGallery(this.galleryName, this.galleryImage, this.galleryFilter);
}
