import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_tile.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';

class AverageDisplay extends StatelessWidget {
  const AverageDisplay({Key? key, this.average = 0.0, this.border = false}) : super(key: key);

  final double average;
  final bool border;

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    double _average = !settings.goodStudent || border ? average : 5.0;
    Color color = gradeColor(context: context, value: _average);

    String averageText = _average.toStringAsFixed(2);
    if (I18n.of(context).locale.languageCode != "en") averageText = averageText.replaceAll(".", ",");

    return Container(
      width: border ? 54.0 : 52.0,
      padding: EdgeInsets.symmetric(horizontal: 8.0 - (border ? 2 : 0), vertical: 6.0 - (border ? 2 : 0)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45.0),
          border: border ? Border.fromBorderSide(BorderSide(color: color.withOpacity(.5), width: 3.0)) : null,
          color: !border ? color.withOpacity(.25) : null),
      child: Text(
        averageText,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
