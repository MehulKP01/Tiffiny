import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:tiffiny/Screens/Information.dart';
import 'package:tiffiny/Screens/cart_list.dart';
import 'package:tiffiny/Screens/order_detail.dart';
import 'package:tiffiny/kitchen_data.dart';
import 'package:tiffiny/utils/cart_controller.dart';
import 'package:tiffiny/utils/cart_item.dart';
import 'package:tiffiny/widgets/big_text.dart';
import 'package:tiffiny/widgets/icon_text.dart';
import 'package:tiffiny/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/dimensions.dart';

class TiffinMenu extends StatefulWidget {
  TiffinMenu({super.key, required this.ind});
  int ind;
  @override
  State<TiffinMenu> createState() => _TiffinMenuState();
}

class _TiffinMenuState extends State<TiffinMenu> {
  final CartController _CartController = Get.put(CartController());
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchkitchen();
    initialgetdata();
  }

  int totalprice = 0;
  List<String> curr = [];
  List kitchen = [];
  String kitchen_name = "";
  fetchkitchen() async {
    var url = "https://mytiffiny.000webhostapp.com/1.php";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var items = json.decode(response.body);

      setState(() {
        for (int i = 0; i < items.length; i++) {
          if (items[i]['T_Id'] == widget.ind) {
            kitchen.add(items[i]);
            kitchen_name = items[i]['Tiffin_Name'];
          }
        }
        // print(items.length());
        // kitchen = items;
        // print(kitchen.length);
      });
    } else {
      setState(() {
        kitchen = [];
      });
    }
    print(kitchen.length);
  }

  void initialgetdata() async {
    // print(widget.updated);
    sharedPreferences = await SharedPreferences.getInstance();
    // String? ItemName = sharedPreferences.getString('foodname');
    // List<String>? curItem = sharedPreferences.getStringList('curr');
    // int? totalPrice = sharedPreferences.getInt('totalprice');
    // if (curr.length > 0 && totalprice > 0) {
    //   print(curr);
    //   curr = curItem as List<String>;
    //   totalprice = totalPrice as int;
    // }
  }

  // void storedata() {
  //   KitchenDataModel kitchen = KitchenDataModel(
  //       foodname: foodname.toString(), curr: curr, price: totalprice);
  //   // print(kitchen.curr);
  //   sharedPreferences.setString("foodname", kitchen.foodname.toString());
  //   sharedPreferences.setStringList("currItems", curr);
  //   sharedPreferences.setInt("totalprice", totalprice);
  // }

  var currItems = [{}];
  // ignore: non_constant_identifier_names
  var ItemLength = new Map();
  List<String> foodname = ["Maggie", "Pasta", "VadaPav", "Pizza"];
  List<String> fooddesc = [
    "Maggie desc",
    "pasta desc",
    "vada desc",
    "pizza desc"
  ];

  List<int> price = [50, 60, 30, 100];
  @override
  Widget build(BuildContext context) {
    // widget.updated == null ? 0 : widget.updated;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            Text(kitchen_name, style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.amber,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Center(
              child: Column(
                children: [
                  Column(
                    children: [
                      // ignore: unnecessary_new

                      SizedBox(
                        height: Dimensions.width30,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: Dimensions.width30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            BigText(text: "Popular"),
                            SizedBox(
                              width: Dimensions.width10,
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 3),
                              child: BigText(
                                text: ".",
                                color: Colors.black26,
                              ),
                            ),
                            SizedBox(
                              width: Dimensions.width10,
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 2),
                              child: SmallText(text: "Food Pairing"),
                            )
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Column(
                            // height: MediaQuery.of(context).size.height,
                            children: [
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: kitchen.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: Dimensions.width20,
                                          right: Dimensions.width20,
                                          bottom: Dimensions.height10),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radius20),
                                                color: Colors.white38,
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        kitchen[index]
                                                            ['Menu_Img']))),
                                          ),
                                          Expanded(
                                              child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(
                                                    Dimensions.radius20),
                                                bottomRight: Radius.circular(
                                                    Dimensions.radius20),
                                              ),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(0xFFe8e8e8),
                                                    blurRadius: 5.0,
                                                    offset: Offset(0, 5)),
                                                BoxShadow(
                                                    color: Colors.white,
                                                    offset: Offset(-5, 0)),
                                                BoxShadow(
                                                    color: Colors.white,
                                                    offset: Offset(5, 0)),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: Dimensions.width10,
                                                  right: Dimensions.width10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  BigText(
                                                      text: kitchen[index]
                                                          ['Menu_Item']),
                                                  SizedBox(
                                                    height: Dimensions.height10,
                                                  ),
                                                  SmallText(
                                                      text: kitchen[index]
                                                              ['price']
                                                          .toString()),
                                                  SizedBox(
                                                    height: Dimensions.height10,
                                                  ),
                                                  cartItems(
                                                      ind: kitchen[index]
                                                          ['T_Id'],
                                                      price: kitchen[index]
                                                          ['price'],
                                                      name: kitchen[index]
                                                          ['Menu_Item'])
                                                ],
                                              ),
                                            ),
                                          ))
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ],
                      ),

                      //
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 555.0, left: 12.0),
            child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width - 30,
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFFe8e8e8),
                      blurRadius: 5.0,
                      offset: Offset(0, 5)),
                  BoxShadow(color: Colors.white, offset: Offset(-5, 0)),
                  BoxShadow(color: Colors.white, offset: Offset(5, 0)),
                ],
              ),
              child: Obx(() => Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Total Price:- " +
                            _CartController.total.value.toString() +
                            " ₹",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              backgroundColor: Colors.greenAccent),
                          onPressed: () => {
                                if (_CartController.total.value > 0)
                                  {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => OrderDetail(
                                                  totalprice: int.parse(
                                                      _CartController.total
                                                          .toString()),
                                                  ItemLength: _CartController
                                                      .ItemLength,
                                                )))
                                  }
                                else
                                  {
                                    null,
                                  }
                              },
                          child: Text("Proceed to pay"))
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildmenupage() {
    Matrix4 matrix = Matrix4.identity();
    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            height: Dimensions.pageViewContainer,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              color: Color.fromARGB(255, 223, 228, 229),
            ),
          ),
        ],
      ),
    );
  }
}
