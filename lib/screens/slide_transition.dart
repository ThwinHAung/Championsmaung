import 'package:flutter/material.dart';

class SlideTransition1 extends PageRouteBuilder {
  final String routeId;

  SlideTransition1({required this.routeId})
      : super(
          pageBuilder: (context, animation, anotherAnimation) {
            // You need to return the appropriate page widget based on routeId
            // For now, this will return a placeholder widget.
            return Container(); // Replace with your logic to get the actual page
          },
          transitionDuration: Duration(milliseconds: 1000),
          reverseTransitionDuration: Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.fastLinearToSlowEaseIn,
              reverseCurve: Curves.fastOutSlowIn,
            );

            final slideAnimation = Tween<Offset>(
              begin: Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(curvedAnimation);

            return SlideTransition(
              position: slideAnimation,
              child: child,
            );
          },
        );
}

class SlideTransition1withID extends PageRouteBuilder {
  final String routeId;
  final int id;

  SlideTransition1withID({required this.routeId, required this.id})
      : super(
          pageBuilder: (context, animation, anotherAnimation) {
            // Replace with your logic to get the actual page based on `routeId` and `id`
            return _getPageForRouteId(routeId, id);
          },
          transitionDuration: Duration(milliseconds: 1000),
          reverseTransitionDuration: Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.fastLinearToSlowEaseIn,
              reverseCurve: Curves.fastOutSlowIn,
            );

            final slideAnimation = Tween<Offset>(
              begin: Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(curvedAnimation);

            return SlideTransition(
              position: slideAnimation,
              child: child,
            );
          },
        );

  static Widget _getPageForRouteId(String routeId, int id) {
    // Define your logic to return the correct page widget
    // For now, we return a placeholder widget
    return Container(); // Replace with your logic to fetch or create the page widget
  }
}
