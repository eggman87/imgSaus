import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:imgsrc/model/gallery_tag.dart';
import 'package:imgsrc/ui/gallery_page_container.dart';
import 'package:imgsrc/ui/home_page_container.dart';

class HomePage extends StatefulWidget {
  HomePage(this.viewModel, {Key key}) : super(key: key);

  final HomeViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeViewModel _vm;

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
                    "GALLERIES",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  padding: EdgeInsets.all(12),
                )
              ])),
          Row(
            children: <Widget>[
              Container(
                height: 180,
                width: 190,
                child: Stack(children: <Widget>[
                  Ink.image(
                    image: AssetImage("graphics/front_page.jpg"),
                    fit: BoxFit.cover,
                    child: InkWell(
                      onTap: () => _openGallery(context, GalleryFilter.IMGUR_FRONT_PAGE),
                    ),
                  ),
                  _frontPageText()
                ]),
              ),
            ],
          ),
          Container(
              color: Colors.grey.shade400,
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Container(
                  child: Text(
                    "TAGS",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  padding: EdgeInsets.all(12),
                )
              ])),
          SizedBox(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _vm.tags.length,
                  itemBuilder: (context, position) {
                    var tag = _vm.tags[position];

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                            width: max((tag.displayName.length * 17).toDouble(), 120),
                            child: Stack(
                              children: <Widget>[
                                Ink.image(
                                  image: NetworkImage('https://i.imgur.com/${tag.backgroundHash}t.jpg'),
                                  fit: BoxFit.cover,
                                  child: InkWell(
                                    onTap: () => {},
                                  ),
                                ),
                                Container(
                                  child: _tagText(tag),
                                  alignment: Alignment.bottomRight,
                                )
                              ],
                            ))
                      ],
                    );
                  }))
        ],
      )),
    );
  }

  Widget _frontPageText() {
    return Container(
        color: Color(0x19000000),
        child: Text(
          "Front Page",
          textAlign: TextAlign.right,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 40, letterSpacing: 2),
        ));
  }

  Widget _tagText(GalleryTag tag) {
    return SizedBox(
        width: double.infinity,
        child: Container(
            color: Color(0x19000000),
            child: Text(
              tag.displayName,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20, letterSpacing: 2),
            )));
  }

  void _openGallery(BuildContext context, GalleryFilter filter) {
    StoreProvider.of<AppState>(context).dispatch(UpdateFilterAction(filter));
    Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryPageContainer()));
  }
}
