import 'package:flutter/material.dart';
import 'package:imgsrc/middleware/imgur_middleware.dart';
import 'package:imgsrc/reducers/app_state_reducer.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/ui/home_page_container.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

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
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.loading(),
    middleware:_middlewareList()
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'imgSaus',
        theme: ThemeData(
          primarySwatch: Colors.red
        ),
        navigatorObservers: <NavigatorObserver>[observer],
        initialRoute: '/',
        routes: {
          '/': (context) => HomePageContainer(title: "imgSaus",)
        }
      ),
    );
  }
}

dynamic _middlewareList() {
  var middleWare = createImgurMiddleware();
  assert(() {
    middleWare.add(LoggingMiddleware.printer());
    return true;
  }());
  return middleWare;
}


