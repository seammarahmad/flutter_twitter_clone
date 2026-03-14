import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/Views/Explore/controller/explore_controller.dart';
import 'package:flutter_twitter_clone/Views/Explore/widgets/search_tile.dart';
import 'package:flutter_twitter_clone/core/utils.dart';
import 'package:flutter_twitter_clone/theme/pallete.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final searchController = TextEditingController();
  bool _isSearching = false;
  String _currentQuery = '';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  void _onSearch(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _isSearching = false;
        _currentQuery = '';
      });
      return;
    }
    setState(() {
      _isSearching = true;
      _currentQuery = trimmed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: searchController,
            onSubmitted: _onSearch,
            onChanged: (v) {
              if (v.isEmpty) {
                setState(() {
                  _isSearching = false;
                  _currentQuery = '';
                });
              }
            },
            decoration: InputDecoration(
              hintText: 'Search Here',
              hintStyle: TextStyle(color: Pallete.greyColor),
              contentPadding: EdgeInsets.all(10).copyWith(left: 20),
              fillColor: Pallete.searchBarColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Pallete.searchBarColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Pallete.searchBarColor),
              ),
            ),
          ),
        ),
      ),

      body:_isSearching? ref
          .watch(searchUserProvider(searchController.text))
          .when(
            data: (users) {
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  final user = users[index];
                  return SearchTile(userModel: user);
                },
              );
            },
            error: (error, stackTrace) => ErrorMessage(error: error.toString()),
            loading: () => Loader(),
          ):SizedBox(),
    );
  }
}
