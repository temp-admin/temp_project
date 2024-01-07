import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _buildDrawerHeader(),
          _buildMenuItem(AppLocalizations.of(context)!.homeTitle, [
            _buildSimpleItem(AppLocalizations.of(context)!.homeDailySummary),
            _buildSimpleItem(AppLocalizations.of(context)!.homeNotifications),
          ]),
          _buildMenuItem(AppLocalizations.of(context)!.babyAgeGuideTitle, [
            _buildMenuItem(
                AppLocalizations.of(context)!.babyAgeGuideTitle0to3, [
              _buildSimpleItem(AppLocalizations.of(context)!
                  .babyAgeGuideSleepPatternAgeSpecific),
              _buildSimpleItem(
                  AppLocalizations.of(context)!.babyAgeGuideBasicHealthCare),
            ]),
            _buildMenuItem(
                AppLocalizations.of(context)!.babyAgeGuideTitle4to6, [
              _buildSimpleItem(
                  AppLocalizations.of(context)!.babyAgeGuideStartBabyFood),
              _buildSimpleItem(AppLocalizations.of(context)!
                  .babyAgeGuideDevelopmentalMilestones),
              _buildSimpleItem(
                  AppLocalizations.of(context)!.babyAgeGuideSleepEducation),
            ]),
            _buildMenuItem(
                AppLocalizations.of(context)!.babyAgeGuideTitle7to12, [
              _buildSimpleItem(
                  AppLocalizations.of(context)!.babyAgeGuideDiversifyBabyFood),
              _buildSimpleItem(
                  AppLocalizations.of(context)!.babyAgeGuideCrawlingAndWalking),
              _buildSimpleItem(
                  AppLocalizations.of(context)!.babyAgeGuideSocialInteraction),
            ]),
            _buildMenuItem(
                AppLocalizations.of(context)!.babyAgeGuideTitle13to24, [
              _buildSimpleItem(AppLocalizations.of(context)!
                  .babyAgeGuideLanguageDevelopment),
              _buildSimpleItem(
                  AppLocalizations.of(context)!.babyAgeGuideSelfDirectedPlay),
              _buildSimpleItem(AppLocalizations.of(context)!
                  .babyAgeGuideHealthyEatingHabits),
            ]),
          ]),
          _buildMenuItem(AppLocalizations.of(context)!.healthCareTitle, [
            _buildSimpleItem(
                AppLocalizations.of(context)!.healthCareGrowthTracking),
            _buildMenuItem(
                AppLocalizations.of(context)!.healthCareVaccinationsTitle, [
              _buildSimpleItem(
                  AppLocalizations.of(context)!.healthCareVaccinationSchedule),
              _buildSimpleItem(
                  AppLocalizations.of(context)!.healthCareVaccinationRecord),
              _buildSimpleItem(AppLocalizations.of(context)!
                  .healthCareVaccinationInformation),
            ]),
            _buildSimpleItem(
                AppLocalizations.of(context)!.healthCareHealthRecords),
          ]),
          _buildMenuItem(AppLocalizations.of(context)!.feedingCareTitle, [
            _buildSimpleItem(AppLocalizations.of(context)!.feedingCareSchedule),
            _buildSimpleItem(AppLocalizations.of(context)!.feedingCareRecord),
            _buildSimpleItem(AppLocalizations.of(context)!.feedingCareTips),
          ]),
          _buildMenuItem(
              AppLocalizations.of(context)!.emotionalDevelopmentTitle, [
            _buildSimpleItem(AppLocalizations.of(context)!
                .emotionalDevelopmentUnderstandingBabyEmotions),
            _buildSimpleItem(AppLocalizations.of(context)!
                .emotionalDevelopmentParentalResponseGuide),
          ]),
          _buildMenuItem(AppLocalizations.of(context)!.safetyEducationTitle, [
            _buildSimpleItem(
                AppLocalizations.of(context)!.safetyEducationHomeSafety),
            _buildSimpleItem(
                AppLocalizations.of(context)!.safetyEducationSafetyOutside),
            _buildSimpleItem(AppLocalizations.of(context)!
                .safetyEducationSafeUseOfBabyProducts),
          ]),
          _buildMenuItem(AppLocalizations.of(context)!.playIdeasWithBabyTitle, [
            _buildSimpleItem(AppLocalizations.of(context)!
                .playIdeasWithBabyActivitySuggestions),
          ]),
          _buildMenuItem(AppLocalizations.of(context)!.settingsTitle, [
            _buildSimpleItem(AppLocalizations.of(context)!.settingsHelpSupport),
            _buildSimpleItem(AppLocalizations.of(context)!.settingsProfile),
          ]),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      height: 80.0,
      padding: EdgeInsets.all(16.0),
      color: Colors.blue,
      child: Row(
        children: [
          Image.asset('assets/logo.png', width: 50),
          SizedBox(width: 8),
          Text('Smart Parent',
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, List<Widget> children) {
    return ExpansionTile(
      title: Text(title),
      children: children,
    );
  }

  Widget _buildSimpleItem(String title) {
    return ListTile(
      title: Text(title),
      onTap: () {},
    );
  }
}
