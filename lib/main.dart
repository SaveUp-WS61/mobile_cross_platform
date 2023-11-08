import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saveup/providers/chat_provider.dart';
import 'package:saveup/screens/add_card_screen.dart';
import 'package:saveup/screens/add_product_screen.dart';
import 'package:saveup/screens/bot_chat_screen.dart';
import 'package:saveup/screens/cart_screen.dart';
import 'package:saveup/screens/checkout_screen.dart';
import 'package:saveup/screens/edit_publication_product.dart';
import 'package:saveup/screens/deleted_post_screen.dart';
import 'package:saveup/screens/history_buys_screen.dart';
import 'package:saveup/screens/history_sales_screen.dart';
import 'package:saveup/screens/login_screen.dart';
import 'package:saveup/screens/logout_screen.dart';
import 'package:saveup/screens/products_screen.dart';
import 'package:saveup/screens/purchase_confirmation_screen.dart';
import 'package:saveup/screens/recover_password_screen.dart';
import 'package:saveup/screens/register_screen.dart';
import 'package:saveup/screens/save_publication_product.dart';
import 'package:saveup/screens/search_products_screen.dart';
import 'package:saveup/screens/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    /*
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "splash",
      routes: {
        "splash": (context) => const SplashScreen(),
        "logout": (context) => const LogoutScreen(),
        "products":(context) => ProductsScreen(),
      },
    );
    */

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ChatProvide())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "splash",
        routes: {
          "splash": (context) => const SplashScreen(),
          "products": (context) => ProductsScreen(),
          "logout": (context) => const LogoutScreen(),
          "purchase_confirmation": (context) => const PurchaseConfirmationScreen(),
          "history_buys": (context) => const HistoryBuysScreen(),
          "bot_chat": (context) => const BotChatScreen(),
          "add_card": (context) => const AddCardScreen(),
          "cart": (context) => const CartScreen(),
          "checkout": (context) => const CheckoutScreen(),
          "search_products": (context) => const SearchProductsScreen(),
          "login": (context) => LoginScreen(),
          "recover_password":(context) => RecoverPasswordScreen(),
          "register": (context) => RegisterScreen(),
          "company_products": (context) => ProductsScreen(),
          "add_product": (context) => const AddProductScreen(),
          "edit_publication": (context) => EditPublicationProduct(),
          "save_publication": (context) => SavePublicationProduct(),
          "deleted_post": (context) => const DeletedPostScreen(),
          "history_sales":(context) => const HistorySalesScreen(),
        },
      ),
    );
  }
}
