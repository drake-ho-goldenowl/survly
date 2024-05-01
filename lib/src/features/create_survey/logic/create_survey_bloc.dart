import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/create_survey/logic/create_survey_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/outlet/outlet.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/src/service/picker_service.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CreateSurveyBloc extends Cubit<CreateSurveyState> {
  CreateSurveyBloc() : super(CreateSurveyState.ds());

  get domainManager => DomainManager();

  Future<void> onPickImage() async {
    var imagePath = await PickerService.pickImageFromGallery();
    emit(state.copyWith(imageLocalPath: imagePath?.path));
  }

  void onDateRangeChange(PickerDateRange dateRange) {
    if (dateRange.startDate != null && dateRange.endDate != null) {
      emit(
        state.copyWith(
          survey: state.survey.copyWith(
            dateStart: dateRange.startDate.toString(),
            dateEnd: dateRange.endDate.toString(),
          ),
        ),
      );
    }
  }

  void onTitleChange(String newText) {
    emit(
      state.copyWith(survey: state.survey.copyWith(title: newText)),
    );
  }

  void onDescriptionChange(String newText) {
    emit(
      state.copyWith(survey: state.survey.copyWith(description: newText)),
    );
  }

  void onRespondentNumberChange(String newText) {
    try {
      emit(
        state.copyWith(
          survey: state.survey.copyWith(respondentMax: int.parse(newText)),
        ),
      );
    } catch (e) {
      Logger().e(e);
    }
  }

  void onCostChange(String newText) {
    try {
      emit(
        state.copyWith(survey: state.survey.copyWith(cost: int.parse(newText))),
      );
    } catch (e) {
      Logger().e(e);
    }
  }

  void onQuestionListItemChange(Question oldQuestion, Question newQuestion) {
    var list = List.of(state.questionList);
    list[list.indexOf(oldQuestion)] = newQuestion;
    emit(state.copyWith(questionList: list));
  }

  Future<void> saveSurvey() async {
    emit(state.copyWith(isLoading: true));
    try {
      await domainManager.survey.createSurvey(
        survey: state.survey,
        fileLocalPath: state.imageLocalPath,
        questionList: state.questionList,
      );
      emit(state.copyWith(isLoading: false));
      AppCoordinator.pop();
    } catch (e) {
      Logger().e(e);
      Fluttertoast.showToast(msg: S.text.errorGeneral);
      emit(state.copyWith(isLoading: false));
    }
  }

  void addQuestion(QuestionType questionType) {
    List<Question> list = List.of(state.questionList);
    if (questionType == QuestionType.text) {
      list.add(
        Question(
            questionIndex: list.length + 1,
            questionType: questionType.value,
            question: "${S.text.questionSampleText} ${list.length + 1}"),
      );
    } else {
      var question = QuestionWithOption.sample(
        questionIndex: list.length + 1,
        questionType: questionType.value,
        question: "${S.text.questionSampleText} ${list.length + 1}",
        optionList: [],
      );
      list.add(question);
    }
    emit(state.copyWith(questionList: list));
  }

  void removeQuestion(Question question) {
    var list = List.of(state.questionList);
    list.remove(question);
    for (int i = 0; i < list.length; i++) {
      list[i].questionIndex = i + 1;
    }
    emit(state.copyWith(questionList: list));
  }

  void onOutletLocationChange(Outlet? outlet) {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(outlet: outlet),
      ),
    );
  }
}