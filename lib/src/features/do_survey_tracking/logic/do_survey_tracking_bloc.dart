import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/features/do_survey_tracking/logic/do_survey_tracking_state.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository_impl.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';

class DoSurveyTrackingBloc extends Cubit<DoSurveyTrackingState> {
  DoSurveyTrackingBloc(String doSurveyId) : super(DoSurveyTrackingState.ds()) {
    fetchDoSurvey(doSurveyId);
  }

  Future<void> fetchDoSurvey(String doSurveyId) async {
    var doSurvey = await DoSurveyRepositoryImpl().getDoSurvey(doSurveyId);
    var snapshot = DoSurveyRepositoryImpl().getDoSurveySnapshot(doSurvey);
    var snapshotSub = snapshot.listen((event) {
      var latLng = LatLng(event.data()?[DoSurveyCollection.fieldCurrentLat],
          event.data()?[DoSurveyCollection.fieldCurrentLng]);

      var newDoSurvey = DoSurvey(
        doSurveyId: state.doSurvey?.doSurveyId ?? "",
        status: state.doSurvey?.status ?? "",
        currentLat: latLng.latitude,
        currentLng: latLng.longitude,
      );

      emit(state.copyWith(doSurvey: newDoSurvey));

      state.mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 15),
      );

      Logger().d("(${latLng.latitude} , ${latLng.longitude})");
    });

    emit(state.copyWith(
      doSurvey: doSurvey,
      snapshotSub: snapshotSub,
    ));
  }

  void onMapControllerChange(GoogleMapController controller) {
    emit(state.copyWith(mapController: controller));
  }

  @override
  Future<void> close() {
    state.snapshotSub?.cancel();
    Logger().d("dispose");
    return super.close();
  }
}
