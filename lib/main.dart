import 'package:flutter/material.dart';
import 'package:imgsrc/middleware/imgur_middleware.dart';
import 'package:imgsrc/reducers/app_state_reducer.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/ui/home_page.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';


void main() => runApp(ReduxApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'imgSaus',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
//      routes: {'/': (context) => MyHomePage(title: 'imgSaus',)},
    );
  }
}

class ReduxApp extends StatelessWidget {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.loading(),
    middleware: createImgurMiddleware(),
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'imgSaus',
        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        initialRoute: '/',
        routes: {'/': (context) => MyHomePage()}
      ),
    );
  }
}


