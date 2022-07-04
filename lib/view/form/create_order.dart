import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_fun/bl/models/product.dart';
import 'package:web_fun/bl/models/product_qty.dart';

import '../../bl/models/order.dart';
import '../../bl/providers/orders_provider.dart';
import '../../bl/providers/products_provider.dart';
import '../../utils/constants.dart';

class CreateOrderForm extends StatefulWidget {
  const CreateOrderForm({Key? key}) : super(key: key);

  @override
  State<CreateOrderForm> createState() => _CreateOrderFormState();
}

class _CreateOrderFormState extends State<CreateOrderForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();

  late OrdersProvider _ordersProvider;
  late ProductsProvider _productsProvider;

  final List<ProductQty> _chosenProducts = [];
  @override
  void initState() {
    _ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    _productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double subTotal = 0;
    for (var productQty in _chosenProducts) {
      subTotal += productQty.product!.unitPrice! * productQty.qty!;
    }

    return AlertDialog(
      title: const Text(
        "Creating Order",
        style: TextStyle(
          fontSize: Constants.subtitleFont,
          fontFamily: Constants.mainFont,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: 500,
        height: 1500,
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _textEditingController,
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Fill a name please";
                  },
                  style: const TextStyle(
                    fontSize: Constants.bodyFont,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Customer Name',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    suffix: Text(
                      'Customer Name',
                      style: TextStyle(
                        fontSize: Constants.contentFont,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Text(
                    'Choose Product',
                    style: TextStyle(
                      fontSize: Constants.bodyFont,
                      fontFamily: Constants.mainFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FutureBuilder<List<Product>>(
                  future: _productsProvider.getProductsFromApi(0),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Product>> snapshot) {
                    if (snapshot.hasData) {
                      final List<Product> products = snapshot.data!;

                      return ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: products.length,
                        itemBuilder: (_, index) {
                          final List<ProductQty> currentProduct =
                              _chosenProducts
                                  .where((productQty) =>
                                      productQty.product!.productId ==
                                      products[index].productId)
                                  .toList();

                          return ListTile(
                            leading: Text(
                              '${products[index].unitPrice!.toString()}\$',
                              style: const TextStyle(
                                fontSize: Constants.contentFont,
                                fontFamily: Constants.mainFont,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            title: Text(
                              products[index].name!,
                              style: const TextStyle(
                                fontSize: Constants.contentFont,
                                fontFamily: Constants.mainFont,
                              ),
                            ),
                            trailing: SizedBox(
                              width: 200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      final List<ProductQty> chosenProduct =
                                          _chosenProducts
                                              .where((productQty) =>
                                                  productQty
                                                      .product!.productId ==
                                                  products[index].productId)
                                              .toList();

                                      if (chosenProduct.isEmpty) {
                                        _chosenProducts.add(
                                          ProductQty(
                                              product: products[index], qty: 1),
                                        );
                                      } else {
                                        chosenProduct[0].qty =
                                            chosenProduct[0].qty! + 1;
                                      }
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.add_circle),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (currentProduct.isNotEmpty) {
                                        final newQty =
                                            currentProduct[0].qty! - 1;
                                        if (newQty == 0) {
                                          _chosenProducts
                                              .remove(currentProduct[0]);
                                        } else {
                                          _chosenProducts[0].qty = newQty;
                                        }
                                        setState(() {});
                                      }
                                    },
                                    icon: const Icon(Icons.remove_circle),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      (currentProduct.isEmpty
                                              ? 0
                                              : currentProduct[0].qty)
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: Constants.contentFont,
                                        fontFamily: Constants.mainFont,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(),
                      );
                    }

                    return const CircularProgressIndicator();
                  },
                ),
                const Divider(thickness: 3),
                const Padding(padding: EdgeInsets.only(top: 20.0, bottom: 20)),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  const Text(
                    'Subtotal (Tax. not inc.)',
                    style: TextStyle(
                      fontSize: Constants.bodyFont,
                      fontFamily: Constants.mainFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Text(
                      '${subTotal.toString()}\$',
                      style: const TextStyle(
                        fontSize: Constants.bodyFont,
                        fontFamily: Constants.mainFont,
                      ),
                    ),
                  ),
                ])
              ],
            )),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
          child: TextButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Constants.blueLinkColor)),
            child: const Text(
              "Send Order",
              style: TextStyle(
                color: Colors.white,
                fontSize: Constants.bodyFont,
                fontFamily: Constants.mainFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate() &&
                  _chosenProducts.isNotEmpty) {
                _textEditingController.value;

                _ordersProvider.createOrderFromApi(Order(
                    customer: _textEditingController.text,
                    products: _chosenProducts));

                Navigator.of(context).pop();
              } else {
                showToast(
                    "Fields needed", const Color.fromARGB(255, 232, 68, 101));
              }
            },
          ),
        ),
      ],
    );
  }

  showToast(final String notificationText, final Color color) {
    BotToast.showText(
      text: notificationText,
      contentColor: color,
      textStyle: const TextStyle(
        fontSize: Constants.bodyFont,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
