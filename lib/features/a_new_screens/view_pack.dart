import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';

class ViewPack extends ConsumerStatefulWidget {
  final Pack pack;
  final String heroName;

  const ViewPack({
    Key? key,
    required this.pack,
    required this.heroName,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewPackState();
}

class _ViewPackState extends ConsumerState<ViewPack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              pinned: true,
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.all(0),
                background: Hero(
                  tag: widget.heroName,
                  child: Image.network(
                    widget.pack.titleImage,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                title: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      )),
                ),
              ),
            )
          ];
        },
        body: Container(height: 2000),
      ),
    );
  }
}

/**
 * Hero(
            tag: widget.heroName,
            child: Image.network(widget.pack.titleImage),
          ),
 */
