// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:night_fall_restaurant/feature/home/bloc/home_bloc.dart';
import 'package:night_fall_restaurant/feature/orders/orders_screen.dart';
import 'package:night_fall_restaurant/utils/helpers.dart';
import 'package:night_fall_restaurant/utils/ui_components/cached_image_view.dart';
import 'package:night_fall_restaurant/utils/ui_components/custom_tab_bar_indicator.dart';
import 'package:night_fall_restaurant/utils/ui_components/error_widget.dart';
import 'package:night_fall_restaurant/utils/ui_components/show_snack_bar.dart';
import 'package:night_fall_restaurant/utils/ui_components/skeleton_for_shimmer.dart';
import 'package:night_fall_restaurant/utils/ui_components/standart_text.dart';

class HomeScreen extends StatefulWidget {
  static const ROUTE_NAME = "/home";

  static void open(BuildContext context) {
    Navigator.of(context).pushNamed(ROUTE_NAME);
  }

  static void close(BuildContext context) {
    Navigator.of(context).pop();
  }

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  late AnimationController _animateController;
  final List<bool> _buttonStates = [];
  final _isSelectedColor = const Color(0xFF166200);

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeOnGetMenuListEvent());
    _scrollController = ScrollController(keepScrollOffset: false);

    _tabController = TabController(
      length: context.watch<HomeBloc>().categoryTabLength,
      vsync: this,
    );

    _animateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

  }

  @override
  void dispose() {
    _animateController.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = fillMaxSize(context);
    final orientation = MediaQuery.of(context).orientation;
    final double itemHeight = orientation == Orientation.portrait
        ? (size.height - kToolbarHeight - 24) * 0.410
        : (size.height - kToolbarHeight - 24) * 0.450;
    final double itemWidth =
        orientation == Orientation.portrait ? size.width / 2 : size.height / 4;
    // setupScrollController(gridItemHeight: itemHeight);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () {
            context.read<HomeBloc>().add(HomeOnNavigateBackEvent());
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        title: TextView(
          text: 'Night Fall Restaurant',
          textColor: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(HomeOnRefreshEvent());
        },
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        strokeWidth: 3.0,
        child: BlocConsumer<HomeBloc, HomeState>(
          buildWhen: (previous, current) => current is! HomeActionState,
          listenWhen: (previous, current) => current is HomeActionState,
          builder: (context, state) {
            if (state is HomeSuccessState) {
              //for set categories name to tab
              final categoriesList = state.menuCategories.map((it) {
                return Tab(text: it.categoryName);
              }).toList();
              //ui🗿
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TabBar(
                    tabs: categoriesList,
                    labelStyle: const TextStyle(fontFamily: 'Ktwod'),
                    controller: _tabController,
                    physics: const ClampingScrollPhysics(),
                    isScrollable: true,
                    unselectedLabelColor:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                    splashBorderRadius:
                        const BorderRadius.all(Radius.circular(120.0)),
                    indicator: CustomTabIndicator(
                      Theme.of(context).colorScheme.primary,
                    ),
                    indicatorPadding: const EdgeInsets.all(4.0),
                    indicatorSize: TabBarIndicatorSize.tab,
                    automaticIndicatorColorAdjustment: true,
                    dividerColor: Colors.transparent,
                    onTap: (categoryIndex) {},
                  ),
                  Expanded(
                      child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          orientation == Orientation.portrait ? 2 : 4,
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
                    itemCount: state.menuProducts.length,
                    itemBuilder: (context, itemIndex) {
                      if (_buttonStates.length <= itemIndex) {
                        _buttonStates.add(false);
                      }
                      // indexing sorted data
                      final item = state.menuProducts[itemIndex];
                      final gridItem = _gridItemView(
                        productId: item.id!,
                        name: item.name,
                        price: item.price,
                        image: item.image,
                        weight: item.weight,
                        orientation: orientation,
                        itemIndex: itemIndex,
                      );
                      return gridItem;
                    },
                  )),
                ],
              );
            } else if (state is HomeLoadingState) {
              return const Center(child: Skeleton());
            } else if (state is HomeErrorState) {
              return errorWidget(state.error, context);
            }
            return Container();
          },
          listener: (BuildContext context, HomeState state) {
            if (state is HomeNavigateBackActionState) {
              Navigator.of(context).pop();
            }
            if (state is HomeNavigateToOrdersScreenState) {
              OrdersScreen.open(context);
            }
            if (state is HomeShowSnackMessageActionState) {
              showSnackBar(state.message, context);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          context.read<HomeBloc>().add(HomeOnNavigateToOrdersScreenEvent());
        },
        tooltip: 'go to orders',
        isExtended: true,
        child: Icon(
          Icons.shopping_cart_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _gridItemView({
    required int productId,
    required String name,
    required String price,
    required String image,
    required String weight,
    required int itemIndex,
    required Orientation orientation,
  }) {
    Widget addToCartButton = ElevatedButton.icon(
      onPressed: () async {
        setState(() {
          _buttonStates[itemIndex] = !_buttonStates[itemIndex];
        });
        bool buttonState = _buttonStates[itemIndex];
        context.read<HomeBloc>().add(HomeOnInsertOrDeleteOrdersEvent(
              productId: productId,
              state: buttonState,
            ));
      },
      icon: Icon(
        _buttonStates[itemIndex] ? Icons.remove_rounded : Icons.add_rounded,
        color: Theme.of(context).colorScheme.onTertiary,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _buttonStates[itemIndex]
            ? _isSelectedColor
            : Theme.of(context).colorScheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(fillMaxWidth(context)),
        ),
        minimumSize: Size(
          fillMaxWidth(context),
          orientation == Orientation.portrait
              ? fillMaxHeight(context) * 0.04
              : fillMaxHeight(context) * 0.08,
        ),
        elevation: 4.0,
      ),
      label: TextView(
        text: _buttonStates[itemIndex] ? "Olib tashlash" : "Qo'shish",
        textSize: 13.0,
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
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: "image_hero_$name",
                  child: CachedImageView(
                    imageUrl: image,
                    width: fillMaxWidth(context),
                    height: fillMaxHeight(context) * 0.16,
                    controller: _animateController,
                    borderRadius: 14.0,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //product`s price text
                  TextView(
                    text: price,
                    textSize: 18.0,
                    weight: FontWeight.w700,
                    textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  //product name text
                  TextView(
                    text: name,
                    textSize: 13.0,
                    weight: FontWeight.normal,
                    textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 12),
                  //product weight text
                  TextView(
                    text: weight,
                    textSize: 12.0,
                    weight: FontWeight.normal,
                    textColor: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 6.0),
                ],
              ),
              addToCartButton /* add to cart button */,
            ],
          ),
        ));
  }
}
