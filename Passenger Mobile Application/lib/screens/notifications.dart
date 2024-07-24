import 'dart:convert';
import 'package:bus_karo/data/notifications_data.dart';
import 'package:bus_karo/models/notification.dart';
import 'package:bus_karo/widgets/single_notification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class NotificationScreen extends StatefulWidget
{
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() {
    return _NotificationScreenState();
  }

}


class _NotificationScreenState extends State<NotificationScreen>
{

  Widget screenContent = const Center(child: Text("No Notifications",style: TextStyle(fontSize: 21,color: Colors.black)),);
  bool isLoading = false;

  void _onBackPress()
  {
    Navigator.of(context).pop();
  }

  void _loadNotifications() async
  {
    availableNotifications.clear();
    setState(() {
      isLoading=true;
    });
    final response = await http.get(Uri.parse('https://ap-south-1.aws.neurelo.com/rest/Notifications'), headers: {"X-API-KEY": "neurelo_9wKFBp874Z5xFw6ZCfvhXSWjn5HaGax0iEIv7FlN0VhmOVVtFbJEXJBsgFnFGucZ++OTzYmBZ2xlTwkG3Xbt80xHUKdR788dvKiF8ipMZKSmIXyEJU7NAgrMIZ7wbDmQhq8RNfLKr5CuLxMTzqxgqsFHBDd70swCInlghCPJj8GgZubiiqnMNhcw1AXkJACn_bF9SeH4Sv8OeECAqt8ONQKXFxJvnErwoo6bL+2rAnXk="});
    final responseBody = await jsonDecode(response.body);
    final notificationsMapList = await responseBody['data'];

    for(final notification in notificationsMapList)
      {
        availableNotifications.add(
          NotificationData(
              message: notification['notifMsg'],
              notificationType: notification['notifType'],
              notifUID: notification['notifUID']
          )
        );
      }


      if(availableNotifications.isNotEmpty)
        {
          setState(() {
            screenContent = SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(9, 17, 17, 17),
              child: Column(
                children: [
                  ...availableNotifications.map((e) => SingleNotification(notification: e))
                ],
              ),
            );
            isLoading=false;
          });
        }
      else if(availableNotifications.isEmpty)
        {
          setState(() {
            screenContent = const Center(child: Text("No Notifications",style: TextStyle(fontSize: 21,color: Colors.black)),);
            isLoading=false;
          });
        }
  }

  @override
  void initState() {
    _loadNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    if(isLoading)
      {
        screenContent = const Center(child: CircularProgressIndicator(),);
      }

    return Scaffold(
        appBar : AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back,color: Colors.white), onPressed: _onBackPress),
          backgroundColor: Colors.blueAccent.shade400,
          title: const Text("Notifications",style: TextStyle(color: Colors.white)),
        ),

        body: screenContent

    );
  }

}