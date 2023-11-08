import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:night_fall_restaurant/data/remote/model/send_to_firebase_models/send_orders_model.dart';

import '../model/tables_password_response.dart';
import '../model/get_menu_list_response.dart';
import 'fire_store_service.dart';

class FireStoreServiceImpl extends FireStoreService {
  static final _fireStore = FirebaseFirestore.instance;
  static const String _menuCollectionPath = 'products_menu';
  static const String _tablesCollectionPath = 'tables_passwords';
  static const String _ordersCollectionPath = 'orders';
  static const String _menuDocsPath = '1_categories';

  @override
  Future<GetMenuListResponse> getMenuList() async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _fireStore.collection(_menuCollectionPath).doc(_menuDocsPath);
      DocumentSnapshot documentSnapshot = await docRef.get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        return GetMenuListResponse.fromMap(data);
      } else {
        throw Exception('Document doesn`t exist');
      }
    } on FirebaseException catch (fireException) {
      throw Exception(fireException.message);
    }
  }

  @override
  Future<List<TablesPasswordResponse>> getTablePasswords() async {
    try {
      final tablesQuery = await _fireStore
          .collection(_tablesCollectionPath)
          .orderBy('tableNumber')
          .get();
      final docsCollect = tablesQuery.docs;
      if (docsCollect.isNotEmpty) {
        return docsCollect
            .map((it) => TablesPasswordResponse.fromMap(it.data()))
            .toList();
      } else {
        throw Exception('Document doesn`t exist');
      }
    } catch (exception) {
      throw Exception(exception);
    }
  }

  @override
  Future<void> sendOrders(SendOrdersModel sendOrdersModel) async {
    try {
      final CollectionReference ordersCollection =
          _fireStore.collection(_ordersCollectionPath);
      await ordersCollection.add(sendOrdersModel.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }
}
