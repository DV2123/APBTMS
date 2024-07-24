import 'package:flutter/cupertino.dart';
import 'package:bus_karo/models/notification.dart' as noti;

class SingleNotification extends StatelessWidget {
  noti.NotificationData notification;
  SingleNotification({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 7),
            decoration: const BoxDecoration(
                border: Border.fromBorderSide(BorderSide(
                    style: BorderStyle.solid,
                    width: 1,
                    color: CupertinoColors.black)
                )
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                notification.icon,
                const SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: Text(
                    notification.message,
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
        ),
        const SizedBox(
          height: 23,
        ),
      ],
    );
  }
}


