import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/data/notification/noti_request/noti_request_repository.dart';
import 'package:survly/src/network/data/notification/notification/notification_repository_impl.dart';
import 'package:survly/src/network/model/notification/noti_request.dart';

class NotiRequestRepositoryImpl implements NotiRequestRepository {
  final ref = FirebaseFirestore.instance.collection(
    NotiRequestCollection.collectionName,
  );

  @override
  Future<void> createNotiRequest(NotiRequest notiRequest) async {
    try {
      var value = await ref.add({
        NotiRequestCollection.fieldNotiId: notiRequest.notiId,
      });
      notiRequest.notiRequestId = value.id;
      ref.doc(value.id).set(notiRequest.toMap());
    } catch (e) {
      Logger().e("create noti request error", error: e);
      rethrow;
    }
  }

  @override
  Future<NotiRequest?> fetchNotiRequestById(String notiRequestId) async {
    var value = await ref.doc(notiRequestId).get();
    if (value.data() != null) {
      return NotiRequest.fromMap(value.data()!);
    }
    return null;
  }

  @override
  Future<NotiRequest?> fetchNotiRequestByNotiId(String notiId) async {
    try {
      var noti =
          await NotificationRepositoryImpl().fetchNotificationById(notiId);
      var valueNotiRequest = await ref
          .where(NotiRequestCollection.fieldNotiId, isEqualTo: notiId)
          .get();

      return NotiRequest.fromMap({
        ...noti!.toMap(),
        ...valueNotiRequest.docs[0].data(),
      });
    } catch (e) {
      Logger().e("fetch noti request error", error: e);
      rethrow;
    }
  }
}