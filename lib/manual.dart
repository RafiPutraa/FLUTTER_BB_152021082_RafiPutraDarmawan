import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttManager {
  MqttServerClient? _client;

  MqttManager() {
    _client = MqttServerClient('broker.hivemq.com', 'flutter_publisher');
    _client?.port = 1883;
    _client?.logging(on: false);
    _client?.keepAlivePeriod = 60;
    _client?.onDisconnected = _onDisconnected;
  }

  Future<void> connect() async {
    try {
      await _client?.connect();
      print('Connected to MQTT');
    } catch (e) {
      print('Error connecting to MQTT: $e');
    }
  }

  void _onDisconnected() {
    print('Disconnected from MQTT');
  }

  void publish(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    _client?.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void disconnect() {
    _client?.disconnect();
  }
}

class ManualPage extends StatelessWidget {
  const ManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MANUAL FEEDING",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF6BA35D),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TAP HERE TO FEED!',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            button(context), // Pass context to the button function
          ],
        ),
      ),
    );
  }

  Widget button(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 50),
        child: InkWell(
          onTap: () async {
            MqttManager mqttManager = MqttManager();
            await mqttManager.connect();
            mqttManager.publish('control_servo_iot_d2', '1');
            popup(context);
          },
          child: CircleAvatar(
            radius: 150,
            backgroundColor: Color(0xFF6BA35D),
            child: Image.asset(
              'assets/images/buttonfeed.png',
              width: 300,
              height: 300,
            ),
          ),
        ),
      );

  void popup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Feeding Successful"),
          content: Text("Your pet has been fed successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(
                  color: Color(0xFF6BA35D),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
