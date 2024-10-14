import 'package:fixmycar_car_repair_shop/src/providers/car_models_by_manufacturer_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/car_parts_shop_discount_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/car_parts_shop_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/car_repair_shop_discount_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/car_repair_shop_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/car_repair_shop_service_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/chat_history_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/order_detail_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/order_essential_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/order_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/recommender_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/reservation_detail_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/reservation_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/service_type_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/store_item_category_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/store_item_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/auth_provider.dart';
import 'package:fixmycar_car_repair_shop/app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CarRepairShopServiceProvider()),
        ChangeNotifierProvider(create: (_) => ServiceTypeProvider()),
        ChangeNotifierProvider(create: (_) => CarRepairShopDiscountProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
        ChangeNotifierProvider(create: (_) => ReservationDetailProvider()),
        ChangeNotifierProvider(create: (_) => OrderEssentialProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => OrderDetailProvider()),
        ChangeNotifierProvider(create: (_) => CarRepairShopProvider()),
        ChangeNotifierProvider(create: (_) => CarPartsShopProvider()),
        ChangeNotifierProvider(create: (_) => StoreItemProvider()),
        ChangeNotifierProvider(create: (_) => StoreItemCategoryProvider()),
        ChangeNotifierProvider(
            create: (_) => CarModelsByManufacturerProvider()),
        ChangeNotifierProvider(create: (_) => CarPartsShopDiscountProvider()),
        ChangeNotifierProvider(create: (_) => RecommenderProvider()),
        ChangeNotifierProvider(create: (_) => ChatHistoryProvider())
      ],
      child: const MyApp(),
    ),
  );
}
