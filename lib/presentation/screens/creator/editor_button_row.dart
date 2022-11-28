import 'package:flutter/material.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/lebenswiki_icons.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';

class EditorButtonRow extends StatefulWidget {
  final int currentPageNumber;
  final List<int> pageNumbers;
  final Function(int) switchPage;
  final Function(ItemType) addItem;
  final Function addPage;

  const EditorButtonRow({
    Key? key,
    required this.currentPageNumber,
    required this.pageNumbers,
    required this.switchPage,
    required this.addItem,
    required this.addPage,
  }) : super(key: key);

  @override
  State<EditorButtonRow> createState() => _EditorButtonRowState();
}

class _EditorButtonRowState extends State<EditorButtonRow> {
  double animatedPickerHeight = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: _buildPagePickerWindow(),
        ),
        _buildButtonRow(),
      ],
    );
  }

  Widget _buildButtonRow() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: CustomColors.lightGrey,
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              widget.addItem(ItemType.title);
            },
            icon: const Icon(LebenswikiIcons.text_options, size: 20),
          ),
          IconButton(
            onPressed: () {
              widget.addItem(ItemType.text);
            },
            icon: const Icon(Icons.text_snippet_outlined, size: 25),
          ),
          IconButton(
            onPressed: () {
              widget.addItem(ItemType.list);
            },
            icon: const Icon(LebenswikiIcons.menu_bars, size: 20),
          ),
          IconButton(
            onPressed: () {
              widget.addItem(ItemType.image);
            },
            icon: const Icon(LebenswikiIcons.image, size: 20),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              widget.addPage();
            },
            icon: const Icon(LebenswikiIcons.add_document, size: 20),
          ),
          _buildPageButton(),
        ],
      ),
    );
  }

  Widget _buildPagePickerWindow() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: animatedPickerHeight,
        decoration: BoxDecoration(
          color: CustomColors.offBlack,
        ),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 10),
          shrinkWrap: true,
          children: widget.pageNumbers
              .map((int pageNr) => _pagePickerButton(pageNr))
              .toList(),
        ),
      ),
    );
  }

  Widget _pagePickerButton(int pageNr) {
    return GestureDetector(
      onTap: () {
        animatedPickerHeight = 0;
        widget.switchPage(pageNr);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        decoration: BoxDecoration(
            color: pageNr == widget.currentPageNumber
                ? CustomColors.textMediumGrey
                : CustomColors.offBlack,
            border: Border(
                bottom: BorderSide(
              color: CustomColors.greySeperator,
              width: 2,
            ))),
        child: Center(
          child: Text("S${pageNr.toString()}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              )),
        ),
      ),
    );
  }

  Widget _buildPageButton() {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.offBlack,
        borderRadius: BorderRadius.circular(15.0),
      ),
      width: 80,
      height: 50,
      child: TextButton(
        onPressed: () {
          setState(() {
            animatedPickerHeight == 0
                ? animatedPickerHeight = 180
                : animatedPickerHeight = 0;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('S${widget.currentPageNumber}',
                style: const TextStyle(color: Colors.white)),
            const Icon(
              Icons.keyboard_arrow_up_rounded,
              size: 30,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
