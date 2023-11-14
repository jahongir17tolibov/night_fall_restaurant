// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:night_fall_restaurant/domain/model/order_products_model.dart';
import 'package:night_fall_restaurant/feature/home/home_screen.dart';
import 'package:night_fall_restaurant/feature/orders/bloc/orders_bloc.dart';
import 'package:night_fall_restaurant/utils/helpers.dart';
import 'package:night_fall_restaurant/utils/ui_components/cached_image_view.dart';
import 'package:night_fall_restaurant/utils/ui_components/error_widget.dart';
import 'package:night_fall_restaurant/utils/ui_components/show_snack_bar.dart';
import 'package:night_fall_restaurant/utils/ui_components/standart_text.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const String ROUTE_NAME = "/orders";

  const OrdersScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OrdersScreenState();

  static void open(BuildContext context) {
    Navigator.of(context).pushNamed(ROUTE_NAME);
  }
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  static const String lottieFilePath = 'assets/anim/cart_is_empty_lottie.json';

  late int _pricesCount;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    context.read<OrdersBloc>().add(OrdersOnGetProductsEvent());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pricesCount = context.watch<OrdersBloc>().pricesCount;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () {
                context.read<OrdersBloc>().add(OrdersOnClearProductsEvent());
              },
              icon: Icon(
                Icons.clear_all_rounded,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 10.0),
          ],
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: TextView(
            text: 'My orders',
            textColor: Theme.of(context).colorScheme.onSurface,
          ),
          leading: IconButton(
            onPressed: () {
              context.read<OrdersBloc>().add(OrdersOnNavigateBackEvent());
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        body: BlocConsumer<OrdersBloc, OrdersState>(
          buildWhen: (previous, current) => current is! OrdersActionState,
          listenWhen: (previous, current) => current is OrdersActionState,
          builder: (context, state) {
            switch (state) {
              case OrdersLoadingState():
                return Center(
                  child: CupertinoActivityIndicator(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    radius: 36.0,
                  ),
                );
              case OrdersSuccessState():
                {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 4.0,
                              ),
                              scrollDirection: Axis.vertical,
                              physics: Platform.isIOS
                                  ? const BouncingScrollPhysics()
                                  : const BouncingScrollPhysics(),
                              itemCount: state.ordersList.length,
                              itemBuilder: (context, index) {
                                final item = state.ordersList[index];
                                return ChangeNotifierProvider<
                                    OrderProductsModel>(
                                  create: (_) => item,
                                  child: Consumer<OrderProductsModel>(
                                      builder: (context, model, _) =>
                                          _ordersItem(item: model)),
                                );
                              }),
                        ),
                        _ordersListCard(list: state.ordersList),
                      ],
                    ),
                  );
                }
              case OrdersIsEmptyState():
                return _cartIsEmptyAnim();
              case OrdersErrorState():
                return errorWidget(state.error, context);
              default:
                return Container();
            }
          },
          listener: (BuildContext context, OrdersState state) {
            if (state is OrdersListenOnBackNavigateState) {
              HomeScreen.close(context);
            }
            if (state is OrdersShowSnackMessageActionState) {
              showSnackBar(state.message, context);
            }
            if (state is OrdersShowSuccessfullySentActionState) {
              _showWhenSentDialog(state.lottiePath, state.statusText);
            }
          },
        ),
      ),
      onWillPop: () async {
        context.read<OrdersBloc>().add(OrdersOnNavigateBackEvent());
        return false;
      },
    );
  }

  void _showWhenSentDialog(String lottiePath, String status) {
    showAdaptiveDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.surface,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.92),
        elevation: 4.0,
        content: SizedBox(
          width: fillMaxWidth(context),
          height: fillMaxHeight(context) * 0.4,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Lottie.asset(
                lottiePath,
                width: 260.0,
                height: 260.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18.0,
                    fontFamily: 'Ktwod',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// orders list side
  Widget _ordersItem({required OrderProductsModel item}) {
    /// add or remove products widget
    Widget amountProductsWidget = Container(
      width: fillMaxWidth(context) * 0.21,
      height: fillMaxHeight(context) * 0.034,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
        borderRadius: BorderRadius.circular(fillMaxWidth(context)),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /// remove button
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: item.decrease,
                icon: Icon(
                  Icons.remove_rounded,
                  size: 16.0,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),

            /// value state text
            Expanded(
              flex: 1,
              child: Center(
                child: TextView(
                  text: "${item.quantity}",
                  textColor: Theme.of(context).colorScheme.onBackground,
                  textSize: 14.0,
                  weight: FontWeight.w500,
                  maxLines: 1,
                ),
              ),
            ),

            /// add button
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: item.increase,
                icon: Icon(
                  Icons.add_rounded,
                  size: 16.0,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    /// imageView
    Widget productsImage = CachedImageView(
      imageUrl: item.image,
      width: fillMaxWidth(context) * 0.175,
      height: fillMaxHeight(context) * 0.1,
      controller: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      )..repeat(reverse: true),
      borderRadius: 14.0,
    );

    /// list tile
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.surface,
        splashColor: Theme.of(context).colorScheme.secondaryContainer,
        leading: productsImage,
        trailing: amountProductsWidget,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: TextView(
          text: item.name,
          textColor: Theme.of(context).colorScheme.onSurface,
          textSize: 22.0,
          maxLines: 1,
          weight: FontWeight.w500,
        ),
        subtitle: TextView(
          text: item.price,
          textColor: Theme.of(context).colorScheme.onSurface,
          textSize: 12.5,
          maxLines: 1,
        ),
      ),
    );
  }

  /// send orders side
  Widget _ordersListCard({required List<OrderProductsModel> list}) => Card(
        color: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.all(12.0),
        elevation: 6.0,
        child: Container(
          width: fillMaxWidth(context),
          height: fillMaxHeight(context) * 0.25,
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                    itemCount: list.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return _ordersRowCardItem(
                        name: item.name,
                        count: item.quantity.toString(),
                        price: item.price,
                      );
                    }),
              ),
              const SizedBox(height: 6.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  TextView(
                    text: 'Umumiy:  ',
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    textSize: 20.0,
                    maxLines: 1,
                  ),
                  TextView(
                    text:
                        "${NumberFormat.decimalPatternDigits().format(_pricesCount)} so`m",
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    textSize: 20.0,
                    weight: FontWeight.w700,
                    maxLines: 1,
                  )
                ],
              ),
              const SizedBox(height: 8.0),
              MaterialButton(
                  onPressed: () {
                    context
                        .read<OrdersBloc>()
                        .add(OrdersOnSendProductsToFireStoreEvent(list));
                  },
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  minWidth: fillMaxWidth(context),
                  height: fillMaxHeight(context) * 0.05,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 2.0,
                      color: Theme.of(context).colorScheme.shadow,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4.0,
                  child: TextView(
                    text: 'Buyurtma berish',
                    textColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    maxLines: 1,
                    textSize: 18.0,
                  ))
            ],
          ),
        ),
      );

  Widget _ordersRowCardItem({
    required String name,
    required String count,
    required String price,
  }) =>
      Container(
        width: fillMaxWidth(context),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextView(
              text: name,
              textColor: Theme.of(context).colorScheme.onSecondary,
              maxLines: 1,
              textSize: 14.0,
              weight: FontWeight.w500,
            ),
            const SizedBox(width: 4.0),
            TextView(
              text: '${count}x',
              textColor: Theme.of(context).colorScheme.onSecondary,
              maxLines: 1,
              textSize: 16.0,
            ),
            const SizedBox(width: 10.0),
            TextView(
              text: price,
              textColor: Theme.of(context).colorScheme.onSecondary,
              maxLines: 1,
              textSize: 14.0,
              weight: FontWeight.w700,
            ),
          ],
        ),
      );

  Widget _cartIsEmptyAnim() => Center(
          child: Lottie.asset(
        lottieFilePath,
        width: 300.0,
        height: 300.0,
      ));
}
