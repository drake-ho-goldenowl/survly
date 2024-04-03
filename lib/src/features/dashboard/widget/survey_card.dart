import 'package:flutter/material.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/theme/colors.dart';

class SurveyCard extends StatelessWidget {
  const SurveyCard({
    super.key,
    required this.survey,
    this.borderRadius = 8,
  });

  final double borderRadius;
  final Survey survey;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              color: Colors.black26,
              offset: Offset(0, 0),
            )
          ],
          color: AppColors.white),
      child: Column(
        children: [
          _buildSurveyThumbnail(),
          _buildSurveyContent(),
        ],
      ),
    );
  }

  Widget _buildSurveyThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        topRight: Radius.circular(borderRadius),
      ),
      child: Image.network(
        survey.thumbnail,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSurveyContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            survey.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Text("${survey.respondentNum}/${survey.respondentMax} respondents"),
                    const SizedBox(
                      height: 4,
                    ),
                    Text("Closed on ${survey.dateEnd}"),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadius))),
                child: Text(
                  "${survey.cost/1000}k",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}