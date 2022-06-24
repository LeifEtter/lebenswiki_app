import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/pack_api.dart';
import 'package:lebenswiki_app/api/short_api.dart';
import 'package:lebenswiki_app/features/shorts/components/short_card_scaffold.dart';
import 'package:lebenswiki_app/features/styling/input_styling.dart';
import 'package:lebenswiki_app/features/common/components/loading.dart';
import 'package:lebenswiki_app/models/enums.dart';

class SearchView extends StatefulWidget {
  final CardType cardType;

  const SearchView({
    Key? key,
    required this.cardType,
  }) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final ShortApi shortApi = ShortApi();
  final PackApi packApi = PackApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: widget.cardType == CardType.shortsByCategory
              ? shortApi.getAllShorts()
              : packApi.getAllPacks(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Loading();
            } else if (snapshot.data[1].length == 0) {
              return Center(
                child: Text(
                    "Keine ${widget.cardType == CardType.shortsByCategory ? "Shorts" : "Lernacks"} gefunden"),
              );
            } else {
              return FilterView(
                packList: snapshot.data[1],
                cardType: widget.cardType,
              );
            }
          }),
    );
  }
}

class FilterView extends StatefulWidget {
  final CardType cardType;
  final List packList;

  const FilterView({
    Key? key,
    required this.cardType,
    required this.packList,
  }) : super(key: key);

  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _key1 = GlobalKey();
  List _filteredPacks = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            CloseButton(),
          ],
        ),
        _buildSearchBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: (_filteredPacks.isEmpty)
                  ? widget.packList.length
                  : _filteredPacks.length,
              itemBuilder: (context, index) {
                var currentPack = (_filteredPacks.isEmpty)
                    ? widget.packList[index]
                    : _filteredPacks[index];
                return ShortCardScaffold(
                  short: currentPack,
                  voteReload: () {},
                  cardType: widget.cardType,
                  menuCallback: () {},
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0),
      child: AuthInputStyling(
        fillColor: const Color.fromRGBO(245, 245, 247, 1),
        child: TextFormField(
          onChanged: (value) {
            setState(() {
              _filteredPacks = _filterShorts(widget.packList, value);
            });
          },
          controller: _searchController,
          key: _key1,
          decoration: const InputDecoration(
            hintText: "Suche nach Artikeln oder Keywörtern...",
            icon: Padding(
              padding: EdgeInsets.only(left: 10.0, top: 5.0),
              child: Icon(
                Icons.search,
                size: 30.0,
                color: Color.fromRGBO(115, 115, 115, 1),
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  List _filterShorts(shortsList, query) {
    List queriedShorts = [];
    for (int i = 0; i < shortsList.length; i++) {
      var currentShort = shortsList[i];
      var shortTitle = currentShort["title"].toUpperCase();
      var shortContent = currentShort["content"].toUpperCase();
      if (shortTitle.contains(query.toUpperCase())) {
        queriedShorts.add(currentShort);
      } else if (shortContent.contains(query.toUpperCase())) {
        queriedShorts.add(currentShort);
      }
    }
    return queriedShorts;
  }

  void upvote(id) {
    //TODO implement upvoting through search
  }
}
