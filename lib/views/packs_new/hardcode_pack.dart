import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/navigation/top_nav.dart';
import 'package:lebenswiki_app/data/colors.dart';
import 'package:lebenswiki_app/helper/packs/evaluating_elements.dart';

class PackPageView extends StatefulWidget {
  final List packData;

  const PackPageView({
    Key? key,
    required this.packData,
  }) : super(
          key: key,
        );

  @override
  _PackPageViewState createState() => _PackPageViewState();
}

class _PackPageViewState extends State<PackPageView> {
  List<Widget> pageList = [];
  int currentPage = 0;
  late double progressBarWidth;
  late double indicatorSectionWidth;

  @override
  void initState() {
    super.initState();
    for (List pageData in widget.packData) {
      pageList.add(
        _buildPage(pageData),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    progressBarWidth = MediaQuery.of(context).size.width - 40;
    indicatorSectionWidth = progressBarWidth / (pageList.length - 1);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50.0, bottom: 100.0),
            child: TopNav(pageName: "Investieren", backName: "Packs"),
          ),
          Expanded(
            child: SizedBox(
              height: 500,
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                children: pageList,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0, top: 100),
            child: _buildProgressBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(List pageData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        color: Colors.white,
        elevation: 2.0,
        child: Column(
          children: [
            Row(
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
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 5.0),
              shrinkWrap: true,
              itemCount: pageData.length,
              itemBuilder: (BuildContext context, int index) {
                return evalPageElement(pageData[index]);
              },
            ),
          ],
        ),
      ),
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
            width: indicatorSectionWidth * currentPage,
            height: 10,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
