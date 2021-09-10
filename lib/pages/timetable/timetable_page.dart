import 'dart:math';

import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/lesson_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/lesson_view.dart';
import 'package:filcnaplo_kreta_api/controllers/timetable_controller.dart';
import 'package:filcnaplo_mobile_ui/pages/timetable/day_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:intl/intl.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'timetable_page.i18n.dart';

// todo: "fix" overflow
// TODO: filter days because kreta returns additional days...

class TimetablePage extends StatefulWidget {
  TimetablePage({Key? key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> with TickerProviderStateMixin {
  late UserProvider user;
  late TimetableProvider timetableProvider;
  late String firstName;
  late TimetableController _controller;
  late TabController _tabController;
  late Widget empty;

  int _getDayIndex(DateTime date) {
    int index = 0;
    if (_controller.days == null || _controller.days?.length == 0) return index;

    // find the first day with upcoming lessons
    index = _controller.days!.indexWhere((day) => day.last.end.isAfter(date));
    if (index == -1) index = 0; // fallback

    return index;
  }

  @override
  void initState() {
    super.initState();

    // Initalize controllers
    _controller = TimetableController(context: context);
    _tabController = TabController(length: 0, vsync: this, initialIndex: 0);

    empty = Empty(subtitle: "empty".i18n);

    // Only update the TabController on week changes
    _controller.addListener(() {
      if (_controller.days == null) return;
      setState(() {
        _tabController = TabController(
            length: _controller.days!.length, vsync: this, initialIndex: min(_tabController.index, max(_controller.days!.length - 1, 0)));

        _tabController.animateTo(_getDayIndex(DateTime.now()));

        // Empty is updated once every week change
        empty = Empty(subtitle: "empty".i18n);
      });
    });

    _controller.jump(_controller.currentWeek, context: context, initial: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  String dayTitle(int index) => DateFormat("EEEE", I18n.of(context).locale.languageCode).format(_controller.days![index].first.date);

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    timetableProvider = Provider.of<TimetableProvider>(context);

    // First name
    List<String> nameParts = user.name?.split(" ") ?? ["?"];
    firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 9.0),
        child: RefreshIndicator(
          onRefresh: () => timetableProvider.fetch(week: _controller.currentWeek, db: false),
          color: Theme.of(context).colorScheme.secondary,
          edgeOffset: 100.0,
          child: NestedScrollView(
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            headerSliverBuilder: (context, _) => [
              SliverAppBar(
                centerTitle: false,
                pinned: true,
                floating: false,
                snap: false,
                actions: [
                  // Profile Icon
                  Padding(
                    padding: EdgeInsets.only(right: 24.0),
                    child: ProfileButton(
                      child: ProfileImage(
                        heroTag: "profile",
                        name: firstName,
                        backgroundColor: ColorUtils.stringToColor(user.name ?? "?"),
                      ),
                    ),
                  ),
                ],
                automaticallyImplyLeading: false,
                // Current day text
                title: (_controller.days?.length ?? 0) > 0
                    ? DayTitle(controller: _tabController, dayTitle: dayTitle)
                    : Text(
                        "timetable".i18n,
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.of(context).text,
                        ),
                      ),
                shadowColor: AppColors.of(context).shadow.withOpacity(0.5),
                bottom: PreferredSize(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Previous week
                        IconButton(
                            onPressed: () => setState(() {
                                  _controller.previous(context);
                                }),
                            splashRadius: 24.0,
                            icon: Icon(FeatherIcons.chevronLeft),
                            color: Theme.of(context).colorScheme.secondary),

                        // Week selector
                        InkWell(
                          borderRadius: BorderRadius.circular(6.0),
                          onTap: () => setState(() {
                            _controller.current(context);
                          }),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "${_controller.currentWeekId + 1}. " +
                                  "week".i18n +
                                  " (" +
                                  // Week start
                                  DateFormat((_controller.currentWeek.start.year != DateTime.now().year ? "yy. " : "") + "MMM d.",
                                          I18n.of(context).locale.languageCode)
                                      .format(_controller.currentWeek.start) +
                                  " - " +
                                  // Week end
                                  DateFormat((_controller.currentWeek.start.year != DateTime.now().year ? "yy. " : "") + "MMM d.",
                                          I18n.of(context).locale.languageCode)
                                      .format(_controller.currentWeek.end) +
                                  ")",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),

                        // Next week
                        IconButton(
                            onPressed: () => setState(() {
                                  _controller.next(context);
                                }),
                            splashRadius: 24.0,
                            icon: Icon(FeatherIcons.chevronRight),
                            color: Theme.of(context).colorScheme.secondary),
                      ],
                    ),
                  ),
                  preferredSize: Size.fromHeight(50.0),
                ),
              ),
            ],
            body: _controller.days != null
                ? Column(
                    children: [
                      // Week view
                      _tabController.length > 0
                          ? Expanded(
                              child: TabBarView(
                                physics: BouncingScrollPhysics(),
                                controller: _tabController,
                                // days
                                children: List.generate(
                                  _controller.days!.length,
                                  (tab) => RefreshIndicator(
                                    onRefresh: () => timetableProvider.fetch(week: _controller.currentWeek, db: false),
                                    color: Theme.of(context).colorScheme.secondary,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: _controller.days![tab].length + 2,
                                      itemBuilder: (context, index) {
                                        // Header
                                        if (index == 0)
                                          return Padding(
                                            padding: EdgeInsets.only(top: 8.0, left: 24.0, right: 24.0),
                                            child: PanelHeader(padding: EdgeInsets.only(top: 12.0)),
                                          );

                                        // Footer
                                        if (index == _controller.days![tab].length + 1)
                                          return Padding(
                                            padding: EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
                                            child: PanelFooter(padding: EdgeInsets.only(top: 12.0)),
                                          );

                                        // Body
                                        final Lesson lesson = _controller.days![tab][index - 1];

                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                                          child: PanelBody(
                                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                                            child: LessonTile(lesson, onTap: () {
                                              if (!lesson.isEmpty) LessonView.show(lesson, context: context);
                                            }),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )

                          // Empty week
                          : Expanded(
                              child: Container(
                                child: Center(child: empty),
                              ),
                            ),

                      /*
                       *  Please modify `flutter/lib/src/material/tabs.dart:1271` accordingly
                       *  
                       *  +  wrappedTabs[index] = Padding(
                       *  +    padding: EdgeInsets.symmetric(horizontal: 8.0),
                       *       child: InkWell(
                       *         ...
                       *  +      borderRadius: BorderRadius.circular(8.0),
                       *         ...
                       *  +    ),
                       *       ...
                       *     );
                       *  
                       */

                      // Day selector
                      TabBar(
                        controller: _tabController,
                        // Label
                        labelStyle: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w600),
                        labelPadding: EdgeInsets.zero,
                        labelColor: Theme.of(context).colorScheme.secondary,
                        unselectedLabelColor: AppColors.of(context).text.withOpacity(0.9),
                        // Indicator
                        indicatorPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        indicator: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        overlayColor: MaterialStateProperty.all(Color(0)),
                        // Tabs
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        tabs: List.generate(_tabController.length, (index) {
                          String label = DateFormat("E", I18n.of(context).locale.languageCode).format(_controller.days![index].first.date);
                          return Tab(
                            height: 36,
                            text: label.substring(0, min(2, label.length)),
                          );
                        }),
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }
}
