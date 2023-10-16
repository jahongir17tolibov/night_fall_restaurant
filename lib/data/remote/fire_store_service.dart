import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/get_menu_list_response.dart';

class FireStoreService {
  static final fireStore = FirebaseFirestore.instance;
  static const String collectionPath = 'products_menu';
  static const String docsPath = '1_categories';

  Future<List<GetMenuListResponse>> getMenuList() async {
    List<GetMenuListResponse> menuList = [];
    try {
      final docRef = fireStore.collection(collectionPath).doc(docsPath);
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
}
