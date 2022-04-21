import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/navigation/top_nav.dart';
import 'package:lebenswiki_app/components/pack/example_data.dart';
import 'package:lebenswiki_app/helper/packs/evaluating_elements.dart';

class PackPageView extends StatefulWidget {
  const PackPageView({Key? key}) : super(key: key);

  @override
  _PackPageViewState createState() => _PackPageViewState();
}

class _PackPageViewState extends State<PackPageView> {
  late List<Widget> pageList;
  int currentPage = 0;
  late double progressBarWidth;
  late double indicatorSectionWidth;

  @override
  Widget build(BuildContext context) {
    pageList = [
      _buildPage(ExampleData().pageData1),
      _buildPage(ExampleData().pageData2),
      _buildPage(ExampleData().pageData3),
    ];
    progressBarWidth = MediaQuery.of(context).size.width - 40;
    indicatorSectionWidth = progressBarWidth / (pageList.length - 1);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50.0, bottom: 100.0),
            child: TopNav(pageName: "Pack 1", backName: "Pack Liste"),
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
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.bookmark),
                ),
              ],
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.only(left: 20.0, right: 10.0, top: 20.0),
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
              color: Colors.blue,
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
