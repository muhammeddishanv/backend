// lib/app/modules/store/store.view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../global_widgets/store_card.dart';
import 'store.controller.dart';
// import '../../global_widgets/custom_nav_bar.dart';

class StoreDetails {
  final String title;
  final IconData iconData;
  final String price;

  StoreDetails({
    required this.title,
    required this.iconData,
    required this.price,
  });
}

final List<StoreDetails> storeList = [
  StoreDetails(
    title: "1 Coin",
    iconData: Icons.monetization_on,
    price: "₹ 100.0",
  ),
  StoreDetails(
    title: "5 Coins",
    iconData: Icons.monetization_on,
    price: "₹ 500",
  ),
  StoreDetails(
    title: "10 Coins",
    iconData: Icons.monetization_on,
    price: "₹ 1000",
  ),
  StoreDetails(
    title: "15 Coins",
    iconData: Icons.monetization_on,
    price: "₹ 1500",
  ),
  StoreDetails(
    title: "20 Coins",
    iconData: Icons.monetization_on,
    price: "₹ 2000",
  ),
  StoreDetails(
    title: "20 Coins",
    iconData: Icons.monetization_on,
    price: "₹ 2000",
  ),
];

final List<StoreDetails> exchangeList = [
  StoreDetails(title: "1 Coin", iconData: Icons.refresh, price: "100 pts"),
  StoreDetails(title: "5 Coins", iconData: Icons.refresh, price: "500 pts"),
  StoreDetails(title: "10 Coins", iconData: Icons.refresh, price: "1000 pts"),
  StoreDetails(title: "15 Coins", iconData: Icons.refresh, price: "1500 pts"),
];

class StoreView extends GetResponsiveView<StoreController> {
  StoreView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget? phone() {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Store'),
            centerTitle: true,
            backgroundColor: Get.theme.colorScheme.primary,
            foregroundColor: Get.theme.colorScheme.onPrimary,
            elevation: 0,
            pinned: true,
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: kToolbarHeight),
                  child: Row(
                    children: [
                      Transform.translate(
                        offset: const Offset(-10, 10),
                        child: Icon(
                          Icons.store_outlined,
                          color: Get.theme.colorScheme.onPrimary.withAlpha(50),
                          size: 150,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 75),
                        child: _infoChip(
                          Icons.star_border_outlined,
                          "120 Points",
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 75, right: 16),
                        child: _infoChip(
                          Icons.monetization_on_outlined,
                          "9 Coins",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content padding
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    Text(
                      "Buy Coins",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.history),
                  ],
                ),
                const SizedBox(height: 8),
              ]),
            ),
          ),

          // Buy Coins list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  if (i.isOdd) return const SizedBox(height: 10);
                  final index = i ~/ 2;
                  final item = storeList[index];
                  return StoreItemCard(
                    icon: item.iconData,
                    title: item.title,
                    price: item.price,
                  );
                },
                childCount: storeList.isEmpty ? 0 : storeList.length * 2 - 1,
              ), // Adjusted childCount for spacing (no trailing spacer)
            ),
          ),

          // Exchange header
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Exchange Points",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),

          // Exchange list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  if (i.isOdd) return const SizedBox(height: 10);
                  final index = i ~/ 2;
                  final item = exchangeList[index];
                  return StoreItemCard(
                    icon: item.iconData,
                    title: item.title,
                    price: item.price,
                  );
                },
                childCount: exchangeList.isEmpty
                    ? 0
                    : exchangeList.length * 2 - 1,
              ),
            ),
          ),
          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  @override
  Widget? tablet() => phone();

  @override
  Widget? desktop() => phone();

  Widget _infoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(
        icon,
        size: 15,
        color: Theme.of(Get.context!).colorScheme.primary,
      ),
      label: Text(text),
      backgroundColor: Theme.of(Get.context!).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
