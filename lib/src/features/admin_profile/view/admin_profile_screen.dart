import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/admin_profile/logic/admin_profile_bloc.dart';
import 'package:survly/src/features/admin_profile/logic/admin_profile_state.dart';
import 'package:survly/src/features/dashboard/logic/account_bloc.dart';
import 'package:survly/src/features/dashboard/logic/account_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/model/admin/admin.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_avatar_widget.dart';
import 'package:survly/widgets/app_survey_card.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminProfileBloc(),
      child: BlocBuilder<AdminProfileBloc, AdminProfileState>(
        buildWhen: (previous, current) =>
            previous.isShowProfile != current.isShowProfile ||
            previous.adminSurveyList != current.adminSurveyList,
        builder: (context, state) {
          return Scaffold(
            appBar: AppAppBarWidget(
              backgroundColor: AppColors.backgroundBrightness,
              leadingColor: const Color.fromRGBO(0, 0, 0, 1),
              centerTitle: true,
              title: state.isShowProfile
                  ? null
                  : UserBaseSingleton.instance().userBase?.fullname,
              titleColor: Colors.black,
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                          onTap: () {
                            context.push(AppRouteNames.updateAdminProfile.path);
                          },
                          child: const Text("Edit profile"))
                    ];
                  },
                ),
                const SizedBox(width: 4)
              ],
            ),
            body: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  state.isShowProfile ? _buildProfile() : const SizedBox(),
                  Container(
                    margin: const EdgeInsets.only(
                      // top: 32,
                      // bottom: 4,
                      left: 16,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          "Created 10 survey",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            context
                                .read<AdminProfileBloc>()
                                .isShowProfileChange();
                          },
                          icon: Icon(state.isShowProfile
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up),
                        )
                      ],
                    ),
                  ),
                  const Divider(height: 0),
                  Expanded(flex: 1, child: _buildSurveyLists()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfile() {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (previous, current) => previous.userBase != current.userBase,
      builder: (context, state) {
        final user = state.userBase as Admin;
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              AppAvatarWidget(
                avatarUrl: user.avatar,
                size: 128,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                user.fullname,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(user.email),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSurveyLists() {
    return BlocBuilder<AdminProfileBloc, AdminProfileState>(
      buildWhen: (previous, current) =>
          previous.adminSurveyList != current.adminSurveyList,
      builder: (context, state) {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 64),
          itemCount: state.adminSurveyList.length,
          itemBuilder: (context, index) {
            var survey = state.adminSurveyList[index];
            return SizedBox(
                width: double.infinity, child: AppSurveyCard(survey: survey));
          },
        );
      },
    );
  }
}
