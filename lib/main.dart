import 'package:flutter/material.dart';
import 'package:imgsrc/gallery_repository.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:photo_view/photo_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'imgsrc',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'imgsrc'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<int, VideoPlayerController> _controllers = new Map();
  List<GalleryItem> _galleryItems = new List<GalleryItem>(0);

  void _loadGalleryItems() {
    GalleryRepository repostiory = new GalleryRepository();
    repostiory
        .getItems(GallerySection.hot, GallerySort.viral, GalleryWindow.day, 1)
        .then((it) {
      setState(() {
        if (it.isOk()) {
          _galleryItems = it.body;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 120, 0),
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                child: Text("eggman87"),
              ),
              ListTile(
                title: Text(
                  "SECTION",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  Text("hot"),
                  Spacer(),
                  Text("top"),
                  Spacer(),
                  Text("User"),
                  Spacer(),
                ],
              ),
              ListTile(
                title: Text(
                  "SORT",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  Text("viral"),
                  Spacer(),
                  Text("top"),
                  Spacer(),
                  Text("time"),
                  Spacer(),
                  Text("rising"),
                  Spacer(),
                ],
              ),
            ],
          )),
      body: Container(
          color: Colors.black,
          child: Center(
              child: GestureDetector(
            onTap: _handleTap,
            child: PageView.builder(
              pageSnapping: true,
              itemBuilder: (context, position) {
                String imageUrl = _galleryItems[position].pageUrl();

                if (imageUrl.contains(".mp4")) {
                  VideoPlayerController controller =
                      VideoPlayerController.network(imageUrl);
                  _controllers[position] = controller;
                  VideoPlayer player = VideoPlayer(controller);
                  controller.setLooping(true);
                  controller.setVolume(0);
                  controller.initialize().then((_) {
                    controller.play();
                  });

                  return player;
                } else {
                  return PhotoView(imageProvider: NetworkImage(imageUrl));
                }
              },
              itemCount: _galleryItems.length,
              onPageChanged: _onPageChanged,
            ),
          ))),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadGalleryItems,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
            icon: new Icon(Icons.album), title: Text("Gallery")),
        BottomNavigationBarItem(
            icon: new Icon(Icons.photo), title: Text("My Stuff")),
        BottomNavigationBarItem(
            icon: new Icon(Icons.person), title: Text("Social"))
      ]),
    );
  }

  void _onPageChanged(int position) {
    _controllers.forEach((key, controller) {
      if (key == position) {
        controller.play();
      } else {
        controller.pause();
      }
    });
  }

  void _handleTap() {}

  @override
  void initState() {}
}
