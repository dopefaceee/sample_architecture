import 'package:sample_architecture/src/blocs/bloc_provider.dart';
import 'package:flutter/material.dart';

enum TabKey { kNowPlaying }

const Map<TabKey, String> tabs = {
  TabKey.kNowPlaying: "Now Playing",
};

class TabObject {
  Tab tab;
  BlocProvider provider;

  TabObject(TabKey tabKey, BlocProvider blocProvider) {
    tab = Tab(text: tabs[tabKey]);
    provider = blocProvider;
  }
}