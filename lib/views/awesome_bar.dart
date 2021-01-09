import 'package:flutter/material.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/utils/frappe_icon.dart';

import '../services/navigation_service.dart';
import '../config/palette.dart';

import '../app/locator.dart';
import '../app/router.gr.dart';

import '../utils/config_helper.dart';
import '../utils/enums.dart';

class Awesombar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: () {
        showSearch(context: context, delegate: AwesomeSearch());
      },
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        enabledBorder: InputBorder.none,
        fillColor: Palette.bgColor,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: FrappeIcon(
            FrappeIcons.search,
          ),
        ),
        prefixIconConstraints: BoxConstraints(
          minHeight: 42,
          maxHeight: 42,
        ),
        hintText: 'Search',
      ),
    );
  }
}

class AwesomeSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var awesomeBarItems = [];
    var activeModules = ConfigHelper().activeModules;
    // activeModules.keys.forEach((module) {
    //   awesomeBarItems.add(
    //     {
    //       "type": "Module",
    //       "value": module,
    //       "label": "Open $module",
    //     },
    //   );
    // });
    activeModules.values.forEach(
      (value) {
        (value as List).forEach(
          (v) {
            awesomeBarItems.add(
              {
                "type": "Doctype",
                "value": v,
                "label": "$v List",
              },
            );
            awesomeBarItems.add(
              {
                "type": "New Doc",
                "value": v,
                "label": "New $v",
              },
            );
          },
        );
      },
    );

    awesomeBarItems = awesomeBarItems.where((element) {
      var lowercaseQuery = query.toLowerCase();
      return (element["value"] as String)
          .toLowerCase()
          .contains(lowercaseQuery);
    }).toList();

    return ListView.builder(
      itemCount: awesomeBarItems.length,
      itemBuilder: (_, index) {
        var item = awesomeBarItems[index];
        return ListTile(
          title: Text(item["label"]),
          onTap: () {
            if (item["type"] == "Doctype") {
              locator<NavigationService>().navigateTo(
                Routes.customListView,
                arguments: CustomListViewArguments(
                  doctype: item["value"],
                ),
              );
            } else if (item["type"] == "New Doc") {
              locator<NavigationService>().navigateTo(
                Routes.newDoc,
                arguments: NewDocArguments(
                  doctype: item["value"],
                ),
              );
            } else if (item["type"] == "Module") {
              // locator<NavigationService>().navigateTo(
              //   Routes.home,
              //   arguments: DoctypeViewArguments(
              //     module: item["value"],
              //   ),
              // );
            }
          },
        );
      },
    );
  }
}