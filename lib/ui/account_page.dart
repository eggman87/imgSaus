import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:imgsrc/ui/account_page_container.dart';

class AccountPage extends StatelessWidget {
  AccountPage(this.viewModel, {Key key}) : super(key: key);

  final AccountViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account")),
      body: _body(),
    );
    if (viewModel.account != null) {
      return Text(viewModel.account.url);
    } else {
      return Container(
        color: Colors.blue,
      );
    }
  }

  Widget _body() {
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
              Image(image: NetworkImageWithRetry(cover)),
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
        Expanded( child:
          DefaultTabController(
            length: 2,
                child: Container(
                    color: Colors.black26,
                    child: Column(
                      children: [
                        TabBar(
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
                          pageOne(),
                          pageTwo(),
                        ]))
                      ],
                    ))
          ))
      ],
    );
  }
}

Widget pageOne() {
  // return Gridvi
  return Container(color: Colors.black);
}

Widget pageTwo() {
  return Container(color: Colors.yellow);
}