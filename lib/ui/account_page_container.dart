import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/model/account.dart';
import 'package:imgsrc/model/account_image.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/ui/account_page.dart';
import 'package:redux/redux.dart';

class AccountPageContainer extends StatelessWidget {

  AccountPageContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountViewModel>(
        builder: (context, vm) { return new AccountPage(vm);},
        converter: (store) => AccountViewModel.fromStore(store)
    );
  }

}

class AccountViewModel {
  final Account account;
  final LoadedAccountImages accountImages;
  final bool isLoading;

  AccountViewModel({@required this.account, @required this.isLoading, this.accountImages});

  static AccountViewModel fromStore(Store<AppState> store) {
    return AccountViewModel(
        account: store.state.currentAccount,
        isLoading: store.state.isLoadingGallery,
        accountImages: store.state.accountImages
    );
  }
}