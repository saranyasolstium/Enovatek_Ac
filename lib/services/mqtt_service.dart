import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';

class MqttService {
  final String brokerUrl = 'a1vz4zd8fy3gkp-ats.iot.ap-southeast-1.amazonaws.com';
   //final String brokerUrl = 'mqtt.eclipse.org';
  late final String clientId  ="987654321";
  final String topicPrefix = 'awsMqttSample/';

  MqttServerClient? _client;

  // MqttService() {
  //   clientId = generateClientId();
  // }

  // // Generate a unique client ID using the 'uuid' package
  // String generateClientId() {
  //   final String uniqueId = const Uuid().v4();
  //   final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //   return 'mqttClient_$uniqueId$timestamp';
  // }

  

  Future<void> connect() async {
    _client = MqttServerClient(brokerUrl, clientId);
    final connMessage = MqttConnectMessage()
        .withClientIdentifier('clientId')
        .keepAliveFor(60)
        .startClean();
    _client?.connectionMessage = connMessage;
    try {
      await _client!.connect();
    } catch (e) {
      print('MQTT client exception: $e');
    }
  }


  void disconnect() {
    try {
      _client!.disconnect();
      print('Disconnected from MQTT broker');
    } catch (e) {
      print('Error disconnecting from MQTT broker: $e');
    }
  }

 Future<void> publish(String deviceId, String actionType, String value) async {
  if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
    final topic = '$topicPrefix$deviceId';
    final payload = {
      'device': 'AC',
      'action_type': actionType,
      'value': value,
    };
    final message = MqttClientPayloadBuilder()
        .addString(json.encode(payload))
        .payload;

    try {
      await _client!.publishMessage(topic, MqttQos.exactlyOnce, message!);
      print('Published MQTT message to $topic: $message');
    } catch (e) {
      print('Error publishing MQTT message: $e');
    }
  } else {
    print('Not connected to MQTT broker. Cannot publish message.');
  }
}

Future<void> subscribe(String deviceId,
    Function(MqttReceivedMessage<MqttMessage>) callback) async {
  if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
    final topic = '$topicPrefix$deviceId';
    try {
      _client?.subscribe(topic, MqttQos.atLeastOnce);
      _client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        for (var message in messages) {
          if (message.topic == topic) {
            callback(message);
          }
        }
      });
      print('Subscribed to MQTT topic: $topic');
    } catch (e) {
      print('Error subscribing to MQTT topic: $e');
    }
  } else {
    print('Not connected to MQTT broker. Cannot subscribe to topic.');
  }
}

  Future<void> connectWithRetry(int maxRetries) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        await connect();
        return; 
      } catch (e) {
        print('Connection attempt $retryCount failed: $e');
        retryCount++;
        await Future.delayed(Duration(seconds: 5)); 
      }
    }

    print('Max retry count reached. Connection failed.');
  }
}