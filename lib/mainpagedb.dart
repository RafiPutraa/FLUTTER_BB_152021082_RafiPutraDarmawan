import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:onlyfeed/chart.dart';

class MqttManager {
  MqttServerClient? _client;

  MqttManager() {
    _client = MqttServerClient('broker.hivemq.com', 'flutter_subscriber');
    _client?.port = 1883;
    _client?.logging(on: false);
    _client?.keepAlivePeriod = 60;
    _client?.onDisconnected = _onDisconnected;
    _client?.onSubscribed = _onSubscribed;
  }

  Future<void> connect() async {
    try {
      await _client?.connect();
      print('Connected to MQTT');
      _subscribeToTopic('catfeeder-iot-klmpk2-datasuhulingkungan');
      _subscribeToTopic('catfeeder-iot-klmpk2-datasuhuhewan');
      _subscribeToTopic('catfeeder-iot-klmpk2-datainfrared');
    } catch (e) {
      print('Error connecting to MQTT: $e');
    }
  }

  void _onDisconnected() {
    print('Disconnected from MQTT');
  }

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  void _subscribeToTopic(String topic) {
    _client?.subscribe(topic, MqttQos.atMostOnce);
  }

  void disconnect() {
    _client?.disconnect();
  }
}

class MainPageDB extends StatefulWidget {
  const MainPageDB({Key? key}) : super(key: key);

  @override
  _MainPageDBState createState() => _MainPageDBState();
}

class _MainPageDBState extends State<MainPageDB> {
  List<Map<String, dynamic>> temperatureData = [];
  String lastFeedingTimestamp = '';
  String currentTemperature = '';
  String currentPetTemperature = '';
  String currentStockStatus = '';

  MqttManager mqttManager = MqttManager();

  @override
  void initState() {
    super.initState();
    fetchData();
    mqttManager.connect();
    _subscribeToMqttMessages();
  }

  void _subscribeToMqttMessages() {
    mqttManager._client?.updates
        ?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      if (c[0].topic == 'catfeeder-iot-klmpk2-datasuhulingkungan') {
        setState(() {
          currentTemperature = '$payload °C';
        });
      } else if (c[0].topic == 'catfeeder-iot-klmpk2-datasuhuhewan') {
        setState(() {
          currentPetTemperature = '$payload °C';
        });
      } else if (c[0].topic == 'catfeeder-iot-klmpk2-datainfrared') {
        setState(() {
          currentStockStatus = (payload == '1') ? 'IN STOCK' : 'OUT OF STOCK';
        });
      }
    });
  }

  @override
  void dispose() {
    mqttManager.disconnect();
    super.dispose();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://kelompokd2iot.000webhostapp.com/petfeeder/api/getrataratasuhu.php'));

    if (response.statusCode == 200) {
      setState(() {
        temperatureData =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      });

      await fetchLastFeedingTimestamp();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchLastFeedingTimestamp() async {
    final response = await http.get(Uri.parse(
        'https://kelompokd2iot.000webhostapp.com/petfeeder/api/getlastday.php'));

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> lastDayData =
          List<Map<String, dynamic>>.from(json.decode(response.body));

      if (lastDayData.isNotEmpty) {
        setState(() {
          lastFeedingTimestamp = lastDayData[0]['ts'];
        });
      }
    } else {
      throw Exception('Failed to fetch last feeding timestamp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DASHBOARD",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF6BA35D),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(25),
            child: Container(
              height: 380,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF6BA35D),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  data(),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Column(
            children: <Widget>[
              MaterialButton(
                minWidth: 330,
                height: 60,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChartPage(),
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xFF6BA35D)),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  "CHART",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget data() => Column(
        children: [
          SizedBox(height: 30),
          Text(
            'TEMPERATURE',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF406338),
            ),
          ),
          Text(
            currentTemperature,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 30),
          Text(
            'PET TEMPERATURE',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF406338),
            ),
          ),
          Text(
            currentPetTemperature,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 30),
          Text(
            'STOCK',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF406338),
            ),
          ),
          Text(
            currentStockStatus,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 30),
          Text(
            'LAST FEEDING',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF406338),
            ),
          ),
          Text(
            lastFeedingTimestamp,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      );
}
