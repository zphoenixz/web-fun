import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bl/models/order.dart';
import '../bl/providers/orders_provider.dart';
import '../utils/constants.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({
    // required this.postIndex,
    Key? key,
  }) : super(key: key);

  // final int postIndex;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late OrdersProvider _ordersProvider;
  late ScrollController _postDetailsScrollController;

  late bool _hoverProducts;
  late bool _hoverOrders;

  @override
  void initState() {
    _hoverProducts = false;
    _hoverOrders = false;

    _ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    _postDetailsScrollController = ScrollController();
    _loadOrders();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // _currentPost = _postsProvider.currentPosts[widget.postIndex];
    super.didChangeDependencies();
  }

  _loadOrders() async {
    await _ordersProvider.getOrdersFromApi();
  }

  _showToast(final String notificationText, final Color color) {
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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ordersProvider = Provider.of<OrdersProvider>(context, listen: true);
      _ordersProvider.getOrdersFromApi();
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
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (PointerEvent details) =>
                    setState(() => _hoverOrders = true),
                onExit: (PointerEvent details) =>
                    setState(() => _hoverOrders = false),
                child: Text(
                  "Orders",
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
          Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (PointerEvent details) =>
                    setState(() => _hoverProducts = true),
                onExit: (PointerEvent details) =>
                    setState(() => _hoverProducts = false),
                child: Text(
                  "Products",
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
                  "Orders",
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
              child: Selector<OrdersProvider, List<Order>>(
                selector:
                    (BuildContext context, OrdersProvider ordersProvider) =>
                        ordersProvider.currentOrders,
                shouldRebuild: (previous, next) => true,
                builder: (context, List<Order> currentOrders, child) {
                  return currentOrders.isNotEmpty
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
                          children: _buildTableRows(currentOrders),
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
          ],
        ),
      ),
    );
  }

  _buildTableRows(final List orders) {
    final List<TableRow> rows = [];
    rows.add(TableRow(children: [
      _buildColumnHeader("N#"),
      _buildColumnHeader("Consumer"),
      _buildColumnHeader("Status"),
      _buildColumnHeader("Date"),
      _buildColumnHeader("Total"),
      _buildColumnHeader("Actions"),
    ]));
    for (int i = 0; i < orders.length; i++) {
      rows.add(
        TableRow(
          children: [
            _buildColumn((i + 1).toString()),
            _buildColumn(orders[i].customer),
            _buildColumn(orders[i].status),
            _buildColumn(orders[i].date),
            _buildColumn(orders[i].totalAmount.toString()),
            _buildCTAColumn(orders[i])
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
        color: Constants.lightBlackColor,
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

  _buildCTAColumn(final Order order) {
    return TableCell(
      child: Container(
        height: Constants.toolbarHeight / 2,
        color: Constants.lightBlackColor,
        child: Center(
          child: GestureDetector(
            onTap: () => print("EDIT ORDER!"),
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
}
