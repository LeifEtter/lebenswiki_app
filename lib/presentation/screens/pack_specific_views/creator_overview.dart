import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/presentation/widgets/creator/pack_creator_page.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/repository/backend/pack_api.dart';
import 'package:lebenswiki_app/domain/models/pack_content_models.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/repository/constants/shadows.dart';

class CreatorOverview extends StatefulWidget {
  final Pack pack;

  const CreatorOverview({
    Key? key,
    required this.pack,
  }) : super(key: key);

  @override
  _CreatorOverviewState createState() => _CreatorOverviewState();
}

class _CreatorOverviewState extends State<CreatorOverview> {
  final PackApi packApi = PackApi();
  final PageController _viewController = PageController();
  late Pack pack;
  int _selectedPage = 0;
  List<Widget> pageViewPages = [];

  @override
  void initState() {
    pack = widget.pack;
    if (pack.pages.isEmpty) {
      pack.pages.add(PackPage(items: [], pageNumber: 1));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _initalizePageViewPages();
    return DefaultTabController(
      length: pageViewPages.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Seiten Bearbeiten",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            CupertinoButton(
              child: const Text("Speichern"),
              onPressed: () {
                _saveCallback();
                _saveToServer();
                setState(() {});
              },
            )
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            LebenswikiShadows.fancyShadow,
          ]),
          height: 130,
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 30, top: 10, left: 10, right: 10),
            child: _buildPageBar(),
          ),
        ),
        backgroundColor: Colors.white,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _viewController,
          children: pageViewPages,
        ),
      ),
    );
  }

  void _initalizePageViewPages() {
    pageViewPages = List.generate(
      pack.pages.length,
      ((index) => PageOverview(
            page: pack.pages[index],
            saveCallback: _saveCallback,
            saveSelf: _saveSelectedPageCallback,
            selfIndex: index,
            deleteSelf: _deletePage,
          )),
    );
  }

  void _reinitPageNumbers() {
    for (int i = 0; i < pack.pages.length; i++) {
      pack.pages[i].pageNumber = i + 1;
    }
  }

  void _saveCallback() {
    for (PackPage page in pack.pages) {
      for (PackPageItem item in page.items) {
        item.headContent.value = item.headContent.controller!.text;
        for (PackPageItemInput item in item.bodyContent) {
          item.value = item.controller!.text;
        }
      }
    }
  }

  void _saveToServer() async {
    Either<CustomError, String> updateResult =
        await PackApi().updatePack(id: pack.id!, pack: pack);
    updateResult.fold((left) {
      CustomFlushbar.error(message: left.error).show(context);
    }, (right) {
      CustomFlushbar.success(message: right).show(context);
    });
  }

  bool isPackSaved() {
    for (PackPage page in pack.pages) {
      for (PackPageItem item in page.items) {
        item.headContent.value = item.headContent.controller!.text;
        for (PackPageItemInput item in item.bodyContent) {
          if (item.value != item.controller!.text) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void _saveSelectedPageCallback(toSaveIndex) {
    PackPage pageToSave = pack.pages[toSaveIndex];
    for (PackPageItem item in pageToSave.items) {
      item.headContent.value = item.headContent.controller!.text;
      for (PackPageItemInput item in item.bodyContent) {
        item.value = item.controller!.text;
      }
    }
  }

  void _deletePage(int index) {
    pack.pages.removeAt(index);
    pageViewPages.removeAt(index);
    _animToPage(index - 1);
    _reinitPageNumbers();
    setState(() {
      _selectedPage = index - 1;
    });
  }

  Widget _buildPageBar() {
    return Center(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: pack.pages.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == pack.pages.length + 1) {
            if (_selectedPage == 0) {
              return Container();
            }
            return Padding(
              padding: const EdgeInsets.only(left: 30, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                        color: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [LebenswikiShadows.fancyShadow]),
                    child: IconButton(
                      color: Colors.black54,
                      onPressed: () => _deletePage(_selectedPage),
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
            child: GestureDetector(
              onTap: () {
                _saveCallback();
                if (index == pack.pages.length) {
                  pack.pages.add(PackPage(pageNumber: index + 1, items: []));
                }
                _animToPage(index);
                setState(() => _selectedPage = index);
              },
              child: _selectablePageImage(index),
            ),
          );
        },
      ),
    );
  }

  Widget _selectablePageImage(index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 50,
      decoration: BoxDecoration(
        color: index == _selectedPage ? Colors.blueAccent : Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [LebenswikiShadows.fancyShadow],
      ),
      child: Center(
        child: index != pack.pages.length
            ? Text(
                (index + 1).toString(),
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            : const Icon(Icons.add, size: 20.0),
      ),
    );
  }

  void _animToPage(index) => _viewController.animateToPage(index,
      duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
}
