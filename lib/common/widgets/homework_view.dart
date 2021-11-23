import 'package:filcnaplo/helpers/subject_icon.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/models/homework.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_mobile_ui/common/detail.dart';
import 'package:filcnaplo_mobile_ui/common/sliding_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'homework_view.i18n.dart';

// TODO: attachments

class HomeworkView extends StatelessWidget {
  const HomeworkView(this.homework, {Key? key}) : super(key: key);

  final Homework homework;

  static show(Homework homework, {required BuildContext context}) {
    showSlidingBottomSheet(context: context, child: HomeworkView(homework));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> attachmentTiles = [];

    // TODO: implement attachment tiles

    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          ListTile(
            leading: Icon(
              SubjectIcon.lookup(subjectName: homework.subjectName),
              size: 36.0,
            ),
            title: Text(
              homework.subjectName.capital(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              homework.teacher,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              homework.date.format(context),
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          // Details
          if (homework.deadline.year != 0)
            Detail(
                title: "deadline".i18n,
                description: homework.deadline.format(context)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
            child: SelectableLinkify(
              text: homework.content.escapeHtml(),
              options: const LinkifyOptions(looseUrl: true, removeWww: true),
              onOpen: (link) {
                launch(link.url,
                    customTabsOption: CustomTabsOption(
                      toolbarColor: AppColors.of(context).background,
                      showPageTitle: true,
                    ));
              },
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),

          // Attachments
          ...attachmentTiles,
        ],
      ),
    );
  }
}
