import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/dashboard_admin/logic/navigation_bar_item.dart';
import 'package:survly/src/router/coordinator.dart';

class BottomNavBloc extends Cubit<AdminBottomNavBarItems> {
  BottomNavBloc(super.current);

  void onDestinationSelected(int index) {
    emit(AdminBottomNavBarItems.values[index]);
    AppCoordinator.goNamed(state.route.name);
  }

  void goHome() {
    emit(AdminBottomNavBarItems.survey);
    AppCoordinator.goNamed(state.route.name);
  }
}