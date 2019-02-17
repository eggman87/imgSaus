import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/gallery_models.dart';
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
        child: Row(
          children: <Widget>[
            Card(
              child: Container(
                height: 180,
                width: MediaQuery.of(context).size.width - 16,
                child: Stack(children: <Widget>[
                  Ink.image(
                    image: AssetImage("graphics/front_page.png"),
                    fit: BoxFit.cover,
                    child: InkWell(
                      onTap: () => _openGallery(context, GalleryFilter.IMGUR_FRONT_PAGE),
                    ),
                  ),
                  _frontPageText()
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _frontPageText() {
    return Text(
      "Front Page",
      textAlign: TextAlign.right,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 40, letterSpacing: 2, shadows: [
        Shadow(
            // bottomLeft
            offset: Offset(-1.5, -1.5),
            color: Colors.black),
        Shadow(
            // bottomRight
            offset: Offset(1.5, -1.5),
            color: Colors.black),
        Shadow(
            // topRight
            offset: Offset(1.5, 1.5),
            color: Colors.black),
        Shadow(
            // topLeft
            offset: Offset(-1.5, 1.5),
            color: Colors.black),
      ]),
    );
  }

  void _openGallery(BuildContext context, GalleryFilter filter) {
    StoreProvider.of<AppState>(context).dispatch(UpdateFilterAction(filter));
    Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryPageContainer()));
  }
}
