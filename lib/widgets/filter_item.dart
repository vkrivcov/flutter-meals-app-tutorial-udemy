import 'package:flutter/material.dart';

class FilterItem extends StatefulWidget {
  const FilterItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.initialFilterSelection,
    required this.onFilterChanged
  });

  final String title;
  final String subTitle;
  final bool initialFilterSelection;

  // function to pass state changes
  final ValueChanged<bool> onFilterChanged;

  @override
  State<FilterItem> createState() {
    return _FilterItemState();
  }
}

class _FilterItemState extends State<FilterItem> {
  bool filterSet = false;

  @override
  void initState() {
    super.initState();
    filterSet = widget.initialFilterSelection;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      // boolean value indicating if its on or off
      value: filterSet,

      // function that receives a boolean value when the switch is toggled
      // NOTE: is checked is the just an action when the switch is toggled
      onChanged: (isChecked) {
        setState(() {
          filterSet = isChecked;
        });
        widget.onFilterChanged(filterSet);
      },

      title: Text(
        widget.title,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Theme.of(context).colorScheme.onSurface),
      ),

      // simply for extra explanation
      subtitle: Text(
        widget.subTitle,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Theme.of(context).colorScheme.onSurface),
      ),

      // color when switch is activated or not
      // onTertiary: as per docs balance color between primary and secondary
      activeColor: Theme.of(context).colorScheme.primary,
      contentPadding: const EdgeInsets.only(left: 34, right: 22),
    );
  }
}
