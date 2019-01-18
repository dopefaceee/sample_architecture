import 'package:flutter/material.dart';
import 'package:sample_architecture/src/blocs/app_bloc.dart';
import 'package:sample_architecture/src/blocs/bloc_provider.dart';
import 'package:sample_architecture/src/screens/tabs/tab_object.dart';
import 'package:sample_architecture/src/data/util/helper_function.dart';
import 'package:sample_architecture/src/widgets/common_widget/common_widget.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _MyTabbedPageState createState() => new _MyTabbedPageState(title);
}

class _MyTabbedPageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  TabBarView tabBarView;
  final String title;
  TabObject nowPlayingTab;

  bool hasBuiltTabs = false;

  _MyTabbedPageState(this.title);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //Moved init here because we need the device locale from the AppBloc for the upcoming movies
    //and can't call an inherited widget inside initState
    AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    buildTabs(appBloc.deviceLocale);
  }

  void buildTabs(Locale deviceLocale) {
    if (hasBuiltTabs) {
      return;
    }

    nowPlayingTab = TabObject(TabKey.kNowPlaying, getNowPlayingProvider());

    _tabController = new TabController(vsync: this, length: tabs.length);
    _tabController.addListener(_handleTabSelection);

    tabBarView = TabBarView(
      controller: _tabController,
      children: [
        nowPlayingTab.provider,
      ],
    );
    hasBuiltTabs = true;
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      return;
    }
  }

  @override
  void dispose() {
    print('dispose home screen');
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: getAppBar(
          tabController: _tabController,
          title: title,
          myTabs: [
            nowPlayingTab.tab,
          ],
          context: context),
      body: tabBarView,
    );
  }
}
