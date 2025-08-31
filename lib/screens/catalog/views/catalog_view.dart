import 'package:flutter/material.dart';

import '../../../features/home/screens/aster_theme_home_screen.dart';
import '../../../features/home/widgets/search_home_page_widget.dart';
import '../../../features/search_product/screens/search_product_screen.dart';
import '../widgets/category_grid_widget.dart';

class CatalogView extends StatefulWidget {
  const CatalogView({super.key});

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: CustomScrollView(controller: _scrollController, slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: SliverDelegate(
                child: InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SearchScreen())),
                  child: const Hero(
                      tag: 'search',
                      child: Material(child: SearchHomePageWidget())),
                ),
              )),
          const SliverToBoxAdapter(child: CategoryGridWidget())
        ])
        )
        );
  }
}
