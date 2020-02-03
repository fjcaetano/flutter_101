import 'package:flutter/material.dart';
import 'package:flutter_101/models/appRoutes.dart';
import 'package:flutter_101/redux/actions.dart';
import 'package:flutter_101/redux/reducers.dart' as Reducers;
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';

class _ListManagerViewModel {
  static final beaconColors = {
    Proximity.unknown: (double p) => Colors.grey,
    Proximity.far: (double p) => Colors.red[((1 - p) * 5).round() * 100],
    Proximity.near: (double p) => Colors.yellow[((1 - p) * 5).round() * 100],
    Proximity.immediate: (double p) =>
        Colors.green[((1 - p) * 5).round() * 100],
  };

  final Store<Reducers.State> store;
  final List<Beacon> beacons;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final bool isScanningBeacons;

  _ListManagerViewModel.converter(this.store)
      : beacons = store.state.foundBeacons.values.toList(),
        isScanningBeacons = store.state.isScanningBeacons;

  void navigateToTODO(String listId) {
    store.dispatch(
        NavigatePushAction(routeName: AppRoutes.todo, arguments: listId));
  }

  void toggleBeaconScanner() {
    store.dispatch(isScanningBeacons
        ? StopScanningBeaconsAction()
        : StartScanningBeconsAction());
  }

  void discardBeacons() {
    store.dispatch(DiscardBeaconsResultAction());
  }
}

class ListManager extends StatefulWidget {
  ListManager({Key key}) : super(key: key);

  @override
  _ListManagerState createState() => _ListManagerState();
}

class _ListManagerState extends State<ListManager> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<Reducers.State, _ListManagerViewModel>(
        converter: (s) => _ListManagerViewModel.converter(s),
        builder: (c, vm) => Scaffold(
              appBar: AppBar(
                title: Text('My Lists'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: vm.discardBeacons,
                  ),
                ],
              ),
              body: Container(
                color:
                    vm.isScanningBeacons ? Colors.blueGrey : Colors.grey[400],
                child: AnimatedList(
                  key: vm.listKey,
                  padding: EdgeInsets.all(20),
                  initialItemCount: vm.beacons.length, // 0
                  itemBuilder: (c, idx, a) => FadeTransition(
                    key: Key(vm.beacons[idx].proximityUUID),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      color: _ListManagerViewModel.beaconColors[
                          vm.beacons[idx].proximity](vm.beacons[idx].accuracy),
                      child: ListTile(
                        title: Text(vm.beacons[idx].proximityUUID,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline),
                      ),
                    ),
                    opacity: a,
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: vm.toggleBeaconScanner,
                child:
                    Icon(vm.isScanningBeacons ? Icons.stop : Icons.play_arrow),
              ),
            ));
  }
}
