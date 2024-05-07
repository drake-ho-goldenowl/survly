import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/dashboard_admin/logic/survey_list_bloc.dart';
import 'package:survly/src/features/dashboard_admin/logic/survey_list_state.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_survey_list_widget.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/widgets/app_loading_circle.dart';
import 'package:survly/widgets/app_text_field.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => SurveyListBloc(),
      child: BlocBuilder<SurveyListBloc, SurveyListState>(
        buildWhen: (previous, current) {
          return previous.isLoading != current.isLoading;
        },
        builder: (context, state) {
          return Scaffold(
            body: state.isLoading
                ? const AppLoadingCircle()
                : _buildSurveyListView(),
          );
        },
      ),
    );
  }

  Widget _buildSurveyListView() {
    return BlocBuilder<SurveyListBloc, SurveyListState>(
      buildWhen: (previous, current) =>
          previous.surveyList != current.surveyList,
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: AppTextField(
                          hintText: S.of(context).labelSearch,
                          suffixIcon: IconButton(
                            onPressed: () {
                              context.read<SurveyListBloc>().searchSurvey();
                            },
                            icon: const Icon(Icons.search),
                          ),
                          onTextChange: (newText) {
                            context
                                .read<SurveyListBloc>()
                                .onSearchKeywordChange(newText);
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(),
                            isScrollControlled: true,
                            builder: (sheetContext) {
                              return _buildBottomSheetFilter(context);
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.filter_alt_outlined,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: AppSurveyListWidget(
                    surveyList: state.surveyList,
                    onRefresh: () =>
                        context.read<SurveyListBloc>().fetchFirstPageSurvey(),
                    onLoadMore: () =>
                        context.read<SurveyListBloc>().fetchMoreSurvey(),
                    onItemClick: (survey) async {
                      await context
                          .push(AppRouteNames.reviewSurvey.path, extra: survey)
                          .then(
                        (value) {
                          if (value != null) {
                            if (value == true) {
                              // is archived
                              context
                                  .read<SurveyListBloc>()
                                  .archiveSurvey(survey);
                            } else {
                              // is updated
                              context
                                  .read<SurveyListBloc>()
                                  .onSurveyListItemChange(
                                      survey, value as Survey);
                            }
                          }
                        },
                      );
                    },
                  ),
                )
              ],
            ),
            Positioned(
              right: 32,
              bottom: 32,
              child: FloatingActionButton(
                onPressed: () async {
                  await context.push(AppRouteNames.createSurvey.path).then(
                    (value) {
                      if (value == true) {
                        context.read<SurveyListBloc>().resetSurveyList();
                      }
                    },
                  );
                },
                shape: const CircleBorder(),
                backgroundColor: AppColors.primary,
                child: const Icon(
                  Icons.add,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomSheetFilter(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<SurveyListBloc>(context),
      child: BlocBuilder<SurveyListBloc, SurveyListState>(
        buildWhen: (previous, current) =>
            previous.filterByStatus != current.filterByStatus ||
            previous.sortBy != current.sortBy,
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, -1),
                  blurRadius: 8,
                ),
              ],
              color: Colors.grey[200],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).labelSurveyStatus,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RadioListTile(
                        title: Text(S.of(context).labelStatusAll),
                        value: FilterByStatus.all,
                        groupValue: state.filterByStatus,
                        onChanged: (value) {
                          context
                              .read<SurveyListBloc>()
                              .filterBySurveyStatus(value);
                        },
                      ),
                      RadioListTile(
                        title: Text(S.of(context).labelStatusPublic),
                        value: FilterByStatus.public,
                        groupValue: state.filterByStatus,
                        onChanged: (value) {
                          context
                              .read<SurveyListBloc>()
                              .filterBySurveyStatus(value);
                        },
                      ),
                      RadioListTile(
                        title: Text(S.of(context).labelStatusDraft),
                        value: FilterByStatus.draft,
                        groupValue: state.filterByStatus,
                        onChanged: (value) {
                          context
                              .read<SurveyListBloc>()
                              .filterBySurveyStatus(value);
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).labelSortBy,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RadioListTile(
                        title: Text(S.of(context).labelSortByDateCreate),
                        value: SortBy.dateCreate,
                        groupValue: state.sortBy,
                        onChanged: (value) {
                          context.read<SurveyListBloc>().sortBy(value);
                        },
                      ),
                      RadioListTile(
                        title: Text(S.of(context).labelSortByTitle),
                        value: SortBy.title,
                        groupValue: state.sortBy,
                        onChanged: (value) {
                          context.read<SurveyListBloc>().sortBy(value);
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0)
              ],
            ),
          );
        },
      ),
    );
  }
}
