import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/change_table_model_response.dart';
import '../model/get_menu_list_response.dart';
import 'fire_store_service.dart';

class FireStoreServiceImpl extends FireStoreService {
  static final fireStore = FirebaseFirestore.instance;
  static const String menuCollectionPath = 'products_menu';
  static const String tablesCollectionPath = 'tables_passwords';
  static const String menuDocsPath = '1_categories';

  @override
  Future<GetMenuListResponse> getMenuList() async {
    try {
      final docRef = fireStore.collection(menuCollectionPath).doc(menuDocsPath);
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
  Future<List<ChangeTableModelResponse>> getTablePasswords() async {
    try {
      final tablesQuery = await fireStore
          .collection(tablesCollectionPath)
          .orderBy('tableNumber')
          .get();
      final docsCollect = tablesQuery.docs;
      if (docsCollect.isNotEmpty) {
        return docsCollect
            .map((it) => ChangeTableModelResponse.fromMap(it.data()))
            .toList();
      } else {
        throw Exception('Document doesn`t exist');
      }
    } catch (exception) {
      throw Exception(exception);
    }
  }
}
