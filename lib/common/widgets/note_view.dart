import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:filcnaplo_kreta_api/models/note.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_mobile_ui/common/sliding_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class NoteView extends StatelessWidget {
  const NoteView(this.note, {Key? key}) : super(key: key);

  final Note note;

  static void show(Note note, {required BuildContext context}) => showSlidingBottomSheet(context: context, child: NoteView(note));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          ListTile(
            leading: ProfileImage(
              name: note.teacher,
              radius: 22.0,
              backgroundColor: ColorUtils.stringToColor(note.teacher),
            ),
            title: Text(
              note.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              note.teacher,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              note.date.format(context),
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          // Details
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: SelectableLinkify(
              text: note.content.escapeHtml(),
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
        ],
      ),
    );
  }
}
