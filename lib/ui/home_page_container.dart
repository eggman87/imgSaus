
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/ui/home_page.dart';
import 'package:redux/redux.dart';

class HomePageContainer extends StatelessWidget {

  HomePageContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModel>(

      converter: (store) => HomeViewModel.fromStore(store),
      builder: (context, vm) {
        return HomePage(vm);
      },
    );
  }
}

class HomeViewModel {

  HomeViewModel();

  static fromStore(Store<AppState> store) {
    return HomeViewModel();
  }
}