import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/select_location/logic/select_location_state.dart';
import 'package:survly/src/network/data/location/location_data.dart';
import 'package:survly/src/network/model/fild_place/find_text_response.dart';

class SelectLocationBloc extends Cubit<SelectLocationState> {
  SelectLocationBloc() : super(SelectLocationState.ds()) {
    getCurrentLocation();
  }

  Future<void> searchLocationByText() async {
    LocationData().findText(state.searchText, state.currentLocation!);
    // final findPlaceResponse = await LocationData().findPlace(state.searchText);
    // if (findPlaceResponse.status == "OK") {
    //   try {
    //     LatLng newLatLng = LatLng(
    //       findPlaceResponse.candidates![0].geometry!.location!.lat!,
    //       findPlaceResponse.candidates![0].geometry!.location!.lng!,
    //     );
    //     emit(
    //       state.copyWith(
    //         searchedLocation: newLatLng,
    //       ),
    //     );
    //     state.mapController?.animateCamera(
    //       CameraUpdate.newLatLngZoom(state.searchedLocation!, 10),
    //     );
    //   } catch (e) {
    //     Logger().e(e);
    //   }
    // }
  }

  void moveCamera(Results result) {
    try {
      LatLng newLatLng = LatLng(
        result.geometry!.location!.lat!,
        result.geometry!.location!.lng!,
      );
      emit(
        state.copyWith(
          searchedLocation: newLatLng,
        ),
      );
      state.mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(state.searchedLocation!, 14),
      );
    } catch (e) {
      Logger().e(e);
    }
  }

  void moveCameraToMyLocation() {
    try {
      state.mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(state.currentLocation!, 16),
      );
    } catch (e) {
      Logger().e(e);
    }
  }

  void onMapLongPressed(LatLng latLng) {
    emit(
      state.copyWith(
        searchedLocation: latLng,
      ),
    );
  }

  Future<FindTextResponse> findText(String text) async {
    return await LocationData().findText(text, state.currentLocation!);
  }

  void onSearchTextChange(String text) {
    emit(state.copyWith(searchText: text));
  }

  Future<void> getCurrentLocation() async {
    Logger().d("start get current location");
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      emit(
        state.copyWith(
          currentLocation: LatLng(position.latitude, position.longitude),
        ),
      );
      Logger()
          .d("current location: (${position.latitude}, ${position.longitude})");
    } catch (e) {
      Logger().e(e);
    }
  }

  void onMapControllerChange(GoogleMapController mapController) {
    emit(state.copyWith(mapController: mapController));
  }
}
