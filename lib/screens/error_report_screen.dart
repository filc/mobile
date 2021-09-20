import 'dart:io';
import 'dart:math';

import 'package:filcnaplo/api/client.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'error_report_screen.i18n.dart';

class ErrorReportScreen extends StatelessWidget {
  final FlutterErrorDetails details;

  ErrorReportScreen(this.details);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              Align(
                child: BackButton(),
                alignment: Alignment.topLeft,
              ),
              Spacer(),
              Icon(
                FeatherIcons.alertTriangle,
                size: 100,
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                  "uhoh".i18n,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                "description".i18n,
                style: TextStyle(
                  color: Colors.white.withOpacity(.95),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 110.0,
                    width: double.infinity,
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.black.withOpacity(.2)),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Text(
                        details.exceptionAsString(),
                        style: TextStyle(fontFamily: 'SpaceMono'),
                      ),
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(FeatherIcons.info),
                      onPressed: () {
                        showDialog(context: context, builder: (context) => StacktracePopup(details));
                      },
                    ),
                  )
                ],
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14.0)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                  child: Text(
                    "submit".i18n,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => reportProblem(context),
                ),
              ),
              SizedBox(height: 32.0)
            ],
          ),
        ),
      ),
    );
  }

  Future reportProblem(BuildContext context) async {
    final report = ErrorReport(
      os: Platform.operatingSystem + " " + Platform.operatingSystemVersion,
      error: details.exceptionAsString(),
      version: Provider.of<SettingsProvider>(context, listen: false).packageInfo?.version ?? "?",
      stack: details.stack.toString(),
    );
    FilcAPI.sendReport(report);
    Navigator.pop(context);
  }
}

class StacktracePopup extends StatelessWidget {
  final FlutterErrorDetails details;

  StacktracePopup(this.details);

  @override
  Widget build(BuildContext context) {
    var settings = Provider.of<SettingsProvider>(context, listen: false);
    String stack = details.stack.toString();

    return Container(
      margin: EdgeInsets.all(32.0),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: AppColors.of(context).background,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "details".i18n,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  ErrorDetail(
                    "error".i18n,
                    details.exceptionAsString(),
                  ),
                  ErrorDetail("os".i18n, Platform.operatingSystem + " " + Platform.operatingSystemVersion),
                  ErrorDetail("version".i18n, settings.packageInfo?.version ?? "?"),
                  ErrorDetail("stack".i18n, stack.substring(0, min(stack.length, 5000)))
                ]),
              ),
              TextButton(
                  child: Text("done".i18n, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorDetail extends StatelessWidget {
  final String title;
  final String content;

  ErrorDetail(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
              child: Text(
                content,
                style: TextStyle(fontFamily: 'SpaceMono', color: Colors.white),
              ),
              padding: EdgeInsets.symmetric(horizontal: 6.5, vertical: 4.0),
              margin: EdgeInsets.only(top: 4.0),
              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(4.0)))
        ],
      ),
    );
  }
}
