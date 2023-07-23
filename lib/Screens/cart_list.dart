import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tiffiny/Screens/order_detail.dart';
import 'package:tiffiny/Screens/tiffin_menu.dart';

class CartList extends StatefulWidget {
  List<String>? curr;
  var currItems = [];
  int totalprice;
  List<int> price;
  List kitchen = [];
  var ItemLength = new Map();
  CartList(
      {super.key,
      required this.totalprice,
      required this.curr,
      required this.currItems,
      required this.ItemLength,
      required this.kitchen,
      required this.price});

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  @override
  int Items = 0;
  Widget build(BuildContext context) {
    void removeItem(int index) {
      String key = widget.ItemLength.keys.elementAt(index);
      print(widget.ItemLength);
      setState(() {
        for (int i = 0; i < widget.kitchen.length; i++) {
          if (widget.kitchen[i]['Menu_Item'] == key) {
            widget.totalprice = widget.totalprice -
                int.parse(widget.kitchen[i]['price'].toString());
            widget.currItems.remove(widget.currItems.lastWhere(
                (element) => element['quantity'] == widget.ItemLength[key]));
            // print(widget.currItems);
          }
        }
      });
      if (widget.currItems
              .where((element) => element['quantity'] == widget.ItemLength[key])
              .length <
          1) {
        setState(() {
          for (int i = 0; i < widget.kitchen.length; i++) {
            if (widget.kitchen[i]['Menu_Item'] == key) {
              widget.totalprice = widget.totalprice -
                  int.parse(widget.kitchen[i]['price'].toString());
              widget.ItemLength.remove(key);
            }
          }

          print("hello");
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.amber,
      ),
      body: widget.ItemLength.isNotEmpty
          ? Stack(
              children: [
                SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.ItemLength.length,
                          itemBuilder: (context, index) {
                            String key =
                                widget.ItemLength.keys.elementAt(index);
                            Items = widget.currItems
                                .where((e) =>
                                    e['quantity'] == widget.ItemLength[key])
                                .length;

                            // print(widget.currItems.length);
                            if (widget.currItems
                                    .where((element) =>
                                        element['quantity'] == index)
                                    .length ==
                                0) {
                              widget.ItemLength.remove(widget.ItemLength[key]);
                            }
                            return Container(
                              height: 50,
                              margin: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(20.0),
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
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    width: 80,
                                    child: Text(
                                      key,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                  ),
                                  Container(
                                    width: 50,
                                    child: Text(Items.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  SizedBox(
                                    width: 20,
                                    child: Container(),
                                  ),
                                  Stack(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        onPressed: () => {removeItem(index)},
                                        icon: Icon(Icons
                                            .remove_circle_outline_rounded),
                                        color: Colors.redAccent,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          })
                    ],
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
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Total Price:- ${widget.totalprice} ₹",
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
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => OrderDetail(
                                  //           totalprice:
                                  //               widget.totalprice.toInt(),
                                  //           curr: widget.curr,
                                  //           currItems: widget.currItems,
                                  //           ItemLength: widget.ItemLength,
                                  //         )))
                                },
                            child: Text("Proceed to pay"))
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 250.0),
                //   child: SizedBox(
                //     height: 70,
                //     width: MediaQuery.of(context).size.width - 50,
                //     child: Container(
                //       decoration: BoxDecoration(
                //           color: Colors.amber,
                //           borderRadius: BorderRadius.circular(30)),
                //     ),
                //   ),
                // ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/Empty_Cart.png',
                    width: 170,
                    height: 150,
                  ),
                ),
              ],
            ),
    );
  }
}
