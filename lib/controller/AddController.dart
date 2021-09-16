import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qasimati/data/ApiHelper.dart';
import 'package:qasimati/ui/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddController extends GetxController {
  final GlobalKey<FormState> addKey = GlobalKey<FormState>();
  TextEditingController nameController,
      soreName,
      storeName,
      storeLink,
      descrption,
      type,
      code,
      linkStore;

  TextEditingController dateinputEnter = TextEditingController();
  TextEditingController dateinputEnd = TextEditingController();
  DateTime pickedDateEnter;
  DateTime pickedDateEnd;
  XFile image;
  File fileImage;
  List<String> selectedCountry = [];
  imgFromGallery() async {
    ImagePicker picker = ImagePicker();
    image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    fileImage = File(image.path);
    print(fileImage);
    update();
  }

  @override
  void onInit() {
    nameController = TextEditingController();
    soreName = TextEditingController();
    storeName = TextEditingController();
    storeLink = TextEditingController();
    descrption = TextEditingController();
    type = TextEditingController();
    code = TextEditingController();
    linkStore = TextEditingController();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  String validateName(String value) {
    if (!GetUtils.isUsername(value)) {
      return "Username is not vaild";
    }
    return null;
  }

  String validatLabel(String value) {
    if (value.trim().isEmpty) {
      return "Required".tr;
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.length <= 6) {
      return "password must be of 6";
    }
    return null;
  }

  checkAdd() async {
    if (addKey.currentState.validate()) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      int id = preferences.get('id');
      addKey.currentState.save();
      var selectedCountryJson = jsonEncode(selectedCountry);

      Future<dynamic> response = ApiHelper.apiHelper.addCoupon(
        nameStore: storeName.text,
        linkstore: storeLink.text,
        urlStore: fileImage,
        countries: selectedCountryJson,
        code: code.text,
        descrption: descrption.text,
        startDate: dateinputEnter.text,
        endDate: dateinputEnd.text,
        id: id,
        type: type.text,
      );
      response.then((value) {
        if (value['status'] == 200) {
          Get.snackbar(
            "Done ",
            "Your request has been submitted successfully",
          );
          Get.offAll(HomeScreen());
        } else {
          Get.snackbar(
            "check all ",
            "This is the Getx default SnackBar",
          );
        }
      });
    } else {
      Get.snackbar(
        "check all ",
        "This is the Getx default SnackBar",
      );
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
