import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_101/redux/actions.dart';
import 'package:flutter_101/redux/reducers.dart' as Reducers;
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:redux/redux.dart';

StreamSubscription<RangingResult> _subscription;

List<Middleware<Reducers.State>> createBeaconsMiddleware() => [
      TypedMiddleware<Reducers.State, StartScanningBeconsAction>(_startScanner),
      TypedMiddleware<Reducers.State, StopScanningBeaconsAction>(_stopScanner),
      TypedMiddleware<Reducers.State, DidFoundBeaconAction>(_logFoundBeacons),
    ];

_startScanner(Store<Reducers.State> store, StartScanningBeconsAction action,
    NextDispatcher next) async {
  try {
    if (_subscription != null) {
      return;
    }

    print('Initializing scan');
    await flutterBeacon.initializeAndCheckScanning;

    print('Scanning');
    _subscription = flutterBeacon
        .ranging(action.regions)
        .listen((data) => store.dispatch(DidFoundBeaconAction(result: data)),
            // (_) => {},
            onError: (err) => store.dispatch(BeaconErrorAction(error: err)),
            onDone: () => store.dispatch(StopScanningBeaconsAction));
  } on PlatformException catch (e) {
    next(BeaconErrorAction(error: e as dynamic));
  } finally {
    next(action);
  }
}

_stopScanner(Store<Reducers.State> store, StopScanningBeaconsAction action,
    NextDispatcher next) async {
  if (_subscription != null) {
    print('Stopping scanner');
    await _subscription.cancel();
    _subscription = null;
  }

  next(action);
}

_logFoundBeacons(Store<Reducers.State> store, DidFoundBeaconAction action,
    NextDispatcher next) {
  action.result.beacons.forEach((b) => print(
      'Beacon - ${b.proximityUUID}; Acc - ${b.accuracy}; Prox - ${b.proximity}; C - ${((1 - b.accuracy) * 5).round() * 100}'));
  next(action);
}
