import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/account_image.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:imgsrc/ui/account_page_container.dart';

class AccountPage extends StatefulWidget {
  AccountPage(this.viewModel, {Key key}) : super(key: key);

  final AccountViewModel viewModel;

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {

  AccountViewModel viewModel;
  Store<AppState> store;
  final scrollController = ScrollController();
  var currentPage = 1;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          if (!viewModel.accountImages.hasLoadedAll) {
            store.dispatch(LoadAccountImagesAction(currentPage++));
          }
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    if (store == null) {
      store = StoreProvider.of<AppState>(context);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Account")),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    viewModel = widget.viewModel;

    if (viewModel.account == null) {
      return Container();
    }

    final account = viewModel.account;
    final cover = account.cover ??
        "https://i.imgur.com/SzQGbZV_d.jpg?maxwidth=2560&fidelity=grand";

    return Column(
      children: [
        IntrinsicHeight(
          child: Stack(
            children: [
              Image(
                  width: MediaQuery.of(context).size.width,
                  height: 240,
                  fit: BoxFit.fill,
                  image: NetworkImageWithRetry(cover)),
              Positioned(
                  bottom: 8,
                  left: 8,
                  child: Text(
                    account.url,
                    style: TextStyle(fontSize: 36, color: Colors.white),
                  )),
              Center(
                child: Image(
                    width: 80,
                    height: 80,
                    image: NetworkImageWithRetry(account.avatar)),
              )
            ],
          ),
        ),
        Expanded(
            child: DefaultTabController(
                length: 2,
                child: Container(
                    color: Colors.black87,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Colors.white,
                          indicatorColor: Colors.redAccent,
                          tabs: [
                            Tab(
                              text: "images",
                            ),
                            Tab(
                              text: "albums",
                            )
                          ],
                        ),
                        Expanded(
                            child: TabBarView(children: [
                              accountImagesGrid(),
                              pageTwo(),
                            ]))
                      ],
                    ))))
      ],
    );
  }

  Widget accountImagesGrid() {
    final images = viewModel.accountImages.images ?? [];

    // return Container(color: Colors.black);
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: images.length,
      itemBuilder: accountImageBuilder(images),
      controller: scrollController,
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(2, index.isEven ? 2 : 1),
    );
  }

  Widget Function(BuildContext context, int index) accountImageBuilder(
      List<AccountImage> images) {
    return (context, position) {
      final image = images[position];

      final thumb = "http://i.imgur.com/${image.id}m.jpg";

      return Container(
        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
        child: Image(
            fit: BoxFit.cover,
            image: NetworkImageWithRetry(thumb)
        ),
      );
    };
  }
}

Widget pageTwo() {
  return Container(color: Colors.yellow);
}
