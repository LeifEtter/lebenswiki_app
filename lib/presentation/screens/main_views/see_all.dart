import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/domain/models/short_model.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';

class SeeAllView extends ConsumerStatefulWidget {
  final bool isShorts;
  final List<Pack>? packs;
  final List<Short>? shorts;

  const SeeAllView({
    Key? key,
    this.isShorts = false,
    this.packs = const [],
    this.shorts = const [],
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeeAllViewState();
}

class _SeeAllViewState extends ConsumerState<SeeAllView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TopNavIOS(title: "Irgendwas"),
      ],
    );
  }
}
