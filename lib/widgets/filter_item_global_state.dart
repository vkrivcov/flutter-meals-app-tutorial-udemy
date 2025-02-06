import 'package:flutter/material.dart';
import 'package:flutter_meals_app_tutorial_udemy/providers/filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterItem extends ConsumerStatefulWidget {
  const FilterItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.filter,
    required this.initialFilterSelection
  });

  final String title;
  final String subTitle;
  final Filter filter;
  final bool initialFilterSelection;

  @override
  ConsumerState<FilterItem> createState() {
    return _FilterItemState();
  }
}

class _FilterItemState extends ConsumerState<FilterItem> {
  @override
  Widget build(BuildContext context) {
    // this will get initial set and re-trigger the build on any change
    final filterProviderSet = ref.watch(filtersProvider)[widget.filter]!;

    return SwitchListTile(
      // boolean value indicating if its on or off
      value: filterProviderSet,

      // function that receives a boolean value when the switch is toggled
      // NOTE: is checked is the just an action when the switch is toggled
      onChanged: (isChecked) {
        ref.read(filtersProvider.notifier).setFilter(widget.filter, isChecked);

        // NOTE: this is what we did before i.e. passed the value back to the
        // parent who called it (lifted the state)
        // we still need to update the local state so we can
        // setState(() {
        //   filterSet = isChecked;
        // });
        // widget.onFilterChanged(filterSet);
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
