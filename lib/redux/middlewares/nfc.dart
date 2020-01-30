import 'package:flutter_101/models/appRoutes.dart';
import 'package:flutter_101/redux/actions.dart';
import 'package:flutter_101/redux/reducers.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:redux/redux.dart';

List<Middleware<State>> createNFCMiddleware() => [
      TypedMiddleware<State, StartNFCWatcherAction>(_startNFCWatcher),
      TypedMiddleware<State, StopNFCWatcherAction>(_stopNFCWatcher),
    ];

void _startNFCWatcher(Store<State> store, _, __) {
  print('Starting watcher');
  Stream.fromFuture(FlutterNfcReader.checkNFCAvailability())
      .where((avail) => avail == NFCAvailability.available)
      .asyncExpand((_) => FlutterNfcReader.onTagDiscovered(
          instruction: 'Hold the phone near the object to be scanned'))
      .map((d) => NavigatePushAction(routeName: AppRoutes.NFCTag, arguments: d))
      .listen(store.dispatch,
          onError: (e) => print('ERROR - $e'), onDone: () => print('Done'));
}

void _stopNFCWatcher(Store<State> store, _, __) {
  FlutterNfcReader.stop();
}
