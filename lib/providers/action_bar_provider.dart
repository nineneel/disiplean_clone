import 'package:disiplean_clone/widgets/reusable/reusable_action_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum ActionBarKey {
  auditorInvitation,
}

class ActionBarProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final Map<ActionBarKey, Widget> _actionBarWidgets = {};

  Map get actionBarWidgets => _actionBarWidgets;

  void addActionBarWidget({
    required ActionBarKey actionBarKey,
    required String label,
    required Function() action,
  }) {
    // build action bar widget using reusable action bar
    Widget buildActionBarWidget = ReusableActionBar(
      label: label,
      onTap: action,
    );

    // create new action bar map
    Map<ActionBarKey, Widget> newActionBar = {actionBarKey: buildActionBarWidget};

    // add builed action bar to _actionBar Widgets
    _actionBarWidgets.addAll(newActionBar);

    // Call notify listerner
    notifyListeners();
  }

  void removeActionBarWidget({
    required ActionBarKey actionBarKey,
  }) {
    _actionBarWidgets.remove(actionBarKey);
    notifyListeners();
  }

  void disposeProvider() {
    actionBarWidgets.clear();
    notifyListeners();
  }
}
