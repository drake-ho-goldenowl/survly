enum DoSurveyStatus {
  doing(value: "doing"),
  approved(value: "approved"),
  ignored(value: "ignored");

  final String value;

  const DoSurveyStatus({required this.value});
}

class DoSurvey {}
