import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_github/github_api.dart';

class SearchModel extends Model {
  final GithubApi _api;
  SearchState _state;
  SearchResult _result;
  Timer _debounceTimer;
  CancelableOperation<SearchResult> _operation;

  SearchModel({GithubApi api, SearchState state = SearchState.noTerm})
      : _state = state,
        _api = api ?? GithubApi();

  void search(String term) {
    // If there's no term, reset to a "No Term" state.
    if (term.isEmpty) {
      state = SearchState.noTerm;
      result = null;
      return;
    }

    // Cancel any of our pending operations! This will do two things:
    //   1. The first line will cancel the last request that haven't started
    //   2. The second line cancels any previous requests that have started but
    //      have not completed
    _debounceTimer?.cancel();
    _operation?.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      // Reset the Model to a loading state
      state = SearchState.loading;
      result = null;

      print("Searching For: $term");

      _operation = CancelableOperation.fromFuture(_api.search(term));
      try {
        final _result = await _operation.value;

        // If the api returns no search results, show an "Empty" screen
        if (_result.isEmpty) {
          state = SearchState.empty;
          result = null;
        } else {
          // Otherwise, show the populated screen with the results!
          state = SearchState.populated;
          result = _result;
        }
      } catch (e) {
        // If an error occurs, switch to an "Error" state.
        state = SearchState.error;
        result = null;
      }
    });
  }

  SearchResult get result => _result;

  set result(SearchResult result) {
    _result = result;
    notifyListeners();
  }

  SearchState get state => _state;

  set state(SearchState state) {
    _state = state;
    notifyListeners();
  }

  static SearchModel of(BuildContext context) {
    return ScopedModel.of<SearchModel>(context, rebuildOnChange: true);
  }
}

enum SearchState { loading, error, noTerm, populated, empty }
