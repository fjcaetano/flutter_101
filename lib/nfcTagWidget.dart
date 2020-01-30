import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

class NFCTagWidget extends StatelessWidget {
  final NfcData data;

  NFCTagWidget({@required this.data});

  _renderKeyValue(BuildContext context, String key, String value) => Container(
        margin: EdgeInsets.only(right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                key,
                style: Theme.of(context).textTheme.body2,
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Tag'),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.blueGrey,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Found this NFC Tag',
              style: Theme.of(context).textTheme.headline,
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  _renderKeyValue(context, 'ID', data.id),
                  _renderKeyValue(context, 'Content', data.content),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
