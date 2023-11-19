import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task1/constants/string.dart';
import 'package:task1/model/data_model.dart';
import 'package:task1/screens/data_details.dart';
import 'package:task1/screens/my_acount/my_acount.dart';
import 'package:task1/utils/subscription_helper.dart';
import '../api/api_controller.dart';
import '../api/responce_repo.dart';
import '../constants/colors.dart';

class HomeScreen extends StatefulWidget {
  final LoginResponse? user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiController apiController = Get.put(ApiController());

  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  List<DataModel>? searchDataList;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getVicalConfirmCount();
  }

  void getVicalConfirmCount() async {
    await apiController.getConfirmStatusCount(
        widget.user!.token, widget.user!.currentUser!.id);
  }

  Widget searchResult(List<DataModel>? searchData) {
    if (searchData != null && searchData.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: searchData.length,
        itemBuilder: (context, index) {
          DataModel data = searchData[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DataDetails(
                    detailsData: data,
                    token: widget.user!.token,
                    userID: widget.user!.currentUser!.id,
                  ),
                ),
              );
            },
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID: ${data.engineNum}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ],
            ),
          );
        },
      );
    } else {
      return const Center(
        child: Text("No Data found"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (searchQuery.isNotEmpty) {
            setState(() {
              searchQuery = '';
              searchController.clear(); // Clear the text field
            });
            return false;
          }
          return true;
        },
        child: SafeArea(
            child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onSubmitted: (value) async {
                    setState(() {
                      isSearching = true;
                      searchQuery = value;
                    });

                    searchDataList = await apiController.searchQuery(
                        widget.user!.token, value);
                    setState(() {
                      isSearching = false;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.only(left: 30, top: 5, bottom: 5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    prefixIcon: searchQuery.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.black),
                            onPressed: () {
                              if (searchQuery.isNotEmpty) {
                                setState(() {
                                  searchQuery = '';
                                  searchController.clear();
                                });
                              }
                            },
                          ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.settings, color: greyColor),
                      onPressed: () {},
                    ),
                    hintText: StringValue.search,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 4, right: 10),
                    padding: const EdgeInsets.only(
                        top: 2, bottom: 2, right: 6, left: 6),
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      StringValue.onlie,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (isSearching)
                  const CircularProgressIndicator()
                else if (searchQuery.isNotEmpty)
                  searchResult(searchDataList!)
                else
                  buildHomeUi(apiController, context, widget.user)
              ],
            ),
          ),
        )));
  }
}

void _openBottomSheet(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Password',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber),
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your password',
                    label: Text("Password")),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      autofocus: true,
                      onPressed: () {
                        // Add your logic for the login button here
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[800]),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      );
    },
  );
}

Widget buildHomeUi(
    ApiController apiController, BuildContext context, LoginResponse? user) {
  return Column(
    children: [
      const CircleAvatar(
        backgroundImage: NetworkImage(StringValue.defaultProfilePic),
        radius: 80,
      ),
      const Text(
        StringValue.appFullName,
        style: TextStyle(
            color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 10,
      ),
      const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.phone, color: secondaryColor),
        SizedBox(
          width: 4,
        ),
        Text(
          StringValue.contactNo,
          style: TextStyle(color: Colors.black, fontSize: 20),
        )
      ]),
      const SizedBox(
        height: 10,
      ),
      const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.location_pin, color: secondaryColor),
        SizedBox(
          width: 4,
        ),
        Text(
          StringValue.address,
          style: TextStyle(color: Colors.black, fontSize: 18),
        )
      ]),
      const SizedBox(
        height: 30,
      ),
      Container(
        decoration: BoxDecoration(
            color: cardColor, borderRadius: BorderRadius.circular(0.0)),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(StringValue.acountActivateMessage,
                style: TextStyle(color: Colors.black, fontSize: 18)),
            Container(
              margin: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () {},
                          child: const Text(
                            StringValue.refresh,
                            style:
                                TextStyle(color: secondaryColor, fontSize: 16),
                          ))),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () {},
                          child: const Text(
                            StringValue.pay,
                            style:
                                TextStyle(color: secondaryColor, fontSize: 16),
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: lightGreyColor,
                  borderRadius: BorderRadius.circular(6.0)),
              child: Column(
                children: [
                  const Text(
                    StringValue.remainingDays,
                    style: TextStyle(
                        color: greyColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    SubscriptionHelper.calculateRemainingDays(
                      StringValue.subscriptionEndDate,
                    ).toString(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: lightGreyColor,
                  borderRadius: BorderRadius.circular(6.0)),
              child: const Column(
                children: [
                  Text(
                    StringValue.offlineDay,
                    style: TextStyle(
                        color: greyColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '0',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyAccount(
                              user: user,
                            )));
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: lightGreyColor,
                    borderRadius: BorderRadius.circular(6.0)),
                child: const Column(
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 32,
                    ),
                    SizedBox(height: 5),
                    Text(
                      StringValue.myAccount,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: lightGreyColor,
                    borderRadius: BorderRadius.circular(6.0)),
                child: Column(
                  children: [
                    const Icon(
                      Icons.directions_car_filled,
                      size: 32,
                    ),
                    const SizedBox(height: 5),
                    Obx(
                      () {
                        return apiController.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                apiController.vConfirmCount.value,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      GestureDetector(
        onTap: () {
          _openBottomSheet(context);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: lightGreyColor, borderRadius: BorderRadius.circular(6.0)),
          child: const Column(
            children: [
              Icon(
                Icons.security,
                size: 32,
              ),
              SizedBox(height: 5),
              Text(
                StringValue.controlPanel,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: lightGreyColor, borderRadius: BorderRadius.circular(6.0)),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringValue.aboutSoftware,
              style: TextStyle(color: greyColor, fontSize: 16),
              textAlign: TextAlign.left,
            ),
            Text(
              StringValue.appVersion,
              style: TextStyle(color: Colors.black, fontSize: 16),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10),
            Text(
              StringValue.designBy,
              style: TextStyle(color: secondaryColor, fontSize: 15),
              textAlign: TextAlign.left,
            ),
            Text(
              StringValue.designByName,
              style: TextStyle(color: Colors.black, fontSize: 16),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              StringValue.purchaseContactNo,
              style: TextStyle(
                  color: secondaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    ],
  );
}
