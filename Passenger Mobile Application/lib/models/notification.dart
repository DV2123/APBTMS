import 'package:flutter/material.dart';

Icon notificationTypeIconProvider(String notificationType)
{
  if(notificationType.toUpperCase().trim() == "ROUTE_CHANGE")
    {
      return const Icon(Icons.route_rounded,size: 34,);
    }
  else if(notificationType.toUpperCase().trim() == "TIME_CHANGE")
   {
     return const Icon(Icons.access_time, size: 34);
   }
 else
    {
      return const Icon(Icons.notifications_active_outlined, size: 34);
    }
}

class NotificationData
{
  String notifUID;
  String message;
  String notificationType;
  Icon icon;
  NotificationData({required this.message, required this.notificationType, required this.notifUID}) : icon = notificationTypeIconProvider(notificationType);
}