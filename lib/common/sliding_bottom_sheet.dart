import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart' as ss;

void showSlidingBottomSheet({required Widget child, required BuildContext context}) => ss.showSlidingBottomSheet(context,
    useRootNavigator: true,
    builder: (context) => ss.SlidingSheetDialog(
          cornerRadius: 16,
          cornerRadiusOnFullscreen: 0,
          avoidStatusBar: true,
          color: AppColors.of(context).background,
          duration: Duration(milliseconds: 400),
          snapSpec: const ss.SnapSpec(
            snap: true,
            snappings: [0.5, 1.0],
            positioning: ss.SnapPositioning.relativeToAvailableSpace,
          ),
          headerBuilder: (context, state) {
            return Material(
              color: AppColors.of(context).background,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    height: 4.0,
                    width: 60.0,
                    margin: EdgeInsets.all(12.0),
                  ),
                ],
              ),
            );
          },
          builder: (context, state) {
            return Material(
              color: AppColors.of(context).background,
              child: Padding(padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 8.0), child: child),
            );
          },
        ));
