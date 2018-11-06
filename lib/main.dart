import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_github/github_api.dart';
import 'package:scoped_model_github/search_model.dart';
import 'package:scoped_model_github/search_screen.dart';

void main(GithubApi api) {
  runApp(SearchApp(api: api));
}

class SearchApp extends StatefulWidget {
  final GithubApi api;

  SearchApp({Key key, this.api}) : super(key: key);

  @override
  _ScopedModelAppState createState() => _ScopedModelAppState();
}

class _ScopedModelAppState extends State<SearchApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RxDart Github Search',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
      ),
      home: ScopedModel<SearchModel>(
        model: SearchModel(),
        child: SearchScreen(),
      ),
    );
  }
}
