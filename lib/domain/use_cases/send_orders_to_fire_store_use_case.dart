import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/data/remote/fire_store_services/fire_store_service.dart';

import '../../data/remote/model/send_to_firebase_models/send_orders_model.dart';

@immutable
class SendOrdersToFireStoreUseCase {
  final FireStoreService fireStoreService;

  const SendOrdersToFireStoreUseCase(this.fireStoreService);

  Future<void> call(SendOrdersModel sendOrdersModel) async =>
      await fireStoreService.sendOrders(sendOrdersModel);
}
