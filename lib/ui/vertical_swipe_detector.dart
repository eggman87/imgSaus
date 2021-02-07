library swipedetector;

import 'package:flutter/material.dart';

/// Note: this code is taken from swipe detector plugin, and just modified for vertical only swipe detection.
class VerticalSwipeConfiguration {
  //Vertical swipe configuration options
  double verticalSwipeMaxWidthThreshold = 50.0;
  double verticalSwipeMinDisplacement = 100.0;
  double verticalSwipeMinVelocity = 300.0;

  VerticalSwipeConfiguration({
    double verticalSwipeMaxWidthThreshold,
    double verticalSwipeMinDisplacement,
    double verticalSwipeMinVelocity,
  }) {
    if (verticalSwipeMaxWidthThreshold != null) {
      this.verticalSwipeMaxWidthThreshold = verticalSwipeMaxWidthThreshold;
    }

    if (verticalSwipeMinDisplacement != null) {
      this.verticalSwipeMinDisplacement = verticalSwipeMinDisplacement;
    }

    if (verticalSwipeMinVelocity != null) {
      this.verticalSwipeMinVelocity = verticalSwipeMinVelocity;
    }
  }
}

class VerticalSwipeDetector extends StatefulWidget {

  final Widget child;
  final Function() onSwipeUp;
  final Function() onSwipeDown;
  final VerticalSwipeConfiguration swipeConfiguration;

  VerticalSwipeDetector({@required this.child,
    this.onSwipeUp,
    this.onSwipeDown,
    VerticalSwipeConfiguration swipeConfiguration})
      : this.swipeConfiguration = swipeConfiguration == null
      ? VerticalSwipeConfiguration()
      : swipeConfiguration;

  @override
  State<StatefulWidget> createState() {
    return VerticalSwipeDetectorState();
  }
}

class VerticalSwipeDetectorState extends State<VerticalSwipeDetector> {

  DragStartDetails startVerticalDragDetails;
  DragUpdateDetails updateVerticalDragDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onVerticalDragStart: (dragDetails) {
        startVerticalDragDetails = dragDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        updateVerticalDragDetails = dragDetails;
      },
      onVerticalDragEnd: (endDetails) {
        double dx = updateVerticalDragDetails.globalPosition.dx -
            startVerticalDragDetails.globalPosition.dx;
        double dy = updateVerticalDragDetails.globalPosition.dy -
            startVerticalDragDetails.globalPosition.dy;
        double velocity = endDetails.primaryVelocity;

        //Convert values to be positive
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        double positiveVelocity = velocity < 0 ? -velocity : velocity;

        if (dx > widget.swipeConfiguration.verticalSwipeMaxWidthThreshold) return;
        if (dy < widget.swipeConfiguration.verticalSwipeMinDisplacement) return;
        if (positiveVelocity < widget.swipeConfiguration.verticalSwipeMinVelocity)
          return;

        if (velocity < 0) {
          //Swipe Up
          if (widget.onSwipeUp != null) {
            widget.onSwipeUp();
          }
        } else {
          //Swipe Down
          if (widget.onSwipeDown != null) {
            widget.onSwipeDown();
          }
        }
      },
    );
  }
}
