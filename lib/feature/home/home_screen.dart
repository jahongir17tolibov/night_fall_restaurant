import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:night_fall_restaurant/feature/home/bloc/home_bloc.dart';

import '../../core/theme/theme_manager.dart';
import '../../utils/custom_tab_bar_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

ThemeManager _themeManager = ThemeManager();

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: false);
  late AnimationController _animateController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeOnGetMenuListEvent());
    _animateController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final double itemHeight = orientation == Orientation.portrait
        ? (size.height - kToolbarHeight - 24) / 2.45
        : (size.height - kToolbarHeight - 24) / 2.25;
    final double itemWidth =
        orientation == Orientation.portrait ? size.width / 2 : size.height / 4;

    // setupScrollController(gridItemHeight: itemHeight);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        actions: const [],
        title: Text(
          'Night Fall Restaurant',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state is HomeLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeSuccessState) {
          //for set categories name to tab
          final categories = state.response
              .map((getProductsList) {
                return getProductsList.menu_categories.map(
                  (category) {
                    return Tab(text: category.category_name);
                  },
                );
              })
              .expand((element) => element)
              .toList();
          //ui🗿
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TabBar(
                tabs: categories,
                controller: TabController(
                  animationDuration: const Duration(milliseconds: 400),
                  length: categories.length,
                  vsync: this,
                  initialIndex: _selectedTabIndex,
                ),
                physics: const ClampingScrollPhysics(),
                isScrollable: true,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onSurfaceVariant,
                splashBorderRadius:
                    const BorderRadius.all(Radius.circular(120.0)),
                indicator:
                    CustomTabIndicator(Theme.of(context).colorScheme.primary),
                indicatorPadding: const EdgeInsets.all(4.0),
                indicatorSize: TabBarIndicatorSize.tab,
                automaticIndicatorColorAdjustment: true,
                dividerColor: Colors.transparent,
                onTap: (categoryIndex) {
                  setState(() {
                    _selectedTabIndex = categoryIndex;
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.response.length,
                  physics: Platform.isIOS
                      ? const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast)
                      : const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast),
                  itemBuilder: (context, index) {
                    final getProductsList = state.response[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      orientation == Orientation.portrait
                                          ? 2
                                          : 4,
                                  childAspectRatio: (itemWidth / itemHeight),
                                  mainAxisSpacing: 6.0),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.all(10.0),
                          controller: _scrollController,
                          itemCount: getProductsList.menu_products.length,
                          itemBuilder: (context, itemIndex) {
                            final item =
                                getProductsList.menu_products[itemIndex];
                            final itemSize = gridItemView(
                              name: item.name,
                              price: item.price,
                              image: item.image,
                              weight: item.weight,
                              orientation: orientation,
                              context: context,
                            );
                            // return Container()
                            return itemSize;
                          },
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ));
        } else if (state is HomeErrorState) {
          return Center(
            child: Text(
              state.error,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        } else {
          return Container();
        }
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.shopping_cart_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () async {
          // await addMenuToFireStore();
        },
      ),
    );
  }

  static Text gridItemText({
    required String text,
    required double fontSize,
    required FontWeight fontWeight,
    required Color textColor,
    required BuildContext context,
  }) =>
      Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontFamily: 'Ktwod',
          fontWeight: fontWeight,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );

  Widget gridItemView({
    required String name,
    required String price,
    required String image,
    required String weight,
    required Orientation orientation,
    required BuildContext context,
  }) {
    return Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(14.0),
                child: CachedNetworkImage(
                  imageUrl: image,
                  width: MediaQuery.of(context).size.width,
                  height: 140.0,
                  fit: BoxFit.fill,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                    color: Theme.of(context).colorScheme.tertiary,
                  )),
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //product`s price text
                  gridItemText(
                    text: price,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    context: context,
                  ),
                  //product name text
                  gridItemText(
                    text: name,
                    fontSize: 13.0,
                    fontWeight: FontWeight.normal,
                    textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    context: context,
                  ),
                  const SizedBox(height: 12),
                  //product weight text
                  gridItemText(
                    text: weight,
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                    textColor: Theme.of(context).colorScheme.outline,
                    context: context,
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton.icon(
                    onPressed: () async {},
                    icon: Icon(
                      Icons.add_rounded,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.tertiary,
                      ),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width,
                        ),
                      )),
                      minimumSize:
                          const MaterialStatePropertyAll(Size.fromHeight(36.0)),
                    ),
                    label: gridItemText(
                      text: "Qo'shish",
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                      textColor: Theme.of(context).colorScheme.onTertiary,
                      context: context,
                    ),
                  ),
                ],
              ))
            ],
          ),
        ));
  }
}
