import 'package:ai_image/img_list.dart';
import 'package:ai_image/img_variation.dart';
import 'package:flutter/material.dart';
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: const Text('AI Image Generator',style: TextStyle(color: Colors.white,fontSize: 18),),
      centerTitle: true,
        backgroundColor: Color(0xff4440AF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          Text("Welcome to AI Image Generator"),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                           backgroundColor: Color(0xff4440AF), // sets the button color
                          ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ImageListView()));
              }, child: Text("Create Images with your imagination",style: TextStyle(color: Colors.white))),),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                           backgroundColor: Color(0xff4440AF), // sets the button color
                          ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ImageVariation()));
              }, child: Text("Create variations of your image",style: TextStyle(color: Colors.white))),),
        ],),
      ),
    );
  }
}