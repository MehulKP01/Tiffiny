import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tiffiny/Screens/tiffin_menu.dart';
import 'package:tiffiny/kitchen_data.dart';
import 'package:tiffiny/widgets/big_text.dart';
import 'package:tiffiny/widgets/icon_text.dart';
import 'package:tiffiny/widgets/small_text.dart';
import 'package:http/http.dart' as http;

import '../utils/dimensions.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List kitchen = [];
  Map<String, List<String>> Menu = {};
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();
    this.fetchkitchen();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

  fetchkitchen() async {
    var url = "https://mytiffiny.000webhostapp.com/display.php";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var items = json.decode(response.body);

      setState(() {
        kitchen = items;
        // final List<KitchenDataModel> kitchendata = List.generate(
        //     kitchen.length,
        //     (index) => KitchenDataModel(
        //         '${kitchen[index]['name']}', '${kitchen[index]['city']}'));
      });
    } else {
      setState(() {
        kitchen = [];
      });
    }
  }

  @override
  void dispose() {
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: Dimensions.pageView,
          // color: Colors.red,
          child: PageView.builder(
            controller: pageController,
            itemCount: kitchen.length,
            itemBuilder: (context, position) {
              return _buildPageItem(position);
            },
          ),
        ),
        // ignore: unnecessary_new
        new DotsIndicator(
          dotsCount: 2,
          position: _currPageValue,
          decorator: DotsDecorator(
            activeColor: Colors.amber,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
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
        Container(
          height: 700,
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),

              // shrinkWrap: true,
              itemCount: kitchen.length,
              itemBuilder: (context, index) {
                return InkWell(
                  child: Container(
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
                                  BorderRadius.circular(Dimensions.radius20),
                              color: Colors.white38,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      kitchen[index]['Tiffin_Image_url']))),
                        ),
                        Expanded(
                            child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(Dimensions.radius20),
                                bottomRight:
                                    Radius.circular(Dimensions.radius20)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: Dimensions.width10,
                                right: Dimensions.width10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BigText(text: kitchen[index]['Tiffin_Name']),
                                SizedBox(
                                  height: Dimensions.height10,
                                ),
                                SizedBox(
                                  height: Dimensions.height10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconAndText(
                                        icon: Icons.location_on,
                                        text: "1.7km",
                                        Iconcolor: Colors.amber),
                                    IconAndText(
                                        icon: Icons.access_time_rounded,
                                        text: "32Min",
                                        Iconcolor: Colors.orangeAccent)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            TiffinMenu(ind: kitchen[index]['T_id'])));
                    print(kitchen[index]['T_id']);
                  },
                );
              }),
        ),
      ],
    );
  }

  Widget _buildPageItem(int index) {
    Matrix4 matrix = Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - currScale) / 2, 1);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            height: Dimensions.pageViewContainer,
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                color: index.isEven ? Color(0xFF69c5df) : Color(0xFF9294cc),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(kitchen[index]['Tiffin_Image_url']))),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextContainer,
              margin: EdgeInsets.only(left: 30, right: 30, bottom: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFFe8e8e8),
                      blurRadius: 5.0,
                      offset: Offset(0, 5)),
                  BoxShadow(color: Colors.white, offset: Offset(-5, 0)),
                  BoxShadow(color: Colors.white, offset: Offset(5, 0)),
                ],
              ),
              child: Container(
                padding: EdgeInsets.only(
                    top: Dimensions.height15, left: 15, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(text: kitchen[index]['Tiffin_Name']),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    Row(
                      children: [
                        Wrap(
                          children: List.generate(
                              5,
                              (index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 15,
                                  )),
                        ),
                        SizedBox(
                          width: Dimensions.height20,
                        ),
                        SmallText(
                          text: "4.5",
                          color: Colors.blueGrey,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconAndText(
                            icon: Icons.circle_sharp,
                            text: "Normal",
                            Iconcolor: Colors.yellow),
                        IconAndText(
                            icon: Icons.location_on,
                            text: "1.7km",
                            Iconcolor: Colors.amber),
                        IconAndText(
                            icon: Icons.access_time_rounded,
                            text: "32Min",
                            Iconcolor: Colors.orangeAccent)
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
