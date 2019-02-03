import 'package:flutter/material.dart';
import 'package:imgsrc/comments_bottom_sheet.dart';
import 'package:imgsrc/gallery_album_index_state.dart';
import 'package:imgsrc/gallery_repository.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:swipedetector/swipedetector.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //current state of gallery items.
  GallerySection _currentSection = GallerySection.hot;
  GallerySort _currentSort = GallerySort.viral;
  GalleryWindow _currentWindow = GalleryWindow.day;
  int _currentPage = 1;

  //the below `_current` properties refer to state of the current index of the PageView
  int _pagePosition = 0;
  GalleryAlbumIndexState _pageAlbumState = GalleryAlbumIndexState();

  Map<int, VideoPlayerController> _controllers = new Map();
  List<GalleryItem> _galleryItems = new List<GalleryItem>();

  @override
  void initState() {
    super.initState();

    _loadGalleryItems();
  }

  void _loadGalleryItems() {
    GalleryRepository repostiory = new GalleryRepository();
    repostiory.getItems(_currentSection, _currentSort, _currentWindow, _currentPage).then((it) {
      setState(() {
        if (it.isOk()) {
          _galleryItems.addAll(it.body);
        }
      });
    });
  }

  void _loadNextPage() {
    _currentPage++;
    _loadGalleryItems();
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
              Row(
                children: <Widget>[
                  Visibility(
                      visible: _galleryItems.length > 0,
                      child: Text("  Currently viewing ${_pagePosition + 1}/${_galleryItems.length}"))
                ],
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
                  Text(
                    "hot",
                    style: _selectableStyle(_currentSection == GallerySection.hot),
                  ),
                  Spacer(),
                  Text(
                    "top",
                    style: _selectableStyle(_currentSection == GallerySection.top),
                  ),
                  Spacer(),
                  Text(
                    "User",
                    style: _selectableStyle(_currentSection == GallerySection.user),
                  ),
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
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    _galleryItemTitle(),
                    maxLines: 6,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: SwipeDetector(
                    child: GestureDetector(
                      child: _pageView(),
                      onLongPress: _onLongPress,
                    ),
                    onSwipeUp: _onSwipeUp,
                    onSwipeDown: _onSwipeDown,
                    swipeConfiguration: SwipeConfiguration(
                      verticalSwipeMinVelocity: 10.0,
                      verticalSwipeMinDisplacement: 10.0,
                    ),
                  ),
                ),
              ],
            ),
          )),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
          onPressed: () => this._onCommentsTapped(context),
          tooltip: 'View Comments',
          child: Icon(Icons.message),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: new Icon(Icons.album), title: Text("Gallery")),
        BottomNavigationBarItem(icon: new Icon(Icons.photo), title: Text("My Saus")),
        BottomNavigationBarItem(icon: new Icon(Icons.person), title: Text("Social Saus"))
      ]),
    );
  }

  TextStyle _selectableStyle(bool isSelected) {
    if (isSelected) {
      return TextStyle(color: Colors.green);
    } else {
      return TextStyle(color: Colors.black);
    }
  }

  String _galleryItemTitle() {
    if (_galleryItems.length > 0) {
      GalleryItem item = _currentGalleryItem();
      String title = item.title;
      if (item.isAlbumWithMoreThanOneImage()) {
        title += " (${_pageAlbumState.albumPositionForIndex(_pagePosition) + 1}/${item.images.length})";
      }
      return title;
    }
    return "";
  }

  PageView _pageView() {
    return PageView.builder(
      pageSnapping: true,
      itemBuilder: (context, position) {
        GalleryItem currentItem = _galleryItems[position];
        String imageUrl = currentItem.pageUrl();
        if (currentItem.isAlbumWithMoreThanOneImage()) {
          //this loads items to left and right so we need to make sure our current album index is for this item when loading images.
          imageUrl = currentItem.images[_pageAlbumState.albumPositionForIndex(position)].pageUrl();
        }

        if (imageUrl.contains(".mp4")) {
          VideoPlayer player;
          VideoPlayerController controller = _controllers[position];

          if (controller == null) {
            VideoPlayerController controller = VideoPlayerController.network(imageUrl);
            _controllers[position] = controller;

            player = VideoPlayer(controller);
            controller.setLooping(true);
            controller.setVolume(0);

            controller.initialize().then((_) {
              controller.play();
            });
          } else {
            player = VideoPlayer(controller);
          }

          return player;
        } else {
          return Image.network(imageUrl);
        }
      },
      itemCount: _galleryItems.length,
      onPageChanged: _onPageChanged,
    );
  }

  void _onCommentsTapped(BuildContext context) {
    GalleryItem currentItem = _currentGalleryItem();
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return CommentsSheet(
            galleryItemId: currentItem.id,
            key: Key(currentItem.id),
          );
        });
  }

  void _onSwipeUp() {
    GalleryItem item = _currentGalleryItem();

    if (item.isAlbumWithMoreThanOneImage() &&
        _pageAlbumState.albumPositionForIndex(_pagePosition) < item.images.length - 1) {
      setState(() {
        _pageAlbumState.incrementPositionForIndex(_pagePosition);
      });
    }
  }

  void _onSwipeDown() {
    GalleryItem item = _currentGalleryItem();

    if (item.isAlbumWithMoreThanOneImage() && _pageAlbumState.albumPositionForIndex(_pagePosition) > 0) {
      setState(() {
        _pageAlbumState.decrementPositionForIndex(_pagePosition);
      });
    }
  }

  void _onLongPress() {

  }

  GalleryItem _currentGalleryItem() {
    if (_galleryItems.length > 0) {
      return _galleryItems[_pagePosition];
    }
    return null;
  }

  void _onPageChanged(int position) {
    setState(() {
      GalleryItem item = _galleryItems[position];
      if (item.isAlbum) {
        _pageAlbumState.startTrackingNewIndex(position);
      }
      _pagePosition = position;
    });
    if (position == _galleryItems.length) {
      _loadNextPage();
    }

    _controllers.forEach((key, controller) {
      if (key == position) {
        controller.play();
      }
      if (position - key > 4 || key - position > 4) {
        //indicates this controller is for a video > 4 pages away
        controller.dispose();
        _controllers.remove(key);
      }
    });
  }
}
