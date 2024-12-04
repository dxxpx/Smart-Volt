import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:smartvolt1/Authentication/LoginScreen.dart';
import 'package:smartvolt1/screens/adminSide/adminAnnouncementsPage.dart';
import 'package:smartvolt1/screens/adminSide/adminFeedbackScreen.dart';
import '../../tools/Menu-item.dart';
import '../userside/AddMachine.dart';
import '../userside/view_solar_devices.dart';
import 'CameraScreen.dart';

class MenuSectionAdmin extends StatefulWidget {
  const MenuSectionAdmin({super.key});

  @override
  State<MenuSectionAdmin> createState() => _MenuSectionAdminState();
}

class _MenuSectionAdminState extends State<MenuSectionAdmin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialze_Cameras();
  }

  void initialze_Cameras() async {
    try {
      cameras = await availableCameras();
      print('CAMERA IS : $cameras');
    } catch (e) {
      print('Error initializing cameras: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Menu_item(
                      context: context,
                      navigate_to: adminAnnouncementScreen(),
                      item_name: "Announcements",
                      icon: Icons.announcement),
                  Menu_item(
                      context: context,
                      navigate_to: adminFeedbackScreen(),
                      item_name: "Feedbacks",
                      icon: Icons.feed),
                ],
              ),
              Row(
                children: [
                  Menu_item(
                      context: context,
                      navigate_to: adminFeedbackScreen(),
                      item_name: "Feedbacks",
                      icon: Icons.feed),
                  Menu_item(
                      context: context,
                      navigate_to: Scaffold(),
                      item_name: "FloorPlan",
                      icon: Icons.home_work_rounded)
                ],
              ),
              Row(
                children: [
                  Menu_item(
                      context: context,
                      navigate_to: AddMachineScreen(),
                      item_name: 'PREDICT MAINTAINANCE',
                      icon: Icons.settings),
                  Menu_item(
                      context: context,
                      navigate_to: ViewSolarDevicesPage(),
                      item_name: 'SOLAR DEVICES',
                      icon: Icons.solar_power),
                ],
              ),
              Row(
                children: [
                  Menu_item(
                      context: context,
                      navigate_to: VehicleTracker(),
                      item_name: "PARKING",
                      icon: Icons.car_crash_rounded)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
