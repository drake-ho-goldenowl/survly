// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:survly/src/config/constants/firebase_collections.dart';
// import 'package:survly/src/network/data/admin/admin_repository.dart';
// import 'package:survly/src/network/model/admin/admin.dart';

// class AdminRepositoryImpl implements AdminRepository {
//   final CollectionReference ref =
//       FirebaseFirestore.instance.collection(UserCollection.collectionName);

//   @override
//   Future<Admin?> getAdminByEmail(String email) async {
//     Admin? admin;
//     try {
//       var snapshot = await ref
//           .where(
//             UserCollection.fieldEmail,
//             isEqualTo: email,
//           )
//           .get();
//       var json = snapshot.docs[0].data() as Map<String, dynamic>;
//       json[UserCollection.fieldUserId] = snapshot.docs[0].id;
//       admin = Admin.fromMap(json);
//     } catch (e) {
//       rethrow;
//     }
//     return admin;
//   }
// }
