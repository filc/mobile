import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_group_container.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_tile.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'absence_group_tile.i18n.dart';

class AbsenceGroupTile extends StatelessWidget {
  const AbsenceGroupTile(this.absences, {Key? key, this.showDate = false})
      : super(key: key);

  final List<AbsenceTile> absences;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    Justification state =
        getState(absences.map((e) => e.absence.state).toList());
    Color color = AbsenceTile.justificationColor(state, context: context);

    absences.sort((a, b) =>
        a.absence.lessonIndex?.compareTo(b.absence.lessonIndex ?? 0) ?? -1);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14.0),
      child: Material(
        type: MaterialType.transparency,
        child: AbsenceGroupContainer(
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 8.0),
            backgroundColor: Colors.transparent,
            leading: Container(
              width: 44.0,
              height: 44.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(.25),
              ),
              child: Center(
                  child:
                      Icon(AbsenceTile.justificationIcon(state), color: color)),
            ),
            title: Text.rich(TextSpan(
              text: "${absences.length} ",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.of(context).text),
              children: [
                TextSpan(
                  text: AbsenceTile.justificationName(state)
                      .fill(["absence".i18n]),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.of(context).text),
                ),
              ],
            )),
            subtitle: showDate
                ? Text(
                    absences.first.absence.date.format(context, weekday: true),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.of(context).text.withOpacity(0.8)),
                  )
                : null,
            children: absences,
          ),
        ),
      ),
    );
  }

  static Justification getState(List<Justification> states) {
    Justification state;

    if (states.any((element) => element == Justification.Unexcused)) {
      state = Justification.Unexcused;
    } else if (states.any((element) => element == Justification.Pending)) {
      state = Justification.Pending;
    } else {
      state = Justification.Excused;
    }

    return state;
  }
}
