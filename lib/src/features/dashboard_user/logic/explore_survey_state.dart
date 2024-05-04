import 'package:equatable/equatable.dart';

import 'package:survly/src/network/model/survey/survey.dart';

class ExploreSurveyState extends Equatable {
  final List<Survey> surveyList;
  final bool isLoading;
  final bool isShowingFilterSheet;
  final bool isShowSurveyNearby;
  final String searchKeyword;

  const ExploreSurveyState({
    required this.surveyList,
    required this.isLoading,
    required this.isShowingFilterSheet,
    required this.isShowSurveyNearby,
    required this.searchKeyword,
  });

  factory ExploreSurveyState.ds() => const ExploreSurveyState(
        surveyList: [],
        isLoading: true,
        isShowingFilterSheet: false,
        isShowSurveyNearby: true,
        searchKeyword: '',
      );

  List<Survey> get surveyFilterList {
    return surveyList;
  }

  ExploreSurveyState copyWith({
    List<Survey>? surveyList,
    bool? isLoading,
    bool? isShowingFilterSheet,
    bool? isShowSurveyNearby,
    String? searchKeyword,
  }) {
    return ExploreSurveyState(
      surveyList: surveyList ?? this.surveyList,
      isLoading: isLoading ?? this.isLoading,
      isShowingFilterSheet: isShowingFilterSheet ?? this.isShowingFilterSheet,
      isShowSurveyNearby: isShowSurveyNearby ?? this.isShowSurveyNearby,
      searchKeyword: searchKeyword ?? this.searchKeyword,
    );
  }

  @override
  List<Object?> get props => [
        surveyList,
        surveyFilterList,
        isLoading,
        isShowSurveyNearby,
        searchKeyword,
        isShowingFilterSheet
      ];
}
