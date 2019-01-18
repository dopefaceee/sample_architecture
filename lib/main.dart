import 'package:flutter/material.dart';
import 'package:sample_architecture/src/blocs/app_bloc.dart';
import 'package:sample_architecture/src/blocs/bloc_provider.dart';
import 'package:sample_architecture/src/data/constants/api_constants.dart';
import 'package:sample_architecture/src/screens/home_screen.dart';

///Requirement for Architecture
///
/// BLoC Pattern
/// RxDart
/// json_annotation
/// http

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final title = APP_NAME;

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = AppBloc();

    //Define top app level bloc for app
    return BlocProvider<AppBloc>(
      child: MaterialApp(
        localeResolutionCallback:
            (Locale locale, Iterable<Locale> supportedLocales) {
          appBloc.deviceLocale = locale;
        },
        title: title,
        theme: ThemeData.light(),
        //Add movie bloc for stream data, and pass api to child tree
        home: HomePage(title: title),
      ),
      bloc: appBloc,
    );
  }
}
