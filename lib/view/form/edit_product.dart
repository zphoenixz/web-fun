import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web_fun/bl/models/product.dart';

import '../../bl/providers/products_provider.dart';
import '../../utils/constants.dart';

class EditProductForm extends StatefulWidget {
  const EditProductForm({Key? key, required this.product}) : super(key: key);
  final Product product;
  @override
  State<EditProductForm> createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameTextEditingController;
  late TextEditingController _priceTextEditingController;

  late ProductsProvider _productsProvider;

  final List<String> _productCategory = [
    "COOKIES",
    "CANDIES",
    "CAKES",
    "DESSERTS",
    "DRINKS"
  ];

  final List<String> _productStatus = ["true", "false"];
  late String _selectedProductStatus;
  late String _selectedCategory;

  @override
  void initState() {
    _productsProvider = Provider.of<ProductsProvider>(context, listen: false);

    _nameTextEditingController =
        TextEditingController(text: widget.product.name);
    _priceTextEditingController =
        TextEditingController(text: widget.product.unitPrice.toString());
    _selectedCategory = widget.product.category!;
    _selectedProductStatus = widget.product.active.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Editing Product ${widget.product.productId}",
        style: const TextStyle(
          fontSize: Constants.subtitleFont,
          fontFamily: Constants.mainFont,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: 500,
        height: 800,
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameTextEditingController,
                  validator: (value) {
                    return value!.isNotEmpty
                        ? null
                        : "Fill a Product Name please";
                  },
                  style: const TextStyle(
                    fontSize: Constants.bodyFont,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    suffix: Text(
                      'Product Name',
                      style: TextStyle(
                        fontSize: Constants.contentFont,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _priceTextEditingController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    return value!.isNotEmpty
                        ? null
                        : "Fill a Product Price please";
                  },
                  style: const TextStyle(
                    fontSize: Constants.bodyFont,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Unit Price',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    suffix: Text(
                      'Unit Price',
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
                      'Product Category',
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
                    items: _productCategory.map((String orderStatus) {
                      return DropdownMenuItem(
                        value: orderStatus,
                        child: Text(
                          orderStatus,
                          style: const TextStyle(
                            fontSize: Constants.bodyFont,
                            fontFamily: Constants.mainFont,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                    value: _selectedCategory,
                    onChanged: (String? value) {
                      _selectedCategory = value!;
                      setState(() {});
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Product Status',
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
                    items: _productStatus.map((String productStatus) {
                      return DropdownMenuItem(
                        value: productStatus,
                        child: Text(
                          productStatus,
                          style: const TextStyle(
                            fontSize: Constants.bodyFont,
                            fontFamily: Constants.mainFont,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                    value: _selectedProductStatus,
                    onChanged: (String? value) {
                      _selectedProductStatus = value!;
                      setState(() {});
                    },
                  ),
                ),
              ],
            )),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
          child: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 255, 102, 102))),
            child: const Text(
              "Delete",
              style: TextStyle(
                color: Colors.white,
                fontSize: Constants.bodyFont,
                fontFamily: Constants.mainFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              _productsProvider.deleteOrderFromApi(
                widget.product.productId!,
              );

              Navigator.of(context).pop();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
          child: TextButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Constants.blueLinkColor)),
            child: const Text(
              "Update",
              style: TextStyle(
                color: Colors.white,
                fontSize: Constants.bodyFont,
                fontFamily: Constants.mainFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _nameTextEditingController.value;
                _productsProvider.patchOrderFromApi(
                  Product(
                      productId: widget.product.productId,
                      name: _nameTextEditingController.text,
                      unitPrice: double.parse(_priceTextEditingController.text),
                      category: _selectedCategory,
                      active: _selectedProductStatus),
                );

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
