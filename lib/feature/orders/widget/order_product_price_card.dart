import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:night_fall_restaurant/domain/model/order_products_model.dart';
import 'package:night_fall_restaurant/feature/orders/bloc/orders_bloc.dart';
import 'package:night_fall_restaurant/utils/helpers.dart';
import 'package:night_fall_restaurant/utils/ui_components/standart_text.dart';

class OrderProductPriceCard extends StatelessWidget {
  final List<OrderProductsModel> orderProductsList;
  final int totalPrice;

  const OrderProductPriceCard({
    super.key,
    required this.orderProductsList,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  itemCount: orderProductsList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = orderProductsList[index];
                    return _ordersRowCardItem(
                      context,
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
                  text: "${_numberFormatPrice(totalPrice)} so`m",
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
                      .add(OrdersOnSendProductsToFireStoreEvent(
                        orderProductsList,
                      ));
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
                  textColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  maxLines: 1,
                  textSize: 18.0,
                ))
          ],
        ),
      ),
    );
  }

  Widget _ordersRowCardItem(
    BuildContext context, {
    required String name,
    required String count,
    required String price,
  }) {
    final productPrice =
        int.parse(price.replaceAll('so`m', '').replaceAll(' ', '')) *
            int.parse(count);

    return Container(
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
            text: "${_numberFormatPrice(productPrice)}so`m",
            textColor: Theme.of(context).colorScheme.onSecondary,
            maxLines: 1,
            textSize: 14.0,
            weight: FontWeight.w700,
          ),
        ],
      ),
    );
  }

  String _numberFormatPrice(int price) {
    final NumberFormat decimalFormat = NumberFormat.decimalPatternDigits();
    return decimalFormat.format(price).replaceAll(',', ' ');
  }
}
