// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:soil_level_monitor_app/services/local_notif_services.dart';

class SoilMostureController extends GetxController {
  LocalNotificationServices localNotificationServices =
      LocalNotificationServices();

  var receivedMessage = '0';
  int percentageVal = 0;

  // generateRandom() {
  //   var random = Random();
  //   percentageVal = random.nextInt(80);

  //   // localNotificationServices.showNotification(percentageVal);
  //   if (percentageVal < 35) {
  //     localNotificationServices.showNotification(percentageVal);
  //   }
  //   print('percentageVal: $percentageVal');
  //   update();
  // }

  /// MQTT EMQX Credentials
  final client = MqttServerClient.withPort(
      'broker.emqx.io', 'soilmoisturesystem_client1', 1883);
  var pongCount = 0, connStatus = 0;
  String topic = 'joshuasoilmoisture';
  final builder = MqttClientPayloadBuilder();
// const subTopic = 'ParkingSystem/ReceiveFromField';

  /// Functions
  Future<void> mqttConnect() async {
    Completer<MqttServerClient> completer = Completer();

    client.logging(on: true);
    client.autoReconnect = true; //FOR AUTORECONNECT
    client.onAutoReconnect = onAutoReconnect;
    client.keepAlivePeriod = 60;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onAutoReconnected = onAutoReconnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMess = MqttConnectMessage().withWillQos(MqttQos.atMostOnce);
    print('EMQX client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('EXAMPLE::socket exception - $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      connStatus = 1;
      print('EMQX client connected');
      completer.complete(client);
    } else {
      /// Use status here rather than state if you also want the broker return code.
      connStatus = 0;
      print(
          'EMQX client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }

    /// Ok, lets try a subscription
    print('Subscribing to $topic topic');
    client.subscribe(topic, MqttQos.atMostOnce);

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
          final recMess = c![0].payload as MqttPublishMessage;

          receivedMessage =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

          print(
              'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is => $receivedMessage.');

          percentageVal = int.parse(receivedMessage);

          if (percentageVal < 35) {
            localNotificationServices.showNotification(percentageVal);
          } else {
            print('$percentageVal is greater than threshold');
          }

          // localNotificationServices.showNotification(percentageVal);

          update();
        }) ??
        client.published?.listen((MqttPublishMessage message) {
          print(
              'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
        }) ??
        1;
    return;
  }

//------------------------------------------------------------------------------

  void mqttSubscribe() {
    // Subscribe to GsmClientTest/ledStatus
    print('Subscribing to the $topic topic');
    client.subscribe(topic, MqttQos.atMostOnce);
  }

  void mqttPublish(String msg) {
    builder.clear();
    builder.addString(msg);

    // Publish it
    print('EXAMPLE::Publishing our topic');
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }

  void mqttUnsubscribe() {
    client.unsubscribe(topic);
  }

  void mqttDisconnect() {
    client.disconnect();
  }

//******************************************************************************/

  void onConnected() {
    print('Connected');
  }

// unconnected
  void onDisconnected() {
    print('Disconnected');
  }

// subscribe to topic succeeded
  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

// subscribe to topic failed
  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

// unsubscribe succeeded
  void onUnsubscribed(String topic) {
    print('Unsubscribed topic: $topic');
  }

// PING response received
  void pong() {
    print('Ping response client callback invoked');
  }

  /// The pre auto re connect callback
  void onAutoReconnect() {
    print(
        'EXAMPLE::onAutoReconnect client callback - Client auto reconnection sequence will start');
  }

  /// The post auto re connect callback
  void onAutoReconnected() {
    print(
        'EXAMPLE::onAutoReconnected client callback - Client auto reconnection sequence has completed');
  }
}
