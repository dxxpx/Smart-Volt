import 'package:flutter/material.dart';
import 'package:smartvolt1/screens/userside/feedbackScreen.dart';
import 'package:smartvolt1/screens/userside/set_target.dart';
import 'package:smartvolt1/screens/userside/total_bill_amount.dart';
import 'package:smartvolt1/screens/userside/view%20rooms.dart';
import 'package:smartvolt1/screens/userside/view_electritions.dart';
import 'package:smartvolt1/screens/userside/view_solar_devices.dart';
import '../../services/LLM.dart';
import 'AddMachine.dart';
import 'AnnouncementsPageUser.dart';
import '../charts/LinearChart.dart';
import 'leaderboard_page.dart';
import '../../tools/Menu-item.dart';

class Menuscreen extends StatefulWidget {
  const Menuscreen({super.key});

  @override
  State<Menuscreen> createState() => _MenuscreenState();
}

class _MenuscreenState extends State<Menuscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              // feedback, announcements
              Row(
                children: [
                  Menu_item(
                      context: context,
                      navigate_to: UserFeedbackScreen(),
                      item_name: 'FEEDBACKS',
                      icon: Icons.feedback),
                  Menu_item(
                      context: context,
                      navigate_to: AnnouncementsUser(),
                      item_name: 'ANNOUNCEMENTS',
                      icon: Icons.speaker_sharp),
                ],
              ),
              //Set Target , predictive Maintainance
              Row(
                children: [
                  Menu_item(
                      context: context,
                      navigate_to: AddMachineScreen(),
                      item_name: 'PREDICT MAINTAINANCE',
                      icon: Icons.settings),
                  Menu_item(
                      context: context,
                      navigate_to: SetTargetPage(),
                      item_name: 'SET TARGET',
                      icon: Icons.pinch_sharp)
                ],
              ),
              //Bill, electricians
              Row(
                children: [
                  Menu_item(
                      context: context,
                      navigate_to: TotalAmountPage(),
                      item_name: 'CALCULATE BILL',
                      icon: Icons.monetization_on),
                  Menu_item(
                      context: context,
                      navigate_to: ViewElectriciansPage(),
                      item_name: 'VIEW ELECTRICIANS',
                      icon: Icons.people),
                ],
              ),
              //View Rooms, Solar Devices
              Row(
                children: [
                  Menu_item(
                      context: context,
                      navigate_to: ViewSolarDevicesPage(),
                      item_name: 'SOLAR DEVICES',
                      icon: Icons.solar_power),
                  Menu_item(
                      context: context,
                      navigate_to: ViewRoomsPage(),
                      item_name: 'VIEW ROOMS',
                      icon: Icons.home),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LeaderboardPage(),
                            ));
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.blue.shade50),
                        child: Column(
                          children: [
                            Icon(
                              Icons.leaderboard,
                              size: 35,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "LEADERBOARD",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChatPage()));
        },
      ),
    );
  }
}
