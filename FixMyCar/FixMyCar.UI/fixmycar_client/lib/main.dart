import 'package:fixmycar_client/app.dart';
import 'package:fixmycar_client/src/providers/car_models_by_manufacturer_provider.dart';
import 'package:fixmycar_client/src/providers/car_parts_shop_discount_provider.dart';
import 'package:fixmycar_client/src/providers/car_parts_shop_provider.dart';
import 'package:fixmycar_client/src/providers/car_repair_shop_discount_provider.dart';
import 'package:fixmycar_client/src/providers/car_repair_shop_provider.dart';
import 'package:fixmycar_client/src/providers/car_repair_shop_services_provider.dart';
import 'package:fixmycar_client/src/providers/client_provider.dart';
import 'package:fixmycar_client/src/providers/auth_provider.dart';
import 'package:fixmycar_client/src/providers/order_detail_provider.dart';
import 'package:fixmycar_client/src/providers/order_essential_provider.dart';
import 'package:fixmycar_client/src/providers/order_provider.dart';
import 'package:fixmycar_client/src/providers/reservation_detail_provider.dart';
import 'package:fixmycar_client/src/providers/reservation_provider.dart';
import 'package:fixmycar_client/src/providers/store_item_category_provider.dart';
import 'package:fixmycar_client/src/providers/store_item_provider.dart';
import 'package:fixmycar_client/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = 'publishable key here';
  await Stripe.instance.applySettings();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ClientProvider()),
        ChangeNotifierProvider(create: (_) => CarPartsShopProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => StoreItemCategoryProvider()),
        ChangeNotifierProvider(create: (_) => StoreItemProvider()),
        ChangeNotifierProvider(
            create: (_) => CarModelsByManufacturerProvider()),
        ChangeNotifierProvider(create: (_) => OrderDetailProvider()),
        ChangeNotifierProvider(create: (_) => CarRepairShopProvider()),
        ChangeNotifierProvider(create: (_) => CarRepairShopServiceProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
        ChangeNotifierProvider(create: (_) => ReservationDetailProvider()),
        ChangeNotifierProvider(create: (_) => OrderEssentialProvider()),
        ChangeNotifierProvider(create: (_) => CarRepairShopDiscountProvider()),
        ChangeNotifierProvider(create: (_) => CarPartsShopDiscountProvider())
      ],
      child: const MyApp(),
    ),
  );
}
