import 'package:flutter/material.dart';
import 'package:scoped_model_github/search_empty_view.dart';
import 'package:scoped_model_github/search_error_view.dart';
import 'package:scoped_model_github/search_intro_view.dart';
import 'package:scoped_model_github/search_loading_view.dart';
import 'package:scoped_model_github/search_model.dart';
import 'package:scoped_model_github/search_result_view.dart';

// The View in a Stream-based architecture takes two arguments: The State Stream
// and the onTextChanged callback. In our case, the onTextChanged callback will
// emit the latest String to a Stream<String> whenever it is called.
//
// The State will use the Stream<String> to send new search requests to the
// GithubApi.
class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  SearchScreenState createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final model = SearchModel.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 4.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search Github...',
                  ),
                  style: TextStyle(
                    fontSize: 36.0,
                    fontFamily: "Hind",
                    decoration: TextDecoration.none,
                  ),
                  onChanged: model.search,
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 350),
                  child: _modelToVisible(model),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  static Widget _modelToVisible(SearchModel model) {
    switch (model.state) {
      case SearchState.empty:
        return SearchEmptyView();
      case SearchState.loading:
        return SearchLoadingView();
      case SearchState.error:
        return SearchErrorView();
      case SearchState.populated:
        return SearchResultView(
          key: ValueKey(model.result.hashCode),
          items: model.result.items,
        );
      case SearchState.noTerm:
      default:
        return SearchIntroView();
    }
  }
}
