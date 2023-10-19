import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/change_table_model.dart';
import '../model/get_menu_list_response.dart';
import 'fire_store_service.dart';

class FireStoreServiceImpl extends FireStoreService {
  static final fireStore = FirebaseFirestore.instance;
  static const String menuCollectionPath = 'products_menu';
  static const String tablesCollectionPath = 'tables_passwords';
  static const String menuDocsPath = '1_categories';

  @override
  Future<List<GetMenuListResponse>> getMenuList() async {
    List<GetMenuListResponse> menuList = [];
    try {
      final docRef = fireStore.collection(menuCollectionPath).doc(menuDocsPath);
      DocumentSnapshot documentSnapshot = await docRef.get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        menuList.add(GetMenuListResponse.fromMap(data));
      } else {
        Exception('Document doesn`t exist');
      }
    } on FirebaseException catch (fireException) {
      Exception(fireException.message);
    }
    return menuList;
  }

  @override
  Future<List<ChangeTableModel>> getTablePasswords() async {
    final List<ChangeTableModel> tablePasswordsList = [];
    try {
      final tablesQuery = await fireStore
          .collection(tablesCollectionPath)
          .orderBy('tableNumber')
          .get();
      tablesQuery.docs.forEach((it) {
        return tablePasswordsList.add(ChangeTableModel.fromMap(it.data()));
      });
      return tablePasswordsList;
    } catch (exception) {
      throw Exception(exception);
    }
  }
}
