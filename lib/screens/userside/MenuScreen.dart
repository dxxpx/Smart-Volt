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
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserFeedbackScreen(),
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
                              Icons.add_comment_rounded,
                              size: 35,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "FEEDBACKS",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnnouncementsUser(),
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
                              Icons.speaker_sharp,
                              size: 35,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "ANNOUNCEMENTS",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              //Set Target , predictive Maintainance
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddMachineScreen(),
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
                              Icons.settings,
                              size: 35,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "PREDICT MAINTAINANCE",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SetTargetPage(),
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
                              Icons.pinch_sharp,
                              size: 35,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "SET TARGET",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              //Bill, electricians
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TotalAmountPage(),
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
                              Icons.monetization_on,
                              size: 35,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "CALCULATE BILL",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewElectriciansPage(),
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
                              Icons.people,
                              size: 35,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "VIEW ELECTRICIANS",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              //View Rooms, Solar Devices
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewSolarDevicesPage(),
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
                              Icons.solar_power,
                              size: 35,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "SOLAR DEVICES",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewRoomsPage(),
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
                              Icons.home,
                              size: 35,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "VIEW ROOMS",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
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
