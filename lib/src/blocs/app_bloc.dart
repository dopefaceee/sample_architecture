import 'dart:ui';
import 'package:sample_architecture/src/blocs/bloc_provider.dart';

///bloc for detect device locale
class AppBloc extends BlocBase {

  ///idevice locale dentifier
  Locale deviceLocale;

  @override
  void dispose() {
  }

}