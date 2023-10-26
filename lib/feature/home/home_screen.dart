import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:night_fall_restaurant/feature/home/bloc/home_bloc.dart';
import 'package:night_fall_restaurant/utils/helpers.dart';
import 'package:night_fall_restaurant/utils/ui_components/shimmer_gradient.dart';
import 'package:night_fall_restaurant/utils/ui_components/standart_text.dart';

import '../../utils/constants.dart';
import '../../utils/ui_components/custom_tab_bar_indicator.dart';
import '../../utils/ui_components/on_back_navigate.dart';
import '../../utils/ui_components/skeleton_for_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.tableNumber});

  final String tableNumber;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

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

  final List<String> categories = [
    'Milliy taomlar',
    'Turk taomlari',
    'Salatlar',
    'Nonlar',
    'Ichimliklar',
  ];

  @override
  Widget build(BuildContext context) {
    final size = fillMaxSize(context);
    final orientation = MediaQuery.of(context).orientation;
    final double itemHeight = orientation == Orientation.portrait
        ? (size.height - kToolbarHeight - 24) / 2.40
        : (size.height - kToolbarHeight - 24) / 2.15;
    final double itemWidth =
        orientation == Orientation.portrait ? size.width / 2 : size.height / 4;
    // setupScrollController(gridItemHeight: itemHeight);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        leading: onBackNavigate(context, tableRoute),
        actions: <Widget>[
          TextView(
            text: widget.tableNumber,
            textColor: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(width: 20.0),
        ],
        title: Text(
          'Night Fall Restaurant',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(HomeOnRefreshEvent());
        },
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        strokeWidth: 3.0,
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is HomeLoadingState) {
            return const Center(child: Skeleton());
          } else if (state is HomeSuccessState) {
            //for set categories name to tab
            final categoriesList = state.menuCategories.map((it) {
              return Tab(text: it.categoryName);
            }).toList();
            //ui🗿
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TabBar(
                  tabs: categoriesList,
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
                    child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                    childAspectRatio: (itemWidth / itemHeight),
                  ),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: Platform.isIOS
                      ? const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast)
                      : const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast),
                  padding: const EdgeInsets.all(10.0),
                  controller: _scrollController,
                  itemCount: state.response.length,
                  itemBuilder: (context, itemIndex) {
                    // sort data by category id
                    final productsSortedList = state.response
                      ..sort((it, data) => it.productCategoryId
                          .compareTo(data.productCategoryId));
                    // indexing sorted data
                    final item = productsSortedList[itemIndex];
                    final gridItem = _gridItemView(
                      name: item.name,
                      price: item.price,
                      image: item.image,
                      weight: item.weight,
                      orientation: orientation,
                    );
                    return gridItem;
                  },
                )),
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
      ),
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

  static Text _gridItemText({
    required String text,
    required double fontSize,
    required FontWeight fontWeight,
    required Color textColor,
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

  Widget _gridItemView({
    required String name,
    required String price,
    required String image,
    required String weight,
    required Orientation orientation,
  }) {
    ElevatedButton addToCartButton = ElevatedButton.icon(
      onPressed: () async {},
      icon: Icon(
        Icons.add_rounded,
        color: Theme.of(context).colorScheme.onTertiary,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(fillMaxWidth(context)),
        ),
        minimumSize: Size(fillMaxWidth(context), 36.0),
        elevation: 4.0,
      ),
      label: _gridItemText(
        text: "Qo'shish",
        fontSize: 13.0,
        fontWeight: FontWeight.normal,
        textColor: Theme.of(context).colorScheme.onTertiary,
      ),
    );
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
                  width: fillMaxWidth(context),
                  height: 140.0,
                  fit: BoxFit.fill,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Container(
                    decoration: BoxDecoration(
                      gradient: shimmerEffect(
                        context,
                        AnimationController(
                          vsync: this,
                          duration: const Duration(seconds: 1),
                        )..repeat(reverse: true),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //product`s price text
                  _gridItemText(
                    text: price,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  //product name text
                  _gridItemText(
                    text: name,
                    fontSize: 13.0,
                    fontWeight: FontWeight.normal,
                    textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 12),
                  //product weight text
                  _gridItemText(
                    text: weight,
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                    textColor: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 4),
                  addToCartButton /* add to cart button */,
                ],
              ))
            ],
          ),
        ));
  }
}
