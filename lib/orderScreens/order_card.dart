import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/helper/sizebox_helper.dart';
import 'package:sellers_app/models/Items.dart';
import 'package:sellers_app/orderScreens/order_details_screen.dart';

class OrderCard extends StatefulWidget {
  int? itemCount;
  List<DocumentSnapshot>? data;
  String? orderId;
  List<String>? quantitiesList;

  OrderCard(
      {this.itemCount,
      this.data,
      this.orderId,
      this.quantitiesList,
      super.key});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (e) => OrderDetailsScreen(
                      orderId: widget.orderId,
                    )));
      },
      child: Card(
        color: Colors.black,
        elevation: 10,
        shadowColor: Colors.white54,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          height: widget.itemCount! * 140,
          child: ListView.builder(
            itemCount: widget.itemCount,
            itemBuilder: (context, index) {
              Items items = Items.fromJson(
                  widget.data![index].data() as Map<String, dynamic>);
              return placeOrdersItemsDesignWidget(
                  items, context, widget.quantitiesList?[index]);
            },
          ),
        ),
      ),
    );
  }
}

Widget placeOrdersItemsDesignWidget(
    Items items, BuildContext context, quantities) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    color: Colors.transparent,
    child: Row(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              items.thumbnailUrl.toString(),
              width: 120,
            )),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //title and price
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      items.itemTitle!,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          "₹",
                          style: TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          items.price!,
                          style: const TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBoxHelper.sizeBox20,
              //multiplication number with quantity number
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "x ",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        quantities,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
