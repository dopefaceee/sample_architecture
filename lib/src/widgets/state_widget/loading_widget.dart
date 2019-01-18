import 'package:flutter/material.dart';
import 'package:atomic_app_customer_musteat_id/atomic_app_customer_musteat_id.dart';

class LoadingWidget extends StatelessWidget {
  final bool visible;

  const LoadingWidget({Key key, @required this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 600),
      opacity: visible ? 1.0 : 0.0,
      child: Container(
        padding: EdgeInsets.all(5.0),
        alignment: FractionalOffset.center,
        child: CircularProgressIndicator(backgroundColor: Colors.red,),
      ),
    );
  }
}
