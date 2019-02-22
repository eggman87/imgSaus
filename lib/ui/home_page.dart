import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:imgsrc/model/gallery_tag.dart';
import 'package:imgsrc/ui/gallery_page_container.dart';
import 'package:imgsrc/ui/home_page_container.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  HomePage(this.viewModel, {Key key}) : super(key: key);

  final HomeViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeViewModel _vm;
  List<HandPickedGallery> handPickedGalleries = new List();

  @override
  void initState() {
    super.initState();

    handPickedGalleries
        .add(HandPickedGallery("front page", "graphics/keyboard_cat.gif", GalleryFilter.IMGUR_FRONT_PAGE));
    handPickedGalleries
        .add(HandPickedGallery("usersub new", "graphics/arthur_fist.jpg", GalleryFilter.IMGUR_USER_SUB_NEW));
    handPickedGalleries
        .add(HandPickedGallery("usersub viral", "graphics/tips_hat.gif", GalleryFilter.IMGUR_USER_SUB_VIRAL));
    handPickedGalleries
        .add(HandPickedGallery("top of month", "graphics/front_page.jpg", GalleryFilter.IMGUR_TOP_MONTH));
  }

  void _openGallery(BuildContext context, GalleryFilter filter) {
    StoreProvider.of<AppState>(context).dispatch(UpdateFilterAction(filter));
    Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryPageContainer()));
  }

  @override
  Widget build(BuildContext context) {
    _vm = widget.viewModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('imgSaus'),
      ),
      drawer: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 120, 0),
        color: Colors.grey,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Tap To Login"),
              accountEmail: Text(""),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.person),
              ),
            ),
            ListTile()
          ],
        ),
      ),
      body: Container(
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
          SizedBox(
            height: 190,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: handPickedGalleries.length,
                itemBuilder: (context, position) {
                  return _galleryCard(handPickedGalleries[position]);
                }),
          ),
          Container(
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
          SizedBox(
            height: 240,
            width: MediaQuery.of(context).size.width,
            child: StaggeredGridView.countBuilder(
              scrollDirection: Axis.horizontal,
              itemCount: _vm.tags.length,
              itemBuilder: itemBuilder(_vm.tags),
              crossAxisCount: 2,
              staggeredTileBuilder: (int index) => new StaggeredTile.extent(1, tagWidth(_vm.tags[index])),
            ),
          ),
        ],
      )),
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
              width: tagWidth(tag),
              child: Ink.image(
                image: NetworkImage('https://i.imgur.com/${tag.backgroundHash}b.jpg'),
                fit: BoxFit.cover,
                child: InkWell(
                    child: Container(
                      child: _tagText(tag),
                      alignment: Alignment.bottomRight,
                    ),
                    onTap: () =>
                        _openGallery(context, GalleryFilter(GallerySort.viral, GalleryWindow.all, 0, tag: tag))),
              ))
        ],
      );
    };
  }

  double tagWidth(GalleryTag tag) {
    return max((tag.displayName.length * 17).toDouble(), 120);
  }

  SliverGridDelegate delegate() {
    return SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 0.0, crossAxisSpacing: 0.0);
  }

  Widget _frontPageText(String label) {
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
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 23, letterSpacing: 2),
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
      height: 200,
      width: 190,
      child: Stack(children: <Widget>[
        Ink.image(
          height: 200,
          width: 190,
          image: AssetImage(gallery.galleryImage),
          fit: BoxFit.cover,
          child: InkWell(
            child: _frontPageText(gallery.galleryName),
            onTap: () => _openGallery(context, gallery.galleryFilter),
          ),
        ),
      ]),
    );
  }

  Widget _tagText(GalleryTag tag) {
    return SizedBox(
        width: double.infinity,
        child: Container(
            color: Color(0x39000000),
            child: Text(
              tag.displayName,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20, letterSpacing: 2),
            )));
  }
}

class HandPickedGallery {
  String galleryName;
  String galleryImage;
  GalleryFilter galleryFilter;

  HandPickedGallery(this.galleryName, this.galleryImage, this.galleryFilter);
}
