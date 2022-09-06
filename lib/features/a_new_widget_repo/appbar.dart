import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/colors.dart';
import 'package:lebenswiki_app/repository/text_styles.dart';

SliverAppBar appBar() {
  return SliverAppBar(
    floating: true,
    title: const Padding(
      padding: EdgeInsets.only(top: 0),
      child: Text(
        "Lebenswiki",
        style: LebenswikiTextStyles.logoText,
      ),
    ),
    leadingWidth: 55,
    leading: Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Image.asset(
        "assets/icons/lebenswiki_icon.png",
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: IconButton(
          iconSize: 30,
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
      )
    ],
    backgroundColor: Colors.white,
  );
}

class SearchBar extends ConsumerStatefulWidget {
  final Function onChange;
  final TextEditingController searchController;

  const SearchBar({
    Key? key,
    required this.onChange,
    required this.searchController,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      pinned: true,
      title: CupertinoTextField(
        autofocus: false,
        prefix: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Icon(
            Icons.search,
            color: CustomColors.darkGrey,
          ),
        ),
        textAlignVertical: TextAlignVertical.center,
        placeholderStyle: TextStyle(
          fontSize: 15.0,
          color: CustomColors.darkGrey,
        ),
        placeholder: "Suche nach Artiken, Autoren oder Benutzern",
        onChanged: widget.onChange(),
        controller: widget.searchController,
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: CustomColors.lightGrey,
        ),
      ),
    );
  }
}
