import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web_fun/bl/providers/products_provider.dart';

import '../bl/models/product.dart';
import '../core/routes.dart';
import '../utils/constants.dart';
import 'form/create_product.dart';
import 'form/edit_product.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({
    // required this.postIndex,
    Key? key,
  }) : super(key: key);

  // final int postIndex;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late ProductsProvider _productsProvider;
  late ScrollController _postDetailsScrollController;

  late bool _hoverProducts;
  late bool _hoverOrders;
  late int _currentPage;
  @override
  void initState() {
    _hoverProducts = false;
    _hoverOrders = false;
    _currentPage = 0;
    _productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    _postDetailsScrollController = ScrollController();
    // _loadOrders();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _loadProducts() async {
    await _productsProvider.getProductsFromApi(_currentPage);
  }

  // _showToast(final String notificationText, final Color color) {
  //   BotToast.showText(
  //     text: notificationText,
  //     contentColor: color,
  //     textStyle: const TextStyle(
  //       fontSize: Constants.bodyFont,
  //       color: Colors.white,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.black87,
        elevation: 5,
        automaticallyImplyLeading: false,
        toolbarHeight: Constants.toolbarHeight,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: Image.asset('assets/images/blz-logo.png'),
            iconSize: Constants.toolbarHeight * 3,
            onPressed: () {},
          ),
        ),
        leadingWidth: Constants.toolbarHeight * 2,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: GestureDetector(
                onTap: () async =>
                    await context.vxNav.push(Uri.parse(Routes.ordersRoute)),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (PointerEvent details) =>
                      setState(() => _hoverProducts = true),
                  onExit: (PointerEvent details) =>
                      setState(() => _hoverProducts = false),
                  child: Text(
                    "Orders",
                    style: TextStyle(
                      fontSize: Constants.subtitleFont,
                      fontFamily: Constants.mainFont,
                      color: Constants.mediumBlackColor,
                      fontWeight: FontWeight.w100,
                      decoration: _hoverProducts
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (PointerEvent details) =>
                    setState(() => _hoverOrders = true),
                onExit: (PointerEvent details) =>
                    setState(() => _hoverOrders = false),
                child: Text(
                  "Products",
                  style: TextStyle(
                    fontSize: Constants.subtitleFont,
                    fontFamily: Constants.mainFont,
                    color: _hoverOrders
                        ? Constants.purpleColor
                        : Constants.mediumBlackColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _postDetailsScrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 60),
                child: Text(
                  "Products",
                  style: TextStyle(
                    fontSize: Constants.superTitleFont,
                    fontFamily: Constants.mainFont,
                    color: Constants.mediumBlackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 30, right: 40.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _createProductDialog(),
                  style: ElevatedButton.styleFrom(
                    primary: Constants.blazeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5.0,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Create Product',
                      style: TextStyle(
                        fontSize: Constants.bodyFont,
                        fontFamily: Constants.mainFont,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 30, right: 40.0),
              child: Selector<ProductsProvider, List<Product>>(
                selector:
                    (BuildContext context, ProductsProvider productsProvider) =>
                        productsProvider.currentProducts,
                shouldRebuild: (previous, next) => true,
                builder: (context, List<Product> currentProducts, child) {
                  return currentProducts.isNotEmpty
                      ? Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(4),
                            2: FlexColumnWidth(3),
                            3: FlexColumnWidth(4),
                            4: FlexColumnWidth(3),
                            5: FlexColumnWidth(4),
                          },
                          border:
                              TableBorder.all(width: 1, color: Colors.black45),
                          children: _buildTableRows(currentProducts),
                        )
                      : const Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(),
                          ),
                        );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 30, right: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_currentPage - 1 >= 0) {
                        setState(() => _currentPage -= 1);
                        _loadProducts();
                      }
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Constants.lightBlackColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          topLeft: Radius.circular(5.0),
                        ),
                        border: Border.all(
                          width: 3.0,
                          // assign the color to the border color
                          color: Constants.lightBlackColor,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Text(
                            'Previous',
                            style: TextStyle(
                              fontSize: Constants.bodyFont,
                              fontFamily: Constants.mainFont,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 3.0,
                        // assign the color to the border color
                        color: Constants.lightBlackColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        (_currentPage + 1).toString(),
                        style: const TextStyle(
                          fontSize: Constants.bodyFont,
                          fontFamily: Constants.mainFont,
                          color: Constants.blazeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _currentPage += 1);
                      _loadProducts();
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Constants.blueLinkColor,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        ),
                        border: Border.all(
                          width: 3.0,
                          color: Constants.blueLinkColor,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontSize: Constants.bodyFont,
                              fontFamily: Constants.mainFont,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTableRows(final List<Product> product) {
    final List<TableRow> rows = [];
    rows.add(TableRow(children: [
      _buildColumnHeader("N#"),
      _buildColumnHeader("Name"),
      _buildColumnHeader("Category"),
      _buildColumnHeader("Price"),
      _buildColumnHeader("Status"),
      _buildColumnHeader("Actions"),
    ]));
    for (int i = 0; i < product.length; i++) {
      rows.add(
        TableRow(
          children: [
            _buildColumn(((i + 1) + _currentPage * 4).toString()),
            _buildColumn(product[i].name!),
            _buildColumn(product[i].category!),
            _buildColumn(product[i].unitPrice!.toString()),
            _buildColumn(product[i].active!.toString()),
            _buildCTAColumn(product[i])
          ],
        ),
      );
    }

    return rows;
  }

  _buildColumnHeader(final String text) {
    return TableCell(
      child: Container(
        height: Constants.toolbarHeight / 2,
        color: Constants.lightBlackColor,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: Constants.bodyFont,
              fontFamily: Constants.mainFont,
              color: Constants.mediumBlackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  _buildColumn(final String text) {
    return TableCell(
      child: Container(
        height: Constants.toolbarHeight / 2,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: Constants.bodyFont,
              fontFamily: Constants.mainFont,
              color: Constants.mediumBlackColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  _buildCTAColumn(final Product product) {
    return TableCell(
      child: Container(
        height: Constants.toolbarHeight / 2,
        color: Constants.lightBlackColor,
        child: Center(
          child: GestureDetector(
            onTap: () => _editProductDialog(product),
            child: const MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                "Edit",
                style: TextStyle(
                  fontSize: Constants.bodyFont,
                  fontFamily: Constants.mainFont,
                  color: Constants.blueLinkColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createProductDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return const CreateProductForm();
      },
    );
  }

  Future<void> _editProductDialog(Product product) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return EditProductForm(product: product);
      },
    );
  }
}
