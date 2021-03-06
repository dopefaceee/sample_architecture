import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget getAppBar({title, context, tabController, myTabs}) {
  return AppBar(
      actions: buildActions(context),
      title: new Text(title),
      elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 3.0,
      bottom: TabBar(
        controller: tabController,
        tabs: myTabs,
        isScrollable: true,
        indicatorWeight: 1.0,
      ));
}

List<Widget> buildActions(context) {
  return <Widget>[infoAction(context)];
}

IconButton infoAction(context) {
  return IconButton(
      icon: Icon(Icons.info_outline),
      onPressed: () => showModalBottomSheet(
          context: context, builder: (BuildContext context) => AtomicUI()));
}

class AtomicUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
