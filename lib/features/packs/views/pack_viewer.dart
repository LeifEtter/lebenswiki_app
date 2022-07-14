import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/common/components/nav/top_nav.dart';
import 'package:lebenswiki_app/features/packs/helper/evaluating_elements.dart';
import 'package:lebenswiki_app/features/packs/models/pack_content_models.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';

class PackViewer extends StatefulWidget {
  final Pack pack;

  const PackViewer({
    Key? key,
    required this.pack,
  }) : super(key: key);

  @override
  State<PackViewer> createState() => _PackViewerState();
}

class _PackViewerState extends State<PackViewer> {
  int currentPage = 0;
  late Pack pack;
  late double progressBarWidth;
  late double indicatorSectionWidth;

  @override
  void initState() {
    pack = widget.pack;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressBarWidth = MediaQuery.of(context).size.width - 40;
    indicatorSectionWidth = progressBarWidth / (pack.pages.length);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, bottom: 10.0),
            child: TopNav(pageName: widget.pack.title, backName: "Packs"),
          ),
          const SizedBox(height: 50),
          Expanded(
            child: SizedBox(
              height: 500,
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                children: List.generate(pack.pages.length,
                    (index) => _buildPage(pack.pages[index])),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, top: 50),
            child: _buildProgressBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(CreatorPage pageData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        color: Colors.white,
        elevation: 2.0,
        child: ListView(
          padding: const EdgeInsets.only(top: 0),
          children: [
            _topRow(),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 5.0),
              shrinkWrap: true,
              itemCount: pageData.items.length,
              itemBuilder: (BuildContext context, int index) {
                return evalPageElement(pageData.items[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _topRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 15.0, right: 15.0),
          child: Icon(
            Icons.bookmark,
            size: 40.0,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 10,
      width: progressBarWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.black26,
      ),
      child: Row(
        children: [
          AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: const Color.fromRGBO(115, 148, 192, 1),
            ),
            //Fix indicator section width
            width: indicatorSectionWidth * (currentPage + 1),
            height: 10,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
