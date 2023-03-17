import 'dart:convert';

// import 'package:ai_image/models/api_model.dart';
import 'package:ai_image/models/data_model.dart';
import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
// import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class ImageVariation extends StatefulWidget {
  const ImageVariation({super.key});

  @override
  State<ImageVariation> createState() => _ImageVariationState();
}

class _ImageVariationState extends State<ImageVariation> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  var myImagePath;
  bool pressed = false;
  int counter = 0;
  List<Datum> _images = [];
  bool _isLoaded = false;

   void filePicker(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source, imageQuality: 9);
    if (selectedImage != null) {
      // Compress the selected image
      
      setState(() {
        image = XFile(selectedImage.path);
        pressed = true;
        print("selected image ===>>> $image".toString());
      });
    }else{
      print("No image selected");
      }
  }

  // Future createVariation({
  //   required XFile image,
  //   required int number,
  //   required String size,
  //   required BuildContext context,
  // }) async {
  //   Map<String, dynamic> params = {};
  //   String fileName = image.path;
  //   print("this is file name ===>>> $fileName");
  //   var imageSend = await MultipartFile.fromFile(fileName, filename: fileName);
  //   params['image'] = imageSend;
  //   params['numberOfImages'] = number;
  //   params['size'] = size;
  //   var apiURL = "https://open-ai-image.codinghood.in/api/create-image-variation";
  //   var postResponse = await ApiModel.postFormData(params, apiURL);
    
  //   print("sending profile details URL ===>>> $apiURL");
  //   print("getting update image API response ===>>> $postResponse");
  //   // context.

  //   if (postResponse.statusCode == 200) {
  //     final data = ImageModel.fromJson(json.decode(postResponse.body));
  //     setState(() {
  //       _images = data.images!.data!;
  //     });
  //   } else {
  //     throw Exception('Failed to load images');
  //   }
  //     _isLoaded = true;
  // }

Future<void> createVariation({
  required XFile image,
  required int number,
  required String size,
  required BuildContext context,
}) async {
  try {
    const apiURL = "https://open-ai-image.codinghood.in/api/create-image-variation";
    String fileName = image.path;
    print("this is file name ===>>> $fileName");

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(fileName, filename: fileName),
      'numberOfImages': number,
      'size': "sm",
    });

    final response = await Dio().post(apiURL, data: formData);

    print('API response: ${response.statusCode} ${response.statusMessage}');
    if (response.statusCode == 200) {
      final data = ImageModel.fromJson(json.decode(response.data));
      setState(() {
        _images = data.images!.data!;
      });
    } else {
      throw Exception('Failed to load images');
    }
    _isLoaded = true;
  }  on DioError catch (e) {
  if (e.response != null) {
    print(e.response!.data);
    print(e.response!.headers);
    print(e.response!.requestOptions);
  } else {
    print(e.requestOptions);
    print(e.message);
  }
}
}
  


// Future<void> createVariation({
//   required XFile image,
//   required int number,
//   required String size,
//   required BuildContext context,
// }) async {
//   var request = http.MultipartRequest(
//     'POST',
//     Uri.parse('https://open-ai-image.codinghood.in/api/create-image-variation'),
//   );
//   request.files.add(await http.MultipartFile.fromPath('image', image.path));
//   // request.fields['numberOfImages'] = number;
//   // request.fields['size'] = size;
  

//   var streamedResponse = await request.send();
//   var response = await http.Response.fromStream(streamedResponse);

//   print('API response: ${response.statusCode} ${response.reasonPhrase}');
//   if (response.statusCode == 200) {
//     final data = ImageModel.fromJson(json.decode(response.body));
//     setState(() {
//       _images = data.images!.data!;
//     });
//   } else {
//     throw Exception('Failed to load images');
//   }
//   _isLoaded = true;
// }

  Widget displaySelectedImage() {
  if (image == null) {
    return const Text("No image selected");
  } else {
    return Image.file(File(image!.path));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: const Text('AI Image Generator',style: TextStyle(color: Colors.white,fontSize: 18),),
      centerTitle: true,
        backgroundColor: Color(0xff4440AF),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: 150,
                   decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                  child: Column(
                            children: [
                              Expanded(
                                child: Center(
                                  child: displaySelectedImage(),
                                ),
                              ),
                              
                              // const SizedBox(height: 16),
                
                              ElevatedButton(
                                onPressed: () => filePicker(ImageSource.gallery),
                                child: const Text("Pick image from gallery"),
                              ),
                              
                            ],),
                ),
                const SizedBox(width: 20),
                Column(children: [
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
                        // print(titlecontroller.text);
                        print(counter);
                        // int number = int.parse(numberController.text);
                        // _getImages(titlecontroller.text, "sm", counter);
                        createVariation(image: image??XFile(image!.path), number: counter, size: "sm", context: context);
                        setState(() {
                          _isLoaded = true;
                          if( _images.isNotEmpty==true){
                            _isLoaded = false;
                          }
                        });
                      },
                   ),),
                ],)
              ],
            ),
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
        )
        );
                
  }
}