import 'dart:convert';

// import 'package:ai_image_generator/models/data_model.dart';
import 'package:ai_image/models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:counter_button/counter_button.dart';
import 'package:lottie/lottie.dart';

class ImageListView extends StatefulWidget {
  @override
  _ImageListViewState createState() => _ImageListViewState();
}

class _ImageListViewState extends State<ImageListView> {
  List<Datum> _images = [];
  int counter = 0;
  final titlecontroller = TextEditingController();
  final sizeController = TextEditingController();
  final numberController = TextEditingController();
  bool _isLoaded = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _isLoaded=false;
  // }

  Future<void> _getImages(String title, String size, int number) async {
    final response = await http.post(
      Uri.parse('https://open-ai-image.codinghood.in/api/create-ai-image'),
      body: json.encode({
        'message': title,
        'numberOfImages': number,
        'size': "m",
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = ImageModel.fromJson(json.decode(response.body));
      setState(() {
        _images = data.images!.data!;
      });
    } else {
      throw Exception('Failed to load images');
    }
      _isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Image Generator',style: TextStyle(color: Colors.white,fontSize: 18),),
      centerTitle: true,
        backgroundColor: Color(0xff4440AF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: titlecontroller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Search your imagination",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Lottie.asset("assets/lotties/search.json",height:25,width:25),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 15),
           
            Row(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  
                  child: CounterButton(
                    loading: false,
                    onChange: (int val) {
                      setState(() {
                        counter = val;
                      });
                    },
                    count: counter,
                    countColor: Color(0xff072090),
                    buttonColor: Color(0xff8F9CD5),
                    progressColor: Colors.purpleAccent,
                  ),
                ),

                

                SizedBox(width: 10),

                SizedBox(
                // height: 50, 
                // width: 70,
                   child: ElevatedButton(
                    //button color
                    style: ElevatedButton.styleFrom(
                           backgroundColor: Color.fromARGB(255, 223, 202, 241), // sets the button color
                          ),
                      child: Image.asset("assets/lotties/send.png",height: 55,width: 40),
                      // Lottie.network("https://assets4.lottiefiles.com/packages/lf20_nfgcytvk.json",height: 55,width: 40),
                      // Text('Search', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      onPressed: () {
                      
                        print("search button pressed");
                        print(titlecontroller.text);
                        print(counter);
                        // int number = int.parse(numberController.text);
                        _getImages(titlecontroller.text, "sm", counter);
                        setState(() {
                          _isLoaded = true;
                          if( _images.isNotEmpty==true){
                            _isLoaded = false;
                          }
                        });
                      },
                   ),),
              ],
            ),
            SizedBox(height: 15),
      
             
                   const SizedBox(height: 20,),
      
            _isLoaded? 
            Visibility(
              visible: _images.isNotEmpty,
              child: Flexible(
                child: Container(
                  child: ListView.builder(
                    itemCount: _images.length,
                    itemBuilder: (BuildContext context, int index) {
                      final image = _images[index];
                      return Column(
                        children: [
                          Container(
                            height: 300,
                            width: 300,
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(image.url ?? ""),
                                  fit: BoxFit.contain,
                                ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            ),
                          const SizedBox(height: 15),
                        ],
                      );
                    },
                  )
              ),
            ),):
            // Flexible(child: Container(child: Center(child: CircularProgressIndicator(),),))
            Flexible(child: Center(child: Lottie.network("https://assets2.lottiefiles.com/packages/lf20_a2chheio.json",height: 100,width: 100))),
          ],
        ),
      ),
    );
  }
}
