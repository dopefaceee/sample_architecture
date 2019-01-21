//Generic Interface for all BLoCs
import 'package:flutter/widgets.dart';

///create abstract for dispose
abstract class BlocBase {
  ///abstract method for disposing stream
  void dispose();
}

///generic bloc provider class
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  ///define child of bloc
  final Widget child;
  ///define generic bloc
  final T bloc;

  ///constructor for parameter
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);


  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  ///named function for search bloc to ancestor tree
  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>>{

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
  ///disposing the blocs here, means that when switching tabs and the bloc is destroyed,
  ///when coming back to that tab, the stream controller is closed and pagination doesn't work
    print('disposing ${widget.bloc}');
    widget.bloc.dispose();
    super.dispose();
  }
}