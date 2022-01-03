import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_baby_shop_app/constants/colors.dart';
import 'package:the_baby_shop_app/models/user_model.dart';
import 'package:the_baby_shop_app/widgets/custom_button.dart';
import 'package:the_baby_shop_app/widgets/notification_button.dart';
import 'package:the_baby_shop_app/widgets/text_form_field.dart';

import 'home.dart';

/// Camera not working in physical device
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel userModel;
  TextEditingController phoneNumber;
  TextEditingController address;
  TextEditingController userName;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(p);
  bool isMale = false;

  void validation() async {
    if (userName.text.isEmpty && phoneNumber.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        const SnackBar(
          content: Text("Error, all fields are required."),
        ),
      );
    } else if (userName.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        const SnackBar(
          content: Text("Name is required."),
        ),
      );
    } else if (userName.text.length < 6) {
      _scaffoldKey.currentState.showSnackBar(
        const SnackBar(
          content: Text("Username must have at least 6 characters."),
        ),
      );
    } else if (phoneNumber.text.length < 10 && phoneNumber.text.length > 11) {
      _scaffoldKey.currentState.showSnackBar(
        const SnackBar(
          content: Text(
              "Example of phone number: 05-1234567 or 010-1234567 or 011-12345678"),
        ),
      );
    } else {
      userDetailUpdate();
    }
  }

  File _pickedImage;
  //PickedFile _image;
  var _image;

  Future<void> getImage({@required ImageSource source}) async {
    _image = await ImagePicker.pickImage(source: source);
    if (_image != null) {
      setState(() {
        _pickedImage = File(_image.path);
        // print("_pickedImage");
        // print(_pickedImage);
      });
    }
  }

  String userUid;

  Future<String> _uploadImage({@required File image}) async {
    String imageUrl;
    Reference storageReference =
        FirebaseStorage.instance.ref().child("image/$userUid");
    UploadTask uploadTask = storageReference.putFile(image);
    uploadTask.whenComplete(() async {
      imageUrl = await storageReference.getDownloadURL();
      // print("imageUrl");
      // print(imageUrl);
      FirebaseFirestore.instance.collection("users").doc(userUid).update({
        "image": imageUrl,
        "updatedAt": DateTime.now(),
      });
      //print(storageReference.getDownloadURL());
    }).catchError((onError) {
      // print("upload error");
      // print (onError);
    });
    //TaskSnapshot snapshot = await uploadTask.onComplete;
    //String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  void getUserUid() {
    User myUser = FirebaseAuth.instance.currentUser;
    userUid = myUser.uid;
  }

  bool centerCircle = false;
  String imageMap;
  void userDetailUpdate() async {
    setState(() {
      centerCircle = true;
    });
    _pickedImage != null
        ? imageMap = await _uploadImage(image: _pickedImage)
        : Container();
    FirebaseFirestore.instance.collection("users").doc(userUid).update({
      "name": userName.text,
      //"UserGender": isMale == true ? "Male" : "Female",
      "number": phoneNumber.text,
      // "image": imageMap,
      "address": address.text
    });
    setState(() {
      centerCircle = false;
      // print("imageMap");
      // print(imageMap);
    });
    setState(() {
      edit = false;
    });
  }

  Widget _buildSingleContainer(
      {Color color, @required String startText, @required String endText}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: edit == true ? color : Colors.white,
          borderRadius: edit == false
              ? BorderRadius.circular(30)
              : BorderRadius.circular(0),
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              startText,
              style: const TextStyle(fontSize: 17, color: Colors.black45),
            ),
            Text(
              endText,
              style: const TextStyle(
                fontSize: 16,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressContainer(
      {Color color, @required String startText, @required String endText}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: edit == true ? color : Colors.white,
          borderRadius: edit == false
              ? BorderRadius.circular(30)
              : BorderRadius.circular(0),
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              startText,
              style: const TextStyle(fontSize: 17, color: Colors.black45),
            ),
            Container(
              width: 200,
              child: Text(
                endText,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 16,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //String userImage;
  bool edit = false;
  Widget _buildContainerPart() {
    address = TextEditingController(text: userModel.userAddress);
    userName = TextEditingController(text: userModel.userName);
    phoneNumber = TextEditingController(text: userModel.userPhoneNumber);
    /*if (userModel.userGender == "Male") {
      isMale = true;
    } else {
      isMale = false;
    }*/
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSingleContainer(
            endText: userModel.userName,
            startText: "Name",
          ),
          _buildSingleContainer(
            endText: userModel.userEmail,
            startText: "Email",
          ),
          /*_buildSingleContainer(
            endText: userModel.userGender,
            startText: "Gender",
          ),*/
          _buildSingleContainer(
            endText: userModel.userPhoneNumber,
            startText: "Phone Number",
          ),
          _buildAddressContainer(
            endText: userModel.userAddress,
            startText: "Address",
          ),
        ],
      ),
    );
  }

  Future<void> myDialogBox(context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text("Pick From Camera"),
                    onTap: () {
                      getImage(source: ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text("Pick From Gallery"),
                    onTap: () {
                      getImage(source: ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildTextFormFieldPart() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MyTextFormField(
            name: "Username",
            controller: userName,
          ),
          _buildSingleContainer(
            color: Colors.grey.shade300,
            endText: userModel.userEmail,
            startText: "Email",
          ),
          /*GestureDetector(
            onTap: () {
              setState(() {
                isMale = !isMale;
              });
            },
            child: _buildSingleContainer(
              color: Colors.white,
              endText: isMale == true ? "Male" : "Female",
              startText: "Gender",
            ),
          ),*/
          MyTextFormField(
            name: "Phone Number",
            controller: phoneNumber,
          ),
          MyTextFormField(
            name: "Address",
            controller: address,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getUserUid();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        leading: edit == true
            ? IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.redAccent,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    edit = false;
                  });
                },
              )
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black45,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => const Home(),
                      ),
                    );
                  });
                },
              ),
        backgroundColor: Colors.white,
        actions: [
          edit == false
              ? const NotificationButton()
              : IconButton(
                  icon: const Icon(
                    Icons.check,
                    size: 30,
                    color: kPrimaryColor,
                  ),
                  onPressed: () {
                    validation();
                  },
                ),
        ],
      ),
      body: centerCircle == false
          ? ListView(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var myDoc = snapshot.data.docs;
                      myDoc.forEach((checkDocs) {
                        if (checkDocs.data()["uid"] == userUid) {
                          userModel = UserModel(
                            userEmail: checkDocs.data()["email"],
                            userImage: checkDocs.data()["image"],
                            userAddress: checkDocs.data()["address"],
                            //userGender: checkDocs.data()["UserGender"],
                            userName: checkDocs.data()["name"],
                            userPhoneNumber: checkDocs.data()["number"],
                          );
                        }
                      });
                      return Container(
                        height: 603,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 200,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                          maxRadius: 65,
                                          backgroundImage: _pickedImage == null
                                              ? userModel.userImage == null
                                                  ? AssetImage(
                                                      "assets/user.jpg")
                                                  : NetworkImage(
                                                      userModel.userImage)
                                              : FileImage(_pickedImage)),
                                    ],
                                  ),
                                ),
                                edit == true
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .viewPadding
                                                    .left +
                                                220,
                                            top: MediaQuery.of(context)
                                                    .viewPadding
                                                    .left +
                                                110),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              myDialogBox(context);
                                            },
                                            child: const CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Icon(
                                                Icons.camera_alt,
                                                color: kPrimaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            Container(
                              height: 350,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: edit == true
                                          ? _buildTextFormFieldPart()
                                          : _buildContainerPart(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: edit == false
                                    ? CustomButton(
                                        color: kPrimaryColor,
                                        name: "Edit Profile",
                                        onPressed: () {
                                          setState(() {
                                            edit = true;
                                          });
                                        },
                                      )
                                    : Container(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
