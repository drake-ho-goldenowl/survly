enum AppRouteNames {
  login(path: '/login'),
  signUp(path: '/signUp'),
  dashboard(path: '/dashboard'),
  dashboardUser(path: '/dashboardUser'),
  survey(path: '/survey'),
  user(path: '/user'),
  createSurvey(path: '/createSurvey'),
  selectLocation(path: '/selectLocation'),
  updateSurvey(path: '/updateSurvey'),
  reviewSurvey(path: '/reviewSurvey'),
  surveyRequest(path: '/surveyRequest'),
  surveyResponse(path: '/surveyResponse'),
  userProfile(path: '/userProfile'),
  doSurvey(path: '/doSurvey'),
  doSurveyTracking(path: '/doSurveyTracking'),
  explore(path: '/explore'),
  mySurvey(path: '/doingSurvey'),
  previewSurvey(path: '/previewSurvey'),
  myProfile(path: '/myProfile'),
  updateProfile(path: '/updateProfile'),
  responseUserSurvey(path: '/responseUserSurvey');

  const AppRouteNames({
    required this.path,
    this.paramName,
  });

  final String path;
  final String? paramName;

  String get name => path;

  String get subPath {
    if (path == '/') {
      return path;
    }
    return path.replaceFirst('/', '');
  }

  String get buildPathParam => '$path:$paramName';
  String get buildSubPathParam => '$subPath:$paramName';
}
