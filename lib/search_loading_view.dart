import 'package:flutter/material.dart';

class SearchLoadingView extends StatelessWidget {
  const SearchLoadingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.center,
      child: CircularProgressIndicator(),
    );
  }
}
