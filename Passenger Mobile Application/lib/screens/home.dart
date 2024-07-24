import 'package:bus_karo/widgets/contact_us.dart';
import 'package:bus_karo/widgets/user_profile.dart';
import 'package:bus_karo/widgets/home_screen_map.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'notifications.dart';


class HomeScreen extends StatefulWidget
{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen>
{

  Widget bodyContent = const HomeScreenMap();
  int index = 1;
  String appBarTitle = "Track Buses";


  void _openNotificationScreen()
  {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationScreen(),));
  }


  @override
  Widget build(BuildContext context) {

    if(index == 0) appBarTitle="User Profile";
    else if(index == 1) appBarTitle="Track Buses";
    else if(index == 2) appBarTitle="Contact Us";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade400,
        title: Text(appBarTitle,style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
              onPressed: _openNotificationScreen,
              icon: const Icon(Icons.notifications_none_rounded,color: Colors.white,size: 27,))
        ],
      ),



      body: bodyContent,



      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.textIn,
        initialActiveIndex: 1,
        items: const [
          TabItem(icon: Icons.person, title: "Profile"),
          TabItem(icon: Icons.directions_bus, title: "Track"),
          TabItem(icon: Icons.headphones, title: "Contact Us"),
        ],
        onTap: (localIndex) {
          if(localIndex == 0)
            {
              setState(() {
                index = 0;
                bodyContent = const UserProfile();
              });
            }
          else if(localIndex == 1)
          {
            setState(() {
              index = 1;
              bodyContent = const HomeScreenMap();
            });
          }
          if(localIndex == 2)
          {
            setState(() {
              index = 2;
              bodyContent = ContactUs();
            });
          }
        },
      ),
      );
  }
}