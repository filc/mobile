import 'dart:math';

import 'package:filcnaplo/helpers/average_helper.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/certification_tile.i18n.dart';

class GradeGraph extends StatefulWidget {
  GradeGraph(this.data, {Key? key, this.dayThreshold = 7}) : super(key: key);

  final List<Grade> data;
  final int dayThreshold;

  @override
  _GradeGraphState createState() => _GradeGraphState();
}

class _GradeGraphState extends State<GradeGraph> {
  late SettingsProvider settings;

  List<FlSpot> getSpots(List<Grade> data) {
    List<FlSpot> subjectData = [];
    List<List<Grade>> sortedData = [[]];

    // Sort by date
    data.sort((a, b) => -a.writeDate.compareTo(b.writeDate));

    // Sort data to points by treshold
    data.forEach((element) {
      if (sortedData.last.length != 0 && sortedData.last.last.writeDate.difference(element.writeDate).inDays > widget.dayThreshold)
        sortedData.add([]);
      sortedData.forEach((dataList) {
        dataList.add(element);
      });
    });

    // Create FlSpots from points
    sortedData.forEach((dataList) {
      double average = AverageHelper.averageEvals(dataList);

      if (dataList.length > 0) {
        subjectData.add(FlSpot(
          dataList[0].writeDate.month + (dataList[0].writeDate.day / 31) + ((dataList[0].writeDate.year - data.first.writeDate.year) * 12),
          double.parse(average.toStringAsFixed(2)),
        ));
      }
    });

    return subjectData;
  }

  @override
  Widget build(BuildContext context) {
    settings = Provider.of<SettingsProvider>(context);

    List<FlSpot> subjectSpots = [];
    List<FlSpot> ghostSpots = [];
    List<VerticalLine> extraLines = [];

    // Filter data
    List<Grade> data = widget.data
        .where((e) => e.value.weight != 0)
        .where((e) => e.type == GradeType.midYear)
        .where((e) => e.gradeType?.name == "Osztalyzat")
        .toList();

    // Filter ghost data
    List<Grade> ghostData = widget.data.where((e) => e.value.weight != 0).where((e) => e.type == GradeType.ghost).toList();

    // Calculate average
    double average = AverageHelper.averageEvals(data);

    // Calculate graph color
    Color averageColor = average >= 1 && average <= 5
        ? ColorTween(begin: settings.gradeColors[average.floor() - 1], end: settings.gradeColors[average.ceil() - 1])
            .transform(average - average.floor())!
        : Theme.of(context).colorScheme.secondary;

    subjectSpots = getSpots(data);
    ghostSpots = getSpots(data + ghostData);
    ghostSpots = ghostSpots.where((e) => e.x >= subjectSpots.map((f) => f.x).reduce(max)).toList();

    Grade halfYearGrade = widget.data.lastWhere((e) => e.type == GradeType.halfYear, orElse: () => Grade.fromJson({}));

    if (halfYearGrade.date.year != 0 && data.length > 0)
      extraLines.add(VerticalLine(
          x: halfYearGrade.date.month + (halfYearGrade.date.day / 31) + ((halfYearGrade.date.year - data.first.writeDate.year) * 12),
          strokeWidth: 3.0,
          color: AppColors.of(context).text.withOpacity(.75),
          label: VerticalLineLabel(
              labelResolver: (_) => "mid".i18n,
              show: true,
              alignment: Alignment.topLeft,
              style: TextStyle(
                color: AppColors.of(context).text,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ))));

    return Container(
      child: subjectSpots.length > 0
          ? LineChart(
              LineChartData(
                extraLinesData: ExtraLinesData(verticalLines: extraLines),
                lineBarsData: [
                  LineChartBarData(
                    spots: subjectSpots,
                    isCurved: true,
                    curveSmoothness: 0.3,
                    colors: [averageColor],
                    barWidth: 8,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      colors: [
                        averageColor.withOpacity(0.7),
                        averageColor.withOpacity(0.3),
                        averageColor.withOpacity(0.2),
                        averageColor.withOpacity(0.1),
                      ],
                      gradientColorStops: [0.1, 0.6, 0.8, 1],
                      gradientFrom: Offset(0, 0),
                      gradientTo: Offset(0, 1),
                    ),
                  ),
                  if (ghostData.length > 0 && ghostSpots.length > 0)
                    LineChartBarData(
                      spots: ghostSpots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      colors: [AppColors.of(context).text],
                      barWidth: 8,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [
                          AppColors.of(context).text.withOpacity(0.7),
                          AppColors.of(context).text.withOpacity(0.3),
                          AppColors.of(context).text.withOpacity(0.2),
                          AppColors.of(context).text.withOpacity(0.1),
                        ],
                        gradientColorStops: [0.1, 0.6, 0.8, 1],
                        gradientFrom: Offset(0, 0),
                        gradientTo: Offset(0, 1),
                      ),
                    ),
                ],
                minY: 1,
                maxY: 5,
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.of(context).text.withOpacity(.15),
                    strokeWidth: 2,
                  ),
                  // getDrawingVerticalLine: (_) => FlLine(
                  //   color: AppColors.of(context).text.withOpacity(.25),
                  //   strokeWidth: 2,
                  // ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.grey.shade800,
                    fitInsideVertically: true,
                    fitInsideHorizontally: true,
                  ),
                  touchCallback: (LineTouchResponse touchResponse) {},
                  handleBuiltInTouches: true,
                  touchSpotThreshold: 20.0,
                  getTouchedSpotIndicator: (_, spots) {
                    return List.generate(
                      spots.length,
                      (index) => TouchedSpotIndicatorData(
                        FlLine(
                          color: Colors.grey.shade900,
                          strokeWidth: 3.5,
                        ),
                        FlDotData(
                          getDotPainter: (a, b, c, d) => FlDotCirclePainter(
                            strokeWidth: 0,
                            color: Colors.grey.shade900,
                            radius: 10.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                  border: Border.all(
                    color: AppColors.of(context).background,
                    width: 4,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    getTextStyles: (context, value) => TextStyle(
                      color: AppColors.of(context).text.withOpacity(.75),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                    interval: null, // It automatically figures it out.
                    margin: 12.0,
                    getTitles: (value) {
                      var format = DateFormat("MMM", I18n.of(context).locale.toString());

                      String title = format.format(DateTime(0, value.floor() % 12)).replaceAll(".", "");
                      title = title.substring(0, min(title.length, 4));

                      return title.toUpperCase();
                    },
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (context, value) => TextStyle(
                      color: AppColors.of(context).text,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                    margin: 16,
                  ),
                ),
              ),
            )
          : null,
      height: double.infinity,
    );
  }
}
