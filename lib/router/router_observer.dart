import 'package:flutter/material.dart';

class RouterObserver extends NavigatorObserver {
  
  /// The [Navigator] pushed `route`.
  ///
  /// The route immediately below that one, and thus the previously active
  /// route, is `previousRoute`.
  Function(Route route, Route previousRoute) onPush;
  
  /// The [Navigator] popped `route`.
  ///
  /// The route immediately below that one, and thus the newly active
  /// route, is `previousRoute`.
  Function(Route route, Route previousRoute) onPop;
  
  /// The [Navigator] removed `route`.
  ///
  /// If only one route is being removed, then the route immediately below
  /// that one, if any, is `previousRoute`.
  ///
  /// If multiple routes are being removed, then the route below the
  /// bottommost route being removed, if any, is `previousRoute`, and this
  /// method will be called once for each removed route, from the topmost route
  /// to the bottommost route.
  Function(Route route, Route previousRoute) onRemove;
  
  /// The [Navigator] replaced `oldRoute` with `newRoute`.
  Function(Route newRoute, Route previousRoute) onReplace;
  
  /// The [Navigator]'s route `route` is being moved by a user gesture.
  ///
  /// For example, this is called when an iOS back gesture starts.
  ///
  /// Paired with a call to [didStopUserGesture] when the route is no longer
  /// being manipulated via user gesture.
  ///
  /// If present, the route immediately below `route` is `previousRoute`.
  /// Though the gesture may not necessarily conclude at `previousRoute` if
  /// the gesture is canceled. In that case, [didStopUserGesture] is still
  /// called but a follow-up [didPop] is not.
  Function(Route route, Route previousRoute) onStartUserGesture;
  
  /// User gesture is no longer controlling the [Navigator].
  ///
  /// Paired with an earlier call to [didStartUserGesture].
  Function() onStopUserGesture;

  /// RouterObserver initializer
  RouterObserver({
    this.onPush,
    this.onPop,
    this.onRemove,
    this.onReplace,
    this.onStartUserGesture,
    this.onStopUserGesture
  });

  @override
  void didPush(Route route, Route previousRoute) {
    if (this.onPush != null) {
      this.onPush(route, previousRoute);
    }
  }

  @override
  void didPop(Route route, Route previousRoute) {
    if (this.onPop != null) {
      this.onPop(route, previousRoute);
    }
  }
  
  @override
  void didRemove(Route route, Route previousRoute) {
    if (this.onRemove != null) {
      this.onRemove(route, previousRoute);
    }
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    if (this.onReplace != null) {
      this.onReplace(newRoute, oldRoute);
    }
  }

  @override
  void didStartUserGesture(Route route, Route previousRoute) {
    if (this.onStartUserGesture != null) {
      this.onStartUserGesture(route, previousRoute);
    }
  }

  @override
  void didStopUserGesture() {
    if (this.onStopUserGesture != null) {
      this.onStopUserGesture();
    }
  }
}