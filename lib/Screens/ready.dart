import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yogaapp/Screens/WorkOutDet.dart';
import 'package:yogaapp/model/model.dart';
import 'package:yogaapp/services/yogadb.dart';

class rUready extends StatelessWidget {
  String YogaTableName;
  rUready({required this.YogaTableName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimerModel>(
      create: (context) => TimerModel(context, YogaTableName: YogaTableName),
      child: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2 - 100,
                ),
                Text(
                  "ARE YOU READY?",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 40,
                ),
                Consumer<TimerModel>(builder: (context, myModel, child) {
                  return Text(
                    myModel.countdown.toString(),
                    style: TextStyle(fontSize: 48),
                  );
                }),
                Spacer(),
                Divider(
                  thickness: 2,
                ),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Text(
                        "Tip: Breath Slowly While Doing Streching Yoga,",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimerModel with ChangeNotifier {
  String YogaTableName;
  TimerModel(context, {required this.YogaTableName}) {
    FetchAllYoga(YogaTableName);
    MyTimer(context);
  }
  int countdown = 5;
  late List<Yoga> AllYoga;
  MyTimer(context) async {
    Timer.periodic(Duration(seconds: 1), (timer) {
      countdown--;
      if (countdown == 0) {
        timer.cancel();
        timer.cancel();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => WorkOutDet(
                      ListOfYoga: AllYoga,
                      yogaindex: 0,
                    )));
      }
      notifyListeners();
    });
  }

  Future<List<Yoga>> FetchAllYoga(String yogaTableName) async {
    await YogaDatabase.instance.readAllYogaSum();
    AllYoga = await YogaDatabase.instance.readAllYoga(yogaTableName);
    print(AllYoga.length);
    notifyListeners();
    return AllYoga;
  }
}
