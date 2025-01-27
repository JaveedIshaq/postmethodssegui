import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile/generated/locale_keys.g.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen._();

  /// Creates a [MaterialPageRoute] that navigates to a [SearchScreen] widget.
  ///
  /// This method is used to create a route for navigating to the [SearchScreen] widget.
  /// It returns a [MaterialPageRoute] that builds the [SearchScreen] widget using a
  /// constant instance of [SearchScreen]. The route is created using the [builder]
  /// parameter of [MaterialPageRoute], which takes a function that builds the
  /// widget tree for the route. The function passed to the [builder] parameter
  /// returns a constant instance of [SearchScreen].
  ///
  /// Returns:
  /// A [MaterialPageRoute] that navigates to a [SearchScreen] widget.
  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => const SearchScreen._());
  }

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = TextEditingController();

  String get _text => _textController.text.trim();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.searchCity.tr(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: _textController,
                      onEditingComplete: () {
                        Navigator.of(context).pop(_text);
                      },
                      decoration: InputDecoration(
                        labelText: LocaleKeys.city.tr(),
                        hintText: 'Karachi',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  key: const Key('searchPage_search_iconButton'),
                  icon: const Icon(Icons.search, semanticLabel: 'Submit'),
                  onPressed: () => Navigator.of(context).pop(_text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
