import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torch_controller/torch_controller.dart';

class FlashLightApp extends StatefulWidget {
  const FlashLightApp({Key? key}) : super(key: key);

  @override
  _FlashLightAppState createState() => _FlashLightAppState();
}

class _FlashLightAppState extends State<FlashLightApp>
    with TickerProviderStateMixin {
  late AnimationController _animatedcontroller;
  Color color = Colors.white;
  double fontSize = 40;
  bool isClicked = true;
  final controller = TorchController();
  int valueHolder = 1;
  late Timer timer;


  @override
  void initState() {
    super.initState();
    if(isClicked = !isClicked){
    controller.toggle();}
    _animatedcontroller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }
  void dispose() {
    timer.cancel();
    // timer1.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          GestureDetector(
            onTap: () {

              if (isClicked) {

                _animatedcontroller.forward();
                fontSize = 60;
                color = Colors.green;
                HapticFeedback.lightImpact();
              } else {
                _animatedcontroller.reverse();
                fontSize = 40;
                color = Colors.white;
               HapticFeedback.lightImpact();
              }
              isClicked = !isClicked;
              controller.toggle();
              setState(() {});
            },
            child: Center(
              child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Center(
                      child: Image.asset(!isClicked ?"assets/images/on.png":"assets/images/off.png")


                  )),
            ),
          ),


          Container(
              height: MediaQuery.of(context).size.height / 1.3,
              alignment: Alignment.bottomCenter,
              child: AnimatedDefaultTextStyle(
                  curve: Curves.ease,
                  child: Text(!isClicked ? 'ON' : 'OFF'),
                  style: TextStyle(
                      color: color,
                      fontSize: fontSize,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold),
                  duration: const Duration(milliseconds: 200))),
         // Container(height: 90,color: Colors.blue,),
          Container(height: MediaQuery.of(context).size.height / 8.0,
             color: Colors.yellow,
           // height: 30,
            margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height / 2.0, 0, 0),
            alignment: Alignment.bottomCenter,
            child: Column(

                children: [
                  Container(

                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Slider(

                          value: valueHolder.toDouble(),
                          min: 1,
                          max: 100,
                          divisions: 100,
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey,
                          label: '${valueHolder.round()}',
                          onChanged: (double newValue) {
                            setState(() {
                              valueHolder = newValue.round();


                              timer = new Timer.periodic(Duration(seconds: valueHolder ), (Timer t) => controller.toggle());

                            });
                          },
                          semanticFormatterCallback: (double newValue) {
                            return '${newValue.round()}';
                          }
                      )),
                  Text('$valueHolder', style: TextStyle(fontSize: 22,color: Colors.white),)

                ]
            ),
          )






        ],
      ),
    );
  }
}
