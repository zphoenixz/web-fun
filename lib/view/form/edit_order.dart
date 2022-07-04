import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_fun/bl/models/product.dart';
import 'package:web_fun/bl/models/product_qty.dart';

import '../../bl/models/order.dart';
import '../../bl/providers/orders_provider.dart';
import '../../bl/providers/products_provider.dart';
import '../../utils/constants.dart';

class EditOrderForm extends StatefulWidget {
  const EditOrderForm({required this.order, Key? key}) : super(key: key);
  final Order order;
  @override
  State<EditOrderForm> createState() => _EditOrderFormState();
}

class _EditOrderFormState extends State<EditOrderForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _textEditingController;

  late OrdersProvider _ordersProvider;
  late ProductsProvider _productsProvider;

  late bool _update;
  final List<String> _orderStatus = ["PENDING", "COMPLETED", "REJECTED"];

  @override
  void initState() {
    _ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    _productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    _textEditingController = TextEditingController(text: widget.order.customer);
    _update = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double subTotal = 0;
    for (var productQty in widget.order.products!) {
      subTotal += productQty.product!.unitPrice! * productQty.qty!;
    }

    return AlertDialog(
      title: Text(
        "View/Edit Order ${widget.order.orderNumber}",
        style: const TextStyle(
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
                  // initialValue: widget.order.customer,
                  enabled: false,
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
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Edit Qty Product',
                      style: TextStyle(
                        fontSize: Constants.bodyFont,
                        fontFamily: Constants.mainFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.order.products!.length,
                  itemBuilder: (_, index) {
                    final ProductQty currentProduct =
                        widget.order.products![index];
                    return ListTile(
                      leading: Text(
                        '${currentProduct.product!.unitPrice.toString()}\$',
                        style: const TextStyle(
                          fontSize: Constants.contentFont,
                          fontFamily: Constants.mainFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: Text(
                        currentProduct.product!.name!,
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
                                widget.order.products![index].qty =
                                    widget.order.products![index].qty! + 1;
                                _update = true;
                                setState(() {});
                              },
                              icon: const Icon(Icons.add_circle),
                            ),
                            IconButton(
                              onPressed: () {
                                final newQty =
                                    widget.order.products![index].qty =
                                        widget.order.products![index].qty! - 1;
                                if (newQty >= 0) {
                                  widget.order.products![index].qty = newQty;
                                  _update = true;
                                  setState(() {});
                                }
                              },
                              icon: const Icon(Icons.remove_circle),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                widget.order.products![index].qty.toString(),
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
                ),
                const Divider(thickness: 3),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Edit Order Status',
                      style: TextStyle(
                        fontSize: Constants.bodyFont,
                        fontFamily: Constants.mainFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: DropdownButton(
                    items: _orderStatus.map((String orderStatus) {
                      return DropdownMenuItem(
                        value: orderStatus,
                        child: Text(
                          orderStatus,
                          style: TextStyle(
                            color: orderStatus == "PENDING"
                                ? const Color.fromARGB(255, 244, 215, 112)
                                : orderStatus == "REJECTED"
                                    ? const Color.fromARGB(255, 244, 112, 112)
                                    : const Color.fromARGB(255, 65, 255, 65),
                            fontSize: Constants.bodyFont,
                            fontFamily: Constants.mainFont,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                    value: widget.order.status,
                    onChanged: (String? value) {
                      widget.order.status = value;
                      setState(() {});
                    },
                  ),
                ),
                const Divider(thickness: 3),
                const Padding(padding: EdgeInsets.only(top: 20.0, bottom: 20)),
                _buildTax('Subtotal', subTotal.toString(), true),
                const Padding(padding: EdgeInsets.only(bottom: 5)),
                _buildTax('Total City Tax',
                    widget.order.taxAmounts!.cityTax.toString(), false),
                _buildTax('Total County Tax',
                    widget.order.taxAmounts!.countyTax.toString(), false),
                _buildTax('Total State Tax',
                    widget.order.taxAmounts!.stateTax.toString(), false),
                _buildTax('Total Federal Tax',
                    widget.order.taxAmounts!.federalTax.toString(), false),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                _buildTax(
                    'Total Taxes', widget.order.totalTaxes.toString(), true),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                _buildTax('Total', widget.order.totalAmount.toString(), true),
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
              "Update Order",
              style: TextStyle(
                color: Colors.white,
                fontSize: Constants.bodyFont,
                fontFamily: Constants.mainFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              if (widget.order.products!.isNotEmpty) {
                _ordersProvider.patchOrderFromApi(Order(
                    status: widget.order.status,
                    orderNumber: widget.order.orderNumber,
                    customer: _textEditingController.text,
                    products: widget.order.products!));

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

  Widget _buildTax(String title, String tax, bool isTitle) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Text(
        title,
        style: TextStyle(
          fontSize: isTitle ? Constants.bodyFont : Constants.contentFont,
          fontFamily: Constants.mainFont,
          fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Text(
          _update && title != "Subtotal" ? '-' : '$tax\$',
          style: TextStyle(
            fontSize: isTitle ? Constants.bodyFont : Constants.contentFont,
            fontFamily: Constants.mainFont,
          ),
        ),
      ),
    ]);
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
