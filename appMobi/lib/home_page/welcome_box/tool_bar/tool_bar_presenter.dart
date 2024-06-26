
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:app_mobi/home_page/home_page.dart';
import 'package:app_mobi/home_page/task_box/data_set_box/data_set_box_presenter.dart';
import 'package:app_mobi/model/adafruit_server.dart';
import 'package:app_mobi/mvp/mvp_presenter.dart';
import 'package:app_mobi/my_share/user.dart';
import 'package:app_mobi/home_page/task_box/task_box.dart';
import 'package:app_mobi/home_page/task_box/task_box_presenter.dart';
import 'package:app_mobi/home_page/welcome_box/tool_bar/tool_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mqtt_client/mqtt_client.dart';

ToolBarPresenter toolBarPresenter = ToolBarPresenter();

class ToolBarPresenter extends MvpPresenter<ToolBarView> {
  DataSetBoxPresenter _datasetboxpresenter = dataSetBoxPresenter;

  bool isCompleted = false;
  bool isConnected = true;
  Map<String, dynamic> userMap = {};
  List<Map<String, dynamic>> RunningDataSet = [];
  List<Map<String, dynamic>> WaitingDataSet = [];
  int id = 1;

  TextEditingController _userController = TextEditingController();
  TextEditingController _keyController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mixer1Controller = TextEditingController();
  TextEditingController _mixer2Controller = TextEditingController();
  TextEditingController _mixer3Controller = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  TextEditingController _cycleController = TextEditingController();
  TextEditingController _starttimeController = TextEditingController();

  TimeOfDay starttime = TimeOfDay.now();

  void getStatus(){
    checkViewAttached();
    bool status = adafruitServer.isConnected();
    isViewAttached ? getView().setStatus(status) : null;
  }

  void updateAreaController(String? area) {
    _areaController.text = area.toString();
  }

  void updateStartTimeController (String s) {
    _starttimeController.text = s;
  }

  Future newtaskOnPressed(BuildContext context) async {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                child: Container(
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.transparent.withOpacity(0.45),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("New task",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      CreateNewTask(context);
                      },
                    icon: Icon(Icons.done_outline_outlined, color: Colors.white, size: 25),
                  ),
                ],
              ),
              content: StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      height: 470,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "Name of New Task",
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              controller: _nameController,
                              style: TextStyle(color: Colors.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Select', style: TextStyle(fontSize: 18, color: Colors.white),),

                                PopupMenuButton<String>(
                                  color: Colors.transparent.withOpacity(0.75),
                                  icon: Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          _areaController.text
                                              .toString()
                                              .isEmpty ? "None" : 'Area ${_areaController
                                        .text.toString()}',
                                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                        // Icon(Icons.arrow_drop_down_outlined, size: 35, color: Colors.white),
                                      ],
                                    ),
                                  ),

                                  onSelected: (String? area) {
                                    setState(() {
                                      _areaController.text = area.toString();
                                    });
                                  },
                                  itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: '1',
                                      child: Text(
                                          'Area 1',
                                          style: TextStyle(fontSize: 18, color: Colors.white))
                                    ),
                                    PopupMenuItem<String>(
                                      value: '2',
                                      child: Text(
                                          'Area 2', style: TextStyle(fontSize: 18, color: Colors.white)),
                                    ),
                                    PopupMenuItem<String>(
                                      value: '3',
                                      child: Text(
                                          'Area 3', style: TextStyle(fontSize: 18, color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "1st Mixer",
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              controller: _mixer1Controller,
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'^\.')),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]')),
                              ],
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "2nd Mixer",
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              controller: _mixer2Controller,
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'^\.')),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]')),
                              ],
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "3rd Mixer",
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              controller: _mixer3Controller,
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'^\.')),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]')),
                              ],
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "Cycle",
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              controller: _cycleController,
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Start Time \n'
                                        '${starttime.hour}:${starttime.minute}',
                                    style: TextStyle(fontSize: 18, color: Colors.white)),
                                SizedBox(width: 10),
                                Container(
                                  // width: 100,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0)),
                                    ),
                                    onPressed: () async {
                                      final TimeOfDay? pickedTime = await showCustomTimePicker(
                                        context: context,
                                        initialTime: starttime, // Thời gian ban đầu
                                      );
                                      if (pickedTime != null) {
                                        setState(() {
                                          starttime = pickedTime;
                                          if (starttime.hour < 10 || starttime.minute < 10) {
                                            if (starttime.hour < 10 && starttime.minute >= 10) {
                                              updateStartTimeController(
                                                  '0${starttime.hour
                                                      .toString()}:${starttime
                                                      .minute
                                                      .toString()}');
                                            }
                                            else if (starttime.minute < 10 && starttime.hour >= 10) {
                                              updateStartTimeController(
                                                  '${starttime.hour
                                                      .toString()}:0${starttime
                                                      .minute
                                                      .toString()}');
                                            }
                                            else {
                                              updateStartTimeController(
                                                  '0${starttime.hour.toString()}:0${starttime.minute.toString()}'
                                              );
                                            }
                                          }
                                          else {
                                            updateStartTimeController(
                                                '${starttime.hour
                                                    .toString()}:${starttime.minute
                                                    .toString()}');
                                          }
                                        });
                                      }
                                    },
                                    // child: Text("Choose",
                                    //     style: TextStyle(color: Colors.black)
                                    // ),
                                    child: Icon(Icons.create_outlined, size: 30, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  }
              ),
            ),
          ],
        );
      },
    );
  }
  Future serverOnPressed(BuildContext context) async => showDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
          },
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                     child: Container(
                        color: Colors.white.withOpacity(0.15),
        ),
        ),
        ),
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Colors.transparent.withOpacity(0.45),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 6,
                    child: Text(
                      "Connect Adafruit",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                ),
                Expanded(
                  flex: 1,
                    child: IconButton(
                      onPressed: () {
                        reconnect(context);
                        getStatus();
                        },
                      icon: Icon(Icons.done, color: Colors.green, size: 35),
                      // child: const Text("Reconnect", style: TextStyle(color: Colors.black))
                    ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  decoration: const InputDecoration(
                      labelText: "User",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  controller: _userController,
                  style: TextStyle(color: Colors.white,fontSize: 18),
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: "Key",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  controller: _keyController,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
          ),
          ],
        );
      });
  Future reconnect(BuildContext context)async {
    adafruitServer.mqttHelp.userName = _userController.text;
    adafruitServer.mqttHelp.password = _keyController.text;
    adafruitServer.mqttHelp.connect();
    Navigator.of(context).pop();
    _userController.clear();
    _keyController.clear();
  }

  Future CreateNewTask(BuildContext context) async {
    if (_nameController.text.isEmpty || _areaController.text.isEmpty ||
        _mixer1Controller.text.isEmpty || _mixer2Controller.text.isEmpty ||
        _mixer3Controller.text.isEmpty ||
        _cycleController.text.isEmpty || _starttimeController.text.isEmpty)
    {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
              child: Container(
              color: Colors.white.withOpacity(0.15),
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.transparent.withOpacity(0.25),
                  title: Row(
                    children: [
                      Icon(Icons.error_outlined, size: 30, color: Colors.red,),
                      SizedBox(width: 20),
                      Text("ERROR", textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),),
                    ],
                  ),
                  content: Text(
                    "Please fill in all fields!", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK", style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                      ),
                      ),
                    ),
                  ],
                ),
              ),
          );

        },
      );
    }
    else {

      User user = User(
          code: 'create',
          name: '${_nameController.text}',
          id: '${id.toString()}',
          area: '${_areaController.text}',
          mixer1: double.parse(_mixer1Controller.text),
          mixer2: double.parse(_mixer2Controller.text),
          mixer3: double.parse(_mixer3Controller.text),
          cycle: int.parse(_cycleController.text),
          starttime: '${_starttimeController.text}'
      );
      userMap = user.toJson();
      String jsonString = JsonEncoder.withIndent(' ').convert(userMap);
      adafruitServer.mqttHelp.publish('kido2k3/feeds/iot-mobile', jsonString);
      userMap["remaining cycle"] = int.parse(_cycleController.text);
      _datasetboxpresenter.getView().addWaitingData();

      Navigator.pop(context);

      id+=1;
      _nameController.text = "";
      _areaController.text = "";
      _mixer1Controller.text = "";
      _mixer2Controller.text = "";
      _mixer3Controller.text = "";
      _cycleController.text = "";
      _starttimeController.text = "";
      starttime = TimeOfDay(hour: 0, minute: 0);
    }
  }

  Future<TimeOfDay?> showCustomTimePicker({
    required BuildContext context,
    required TimeOfDay initialTime,
  })
  async {
    TimeOfDay? selectedTime = initialTime;

     await showModalBottomSheet<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: 350,
                child: Column(
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.access_time_outlined, size: 35, color: Colors.black),
                          Text("Select Time", style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.w300),),
                          TextButton(
                              onPressed: () {Navigator.pop(context);},
                              child: Text("Done", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: CupertinoTimerPicker(
                        mode: CupertinoTimerPickerMode.hm,
                        initialTimerDuration: Duration(
                          hours: initialTime.hour,
                          minutes: initialTime.minute,
                        ),
                        onTimerDurationChanged: (Duration changedTime) {
                          setState(() {
                            selectedTime = TimeOfDay(
                              hour: changedTime.inHours,
                              minute: changedTime.inMinutes.remainder(60),
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
        );
      },
    );
     return selectedTime;
  }
}