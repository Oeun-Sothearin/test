import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Arduino Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothApp(),
    );
  }
}

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection; // Initialize as nullable
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    _scanForDevices();
  }

  void _scanForDevices() async {
    List<BluetoothDiscoveryResult> results = await bluetooth.startDiscovery().toList();
    setState(() {
      devices = results.map((r) => r.device).toList();
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);
      print('Connected to the device');
    } catch (e) {
      print('Could not connect: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Arduino Controller'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: _scanForDevices,
            child: Text('Scan for Devices'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devices[index].name ?? 'Unknown device'),
                  onTap: () => _connectToDevice(devices[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
