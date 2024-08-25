import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicktasks/helpers/app_color.dart';

class CustomTab extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomTab(
      {super.key,
      required this.text,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        padding: EdgeInsets.symmetric(
          vertical: 4.h,
        ),
        decoration: ShapeDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Colors.transparent,
          shape: StadiumBorder(
              side: BorderSide(
                  color:
                      isSelected ? Colors.transparent : Colors.grey.shade300)),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}

class CustomTabView extends StatefulWidget {
  final List<String> tabTitles;
  final List<Widget> tabContents;

  const CustomTabView(
      {super.key, required this.tabTitles, required this.tabContents});

  @override
  _CustomTabViewState createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
          decoration: ShapeDecoration(
            color: Colors.transparent,
            shape:
                StadiumBorder(side: BorderSide(color: Theme.of(context).grey)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(widget.tabTitles.length, (index) {
              return Expanded(
                child: CustomTab(
                  text: widget.tabTitles[index],
                  isSelected: _selectedIndex == index,
                  onTap: () => _onTabTapped(index),
                ),
              );
            }),
          ),
        ),
        20.verticalSpace,
        Expanded(child: widget.tabContents[_selectedIndex]),
      ],
    );
  }
}
