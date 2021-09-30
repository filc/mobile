import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class FilterBar extends StatefulWidget implements PreferredSizeWidget {
  FilterBar({Key? key, required this.items, required this.controller, this.padding = const EdgeInsets.symmetric(horizontal: 24.0)})
      : assert(items.length == controller.length),
        super(key: key);

  final List<Widget> items;
  final TabController controller;
  final EdgeInsetsGeometry padding;
  final Size preferredSize = Size.fromHeight(42.0);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 48.0,
        padding: widget.padding,
        child: ShaderMask(
            shaderCallback: (Rect bounds) {
              final Color bg = AppColors.of(context).background;
              return LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                widget.controller.index == 0 ? Colors.transparent : bg,
                Colors.transparent,
                Colors.transparent,
                widget.controller.index == widget.controller.length - 1 ? Colors.transparent : bg
              ], stops: [
                0,
                0.1,
                0.9,
                1
              ]).createShader(bounds);
            },
            blendMode: BlendMode.dstOut,
            child: Theme(
              // Disable InkResponse, because it's shape doesn't fit
              // a selected tabs shape & it just looks bad
              data: Theme.of(context).copyWith(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: TabBar(
                  controller: widget.controller,
                  isScrollable: true,
                  physics: const BouncingScrollPhysics(),
                  // Label
                  labelStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0,
                      ),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
                  labelColor: Theme.of(context).colorScheme.secondary,
                  unselectedLabelColor: AppColors.of(context).text.withOpacity(0.65),
                  // Indicator
                  indicatorPadding: const EdgeInsets.all(8.0),
                  indicator: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  overlayColor: MaterialStateProperty.all(Color(0)),
                  // Tabs
                  padding: EdgeInsets.zero,
                  tabs: widget.items),
            )));
  }
}