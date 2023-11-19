import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task1/api/api_controller.dart';
import 'package:task1/model/data_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';

class DataDetails extends StatefulWidget {
  final DataModel detailsData;
  final String token;
  final int userID;
  const DataDetails(
      {super.key,
      required this.detailsData,
      required this.token,
      required this.userID});

  @override
  State<DataDetails> createState() => _DataDetailsState();
}

class _DataDetailsState extends State<DataDetails> {
  final ApiController apiController = Get.put(ApiController());

  void updateStatus(String status) async {
    await apiController.updateDataStatus(
        widget.token, widget.detailsData.id, widget.userID, status);
  }

  // void cencelData() async {
  //   bool res = await apiController.updateDataStatus(widget.token, 'confirm');
  //   res
  //       ? showToast("Cancel", "Cencel Success", Colors.green)
  //       : showToast("Cancel", "error", Colors.red);
  // }

  void showToast(String title, String message, Color color) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.TOP, // Adjust position as needed
        duration: const Duration(seconds: 3),
        backgroundColor: color);
  }

  void shareText(String text) async {
    final Uri params = Uri(
      scheme: 'sms',
      path: '',
      queryParameters: {'body': text}, // Message to be sent
    );
    String url = params.toString();
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void shareOnWhatsApp(String text) async {
    var whatsappUrl = "whatsapp://send?text=$text";
    await canLaunchUrl(Uri.parse(whatsappUrl))
        ? launchUrl(Uri.parse(whatsappUrl))
        : showToast(
            "whatsapp share", 'Could not launch $whatsappUrl', Colors.red);
  }

  String data() {
    return """
      Id: ${widget.detailsData.id.toString()}
      loanNo: ${widget.detailsData.loanNo.toString()}
      branchID: ${widget.detailsData.branchID.toString()}
      branchName: ${widget.detailsData.branchName}
      state: ${widget.detailsData.state}
      product: ${widget.detailsData.product}
      customerName: ${widget.detailsData.customerName}
      assetDesc: ${widget.detailsData.assetDesc}
      regNum: ${widget.detailsData.regNum}
      engineNum: ${widget.detailsData.engineNum}
      chasisNum: ${widget.detailsData.chasisNum}
      podNum: ${widget.detailsData.podNum}
      officeAddress: ${widget.detailsData.officeAddress}
      officePincode: ${widget.detailsData.officePincode.toString()}
      supervisorName1: ${widget.detailsData.supervisorName1}
      supervisorName2: ${widget.detailsData.supervisorName2}
      supervisorName3: ${widget.detailsData.supervisorName3}
      createdAt: ${formatDateAndTime(widget.detailsData.createdAt)}
      updatedAt: ${formatDateAndTime(widget.detailsData.updatedAt)}
    """;
  }

  void copyData() {
    Clipboard.setData(ClipboardData(text: data()));
    showToast("Copy Data", "Copy Successful", Colors.lightGreen);
  }

  Widget _dataView(String key, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              key,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Text(
              ": $value",
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonView(String icon, String title) {
    return Column(
      children: [
        SizedBox(height: 22, width: 22, child: SvgPicture.asset(icon)),
        const SizedBox(height: 5),
        Text(title),
      ],
    );
  }

  String formatDateAndTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    String formattedTime = DateFormat('hh:mm:ss a').format(dateTime);

    return '$formattedDate, $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data ID : ${widget.detailsData.id}"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              _dataView("Id", widget.detailsData.id.toString()),
              _dataView("loanNo", widget.detailsData.loanNo.toString()),
              _dataView("branchID", widget.detailsData.branchID.toString()),
              _dataView("branchName", widget.detailsData.branchName),
              _dataView("state", widget.detailsData.state),
              _dataView("product", widget.detailsData.product),
              _dataView("customerName", widget.detailsData.customerName),
              _dataView("assetDesc", widget.detailsData.assetDesc),
              _dataView("regNum", widget.detailsData.regNum),
              _dataView("engineNum", widget.detailsData.engineNum),
              _dataView("chasisNum", widget.detailsData.chasisNum),
              _dataView("podNum", widget.detailsData.podNum),
              _dataView("officeAddress", widget.detailsData.officeAddress),
              _dataView(
                  "officePincode", widget.detailsData.officePincode.toString()),
              _dataView("supervisorName1", widget.detailsData.supervisorName1),
              _dataView("supervisorName2", widget.detailsData.supervisorName2),
              _dataView("supervisorName3", widget.detailsData.supervisorName3),
              _dataView(
                  "createdAt", formatDateAndTime(widget.detailsData.createdAt)),
              _dataView(
                  "updatedAt", formatDateAndTime(widget.detailsData.updatedAt)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.infinity,
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () => updateStatus('confirm'),
              child: _buttonView("assets/icon/confirm.svg", "Confirm"),
            ),
            InkWell(
              onTap: () => shareOnWhatsApp(data()),
              child: _buttonView("assets/icon/whatsapp.svg", "whatsapp"),
            ),
            InkWell(
              onTap: () => shareText(data()),
              child: _buttonView("assets/icon/message.svg", "Ok repo"),
            ),
            InkWell(
              onTap: () => updateStatus('cancel'),
              child: _buttonView("assets/icon/cancel.svg", "Cancel"),
            ),
            InkWell(
              onTap: () => copyData(),
              child: _buttonView("assets/icon/copy.svg", "Copy"),
            ),
          ],
        ),
      ),
    );
  }
}
