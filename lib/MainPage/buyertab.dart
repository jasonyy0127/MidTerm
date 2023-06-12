import 'dart:convert';

import 'package:barter_it/MainPage/viewbuyerdetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/item.dart';
import '../Model/user.dart';

class BuyerTab extends StatefulWidget {
  const BuyerTab({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;
  @override
  State<BuyerTab> createState() => _BuyerTabState();
}

class _BuyerTabState extends State<BuyerTab> {
  String maintitle = "Buyer";
  List<Item> itemList = <Item>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  String selectedOption = '';
  String option = '';

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadBuyerItems();
    print("Buyer");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 21, 42, 78),
        actions: [
          IconButton(
            onPressed: () {
              showfilterDialog();
            },
            icon: const Icon(Icons.filter_alt_outlined),
          ),
          IconButton(
              onPressed: () {
                showsearchDialog();
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: itemList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              Container(
                height: 24,
                color: Colors.red,
                alignment: Alignment.center,
                child: Text(
                  "${itemList.length} Items Found",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        itemList.length,
                        (index) {
                          return Card(
                            child: InkWell(
                              onTap: () {
                                Item userItem =
                                    Item.fromJson(itemList[index].toJson());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => ViewBuyerDetails(
                                              user: widget.user,
                                              buyeritem: userItem,
                                            )));
                              },
                              child: Column(children: [
                                CachedNetworkImage(
                                  width: screenWidth,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "https://uumitproject.com/barterIt/assets/items/${itemList[index].itemId}.1.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Text(
                                  itemList[index].itemName.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "RM ${double.parse(itemList[index].itemPrice.toString()).toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "${itemList[index].itemQty} available",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ]),
                            ),
                          );
                        },
                      )))
            ]),
    );
  }

  void loadBuyerItems() {
    http.post(
        Uri.parse("https://uumitproject.com/barterIt/buyer/load_item.php"),
        body: {}).then((response) {
      //print(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }

  void showsearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          titlePadding: EdgeInsets.all(0),
          title: _getCloseButton(context),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text(
              "Enter search keyword",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal),
              textAlign: TextAlign.center,
            ),
            TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ))),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                String search = searchController.text;
                searchItem(search);
                Navigator.of(context).pop();
              },
              child: const Text("Search"),
            )
          ]),
        );
      },
    );
  }

  void searchItem(String search) {
    http.post(
        Uri.parse("https://uumitproject.com/barterIt/buyer/load_item.php"),
        body: {"search": search}).then((response) {
      //print(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }

  void showfilterDialog() {
    selectedOption = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            titlePadding: EdgeInsets.all(0),
            title: _getCloseButton(context),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Sort By",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal),
                    textAlign: TextAlign.center,
                  ),
                  RadioListTile(
                    value: '1',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        option = '1';
                        selectedOption = value!;
                      });
                    },
                    title: const Text('Alphabet: A to Z'),
                  ),
                  RadioListTile(
                    value: '2',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        option = '2';
                        selectedOption = value!;
                      });
                    },
                    title: const Text('Alphabet: Z to A'),
                  ),
                  RadioListTile(
                    value: '3',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        option = '3';
                        selectedOption = value!;
                      });
                    },
                    title: const Text('Price: Low to High'),
                  ),
                  RadioListTile(
                    value: '4',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        option = '4';
                        selectedOption = value!;
                      });
                    },
                    title: const Text('Price: High to Low'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      filterItem(option);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Apply"),
                  )
                ]),
          );
        });
      },
    );
  }

  void filterItem(String option) {
    print(option);
    http.post(
        Uri.parse("https://uumitproject.com/barterIt/buyer/load_item.php"),
        body: {"option": option}).then((response) {
      //print(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }

  _getCloseButton(context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: FractionalOffset.topRight,
        child: GestureDetector(
          child: const Icon(
            Icons.clear,
            color: Colors.red,
            size: 36,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
