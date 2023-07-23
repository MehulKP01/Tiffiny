import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pay/pay.dart';

class OrderDetail extends StatefulWidget {
  // String foodname;

  int totalprice;
  var ItemLength = new Map();
  OrderDetail({super.key, required this.totalprice, required this.ItemLength});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  // final _paymentitems = <PaymentItem>[];
  int Items = 0;

  @override
  Widget build(BuildContext context) {
    // _paymentitems.add(
    //     PaymentItem(amount: widget.totalprice.toString(), label: 'Kitchen'));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Order Details",
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              Container(
                height: 300,
                margin: EdgeInsets.only(top: 40, left: 8),
                width: MediaQuery.of(context).size.width - 20,
                decoration: BoxDecoration(
                    color: Color.fromARGB(26, 135, 135, 42),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(children: <Widget>[
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.ItemLength.length,
                      itemBuilder: (context, index) {
                        String key = widget.ItemLength.keys.elementAt(index);
                        if (widget.ItemLength[key] > 0) {
                          return Container(
                            // height: 50,
                            margin: EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width - 60,
                            decoration: BoxDecoration(
                              // color: Colors.amber,
                              border: Border(
                                bottom: BorderSide(
                                    width: 1.5,
                                    color: Color.fromARGB(255, 194, 192, 192)),
                              ),
                              // borderRadius: BorderRadius.circular(20.0)),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  width: 120,
                                  child: Text(
                                    key,
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                ),
                                Container(
                                  width: 50,
                                  child: Text(widget.ItemLength[key].toString(),
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.w500)),
                                ),
                                SizedBox(
                                  width: 20,
                                  child: Container(),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      }),
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Container(
                      // height: 50,

                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              width: 100,
                              child: Text("Total Amount",
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20))),
                          SizedBox(
                            width: 150,
                          ),
                          Text(widget.totalprice.toString(),
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25))
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ]),
          ),
          // Container(
          //   margin: EdgeInsets.only(top: 20, left: 8),
          //   height: 80,
          //   width: MediaQuery.of(context).size.width - 20,
          //   decoration: BoxDecoration(
          //       color: Colors.amber, borderRadius: BorderRadius.circular(20)),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         "S-1, Nirman Tower,",
          //         style: TextStyle(
          //             color: Colors.white, fontWeight: FontWeight.w500),
          //       ),
          //       Text("Sattadhar Cross Road, Ghatlodia",
          //           style: TextStyle(
          //               color: Colors.white, fontWeight: FontWeight.w500)),
          //     ],
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 8),
            height: 50,
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(20)),
            child: InkWell(
              onTap: (() => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog(context),
                    )
                  }),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Pay With GPAY",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 8),
            height: 50,
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(20)),
            child: InkWell(
              onTap: (() => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog(context),
                    )
                  }),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Cash On Delivery",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),

          // GooglePayButton(
          //   paymentConfigurationAsset: 'gpay.json',
          //   paymentItems: _paymentitems,
          //   type: GooglePayButtonType.buy,
          //   margin: const EdgeInsets.only(top: 15.0),
          //   onPaymentResult: (data) {
          //     print(data);
          //   },
          //   loadingIndicator: const Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // ),
        ],
      ),
    );
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Order Placed'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Your Order is Placed Successfully!!"),
      ],
    ),
    actions: <Widget>[
      new ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
        ),
        onPressed: () {
          Navigator.pushNamed(context, 'home');
        },
        // textColor: Theme.of(context).primaryColor,

        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    ],
  );
}
