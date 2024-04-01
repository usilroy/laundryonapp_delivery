import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '/Provider/orderprovider.dart';
import '/Models/order.dart';
import '/Widgets/datapoint.dart';
import '../API_calls/order.dart';
import '/Provider/authData_provider.dart';

import '/Screens/active_order_details_screen.dart';

enum Tab { ongoing, newOrder }

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedTab == Tab.newOrder) {
        fetchCustomertoLaundromatOrders(ref);
      }
    });
  }

  void switchTab(Tab newTab) {
    if (newTab != selectedTab) {
      setState(() {
        selectedTab = newTab;
      });
      if (selectedTab == Tab.newOrder) {
        fetchCustomertoLaundromatOrders(ref);
      }
    }
  }

  void _changeOngoingnewOrderstatus(String orderId, bool newStatus) {
    ref
        .read(orderListProvider.notifier)
        .updateOngoingStatus(orderId, newStatus);
  }

  Tab selectedTab = Tab.newOrder;

  @override
  Widget build(BuildContext context) {
    String style =
        'feature:poi|visibility:off&style=feature:poi.park|visibility:on&style=feature:transit|visibility:off';
    String mapAPIkey = 'AIzaSyBkGBM8chYfUdEj6j2Wwxj_LV7KTQQMwg0';
    String getStaticMapUrl(
        double latitude, double longitude, int width, int height) {
      return 'https://maps.googleapis.com/maps/api/staticmap?center=${latitude},$longitude&zoom=15&size=${width}x${height}&maptype=roadmap&markers=color:0x723CE8%7Clabel:C%7C$latitude,$longitude&style=$style&key=$mapAPIkey';
    }

    final allOrders2 = ref.watch(orderListProvider2);
    final newOrders2 = allOrders2.where((order) => !order.ongoing).toList();
    final onGoingOrder2 = allOrders2.where((order) => order.ongoing).toList();

    final allOrders = ref.watch(orderListProvider);
    final newOrders = ref.watch(orderListProvider2);
    // final newOrders = allOrders.where((order) => !order.ongoing).toList();
    final onGoingOrder = allOrders.where((order) => order.ongoing).toList();
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double statusBarHeight = mediaQueryData.padding.top;
    String authToken = ref.watch(authDataProvider).token;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(240),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(76, 149, 230, 0.4),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Image.asset('assets/white_orb.png'),
            ),
            Positioned(
              left: 31,
              top: 15,
              child: SvgPicture.asset('assets/top_left_bubbles.svg'),
            ),
            Positioned(
              right: 22,
              bottom: 20,
              child: SvgPicture.asset('assets/bottom_right_bubbles.svg'),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SvgPicture.asset('assets/Appbar_graphic.svg'),
            ),
            Positioned(
              right: 0,
              left: 21,
              top: statusBarHeight + 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, Uttiyo",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 24,
                        height: 3 / 2,
                        fontWeight: FontWeight.bold),
                  ),
                  const Wrap(
                    children: [
                      Text("Congrats! You have completed 7 Orders so far."),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 38),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Material(
                      color: selectedTab == Tab.ongoing
                          ? const Color(0xFF4C95EF)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          if (selectedTab != Tab.ongoing) {
                            setState(() {
                              selectedTab = Tab.ongoing;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Center(
                            child: Text(
                              "Ongoing",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 14,
                                    color: selectedTab == Tab.ongoing
                                        ? Colors.white
                                        : const Color(0xFF939393),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Material(
                      color: selectedTab == Tab.newOrder
                          ? const Color(0xFF4C95EF)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          if (selectedTab != Tab.newOrder) {
                            setState(() {
                              selectedTab = Tab.newOrder;
                            });
                            fetchCustomertoLaundromatOrders(ref);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Center(
                            child: Text(
                              "New Orders",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 14,
                                    color: selectedTab == Tab.newOrder
                                        ? Colors.white
                                        : const Color(0xFF939393),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          selectedTab == Tab.ongoing
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          onGoingOrder.isNotEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFCECECE),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xFFE9E9E9),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Image.network(
                                          getStaticMapUrl(
                                            onGoingOrder[0].fromLat,
                                            onGoingOrder[0].fromLng,
                                            500,
                                            110,
                                          ),
                                          width: double.infinity,
                                          height: 110,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const Gap(10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/location.svg'),
                                              const Gap(10),
                                              RichText(
                                                text: TextSpan(
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          color: const Color(
                                                              0xFF1C2649),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                  children: <TextSpan>[
                                                    const TextSpan(
                                                        text: 'Going to '),
                                                    TextSpan(
                                                      text: onGoingOrder[0]
                                                                  .goingTo ==
                                                              GoingTo.launderer
                                                          ? 'Customer'
                                                          : 'Launderer',
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFF723CE8),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Material(
                                            color: const Color(0xFFF1ECFD),
                                            shape: const CircleBorder(),
                                            child: InkWell(
                                              onTap: () {},
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Container(
                                                  height: 24,
                                                  width: 24,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle),
                                                  child: Center(
                                                    child: SvgPicture.asset(
                                                      'assets/phone.svg',
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(15),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/sample_customer_image.jpg',
                                            height: 32,
                                            width: 32,
                                          ),
                                          const Gap(10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(onGoingOrder[0]
                                                    .fromLocationName),
                                                Text(
                                                  onGoingOrder[0]
                                                      .fromLocationAddress,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: const Color(
                                                            0xFF747474),
                                                        fontSize: 12,
                                                      ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const Gap(10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                DataPoint(
                                                    label: 'Distance: ',
                                                    value:
                                                        '${onGoingOrder[0].distance} mi'),
                                                const Gap(3),
                                                DataPoint(
                                                    label: 'Delivery fee: ',
                                                    value:
                                                        '\$${onGoingOrder[0].deliveryFee}'),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                DataPoint(
                                                    label: 'Weight: ',
                                                    value:
                                                        '${onGoingOrder[0].weight} pounds'),
                                                const Gap(3),
                                                DataPoint(
                                                    label: 'Order ID: ',
                                                    value:
                                                        '#${onGoingOrder[0].orderId}'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(
                                        20,
                                      ),
                                      Material(
                                        color: const Color(0xFF4C95EF),
                                        borderRadius: BorderRadius.circular(7),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ActiveOrderDetailsScreen()),
                                            );
                                          },
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 37.5,
                                            child: Center(
                                              child: Text(
                                                'Order details',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 375,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Pick up a new order and \n get started!',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontSize: 20,
                                                height: 3 / 2,
                                                color: const Color(0xFF939393),
                                              ),
                                        ),
                                        const Gap(60),
                                        Material(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color(0xFF4C95EF),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            onTap: () {},
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 15,
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 0.1),
                                                    )
                                                  ]),
                                              height: 40,
                                              width: 211,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3),
                                              child: Center(
                                                child: Text(
                                                  "New Orders",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.separated(
                      itemCount: newOrders.length,
                      itemBuilder: (context, index) => Container(
                        padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFCECECE),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF723CE8),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(3),
                                      bottomRight: Radius.circular(3),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${newOrders[index].distance} mi',
                                      style: const TextStyle(
                                          color: Colors.white, height: 14 / 21),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD5C5F9),
                                    borderRadius: BorderRadius.circular(315),
                                  ),
                                  child: Text(
                                    '${newOrders[index].weight} pounds',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: const Color(0xFF723CE8),
                                          fontWeight: FontWeight.w500,
                                          height: 17 / 14,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(12),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        height: 32,
                                        width: 32,
                                        decoration: const BoxDecoration(
                                            color: Color(0xFFD5C5F9),
                                            shape: BoxShape.circle),
                                        child: SvgPicture.asset(
                                          newOrders[index].goingTo ==
                                                  GoingTo.customer
                                              ? 'assets/launderer_icon.svg'
                                              : 'assets/customer_icon.svg',
                                        ),
                                      ),
                                      const Gap(3),
                                      SvgPicture.asset(
                                          'assets/dotted_line.svg'),
                                      const Gap(3),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 32,
                                        width: 32,
                                        decoration: const BoxDecoration(
                                            color: Color(0xFFD5C5F9),
                                            shape: BoxShape.circle),
                                        child: SvgPicture.asset(
                                          newOrders[index].goingTo ==
                                                  GoingTo.customer
                                              ? 'assets/customer_icon.svg'
                                              : 'assets/launderer_icon.svg',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          newOrders[index].fromLocationName,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                height: 1.55,
                                              ),
                                        ),
                                        Text(
                                          newOrders[index].fromLocationAddress,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: const Color(0xFF747474),
                                                fontSize: 12,
                                                height: 1.55,
                                              ),
                                        ),
                                        const Gap(24),
                                        Text(
                                          newOrders[index].toLocationName,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                height: 1.55,
                                              ),
                                        ),
                                        Text(
                                          newOrders[index].toLocationAddress,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: const Color(0xFF747474),
                                                fontSize: 12,
                                                height: 1.55,
                                              ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Gap(15),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: SizedBox(
                                width: double.infinity,
                                child: Material(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color(0xFF00CB9A),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () async {
                                      int orderId =
                                          int.parse(newOrders[index].orderId);
                                      await acceptOrder(orderId, authToken);

                                      selectedTab = Tab.ongoing;
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 15,
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.1),
                                          )
                                        ],
                                      ),
                                      height: 40,
                                      width: 211,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      child: Center(
                                        child: Text(
                                          "Accept",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      separatorBuilder: (context, index) {
                        return const Gap(12);
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
