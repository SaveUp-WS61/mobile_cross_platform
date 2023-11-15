import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saveup/firebase_options.dart';
import 'package:saveup/providers/chat_provider.dart';
import 'package:saveup/screens/SuccessScreen.dart';
import 'package:saveup/screens/add_card_screen.dart';
import 'package:saveup/screens/add_product_screen.dart';
import 'package:saveup/screens/bot_chat_screen.dart';
import 'package:saveup/screens/cart_screen.dart';
import 'package:saveup/screens/checkout_screen.dart';
import 'package:saveup/screens/company_perfil_screen.dart';
import 'package:saveup/screens/company_products_screen.dart';
import 'package:saveup/screens/edit_publication_product.dart';
import 'package:saveup/screens/deleted_post_screen.dart';
import 'package:saveup/screens/history_buys_screen.dart';
import 'package:saveup/screens/history_sales_screen.dart';
import 'package:saveup/screens/home_screen.dart';
import 'package:saveup/screens/login_screen.dart';
import 'package:saveup/screens/logout_screen.dart';
import 'package:saveup/screens/products_screen.dart';
import 'package:saveup/screens/purchase_confirmation_screen.dart';
import 'package:saveup/screens/recover_password_screen.dart';
import 'package:saveup/screens/register_screen.dart';
import 'package:saveup/screens/save_publication_product.dart';
import 'package:saveup/screens/search_products_screen.dart';
import 'package:saveup/screens/splash_screen.dart';
import 'package:saveup/screens/perfil_screen.dart';
import 'package:saveup/utils/dbhelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Llama a openDb para abrir la base de datos antes de ejecutar la aplicación
  final dbHelper = DbHelper();
  await dbHelper.openDb(); // Abre la base de datos
  
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
          "register": (context) => TipoDeUsuario(),
          "company_products": (context) => CompanyProductsScreen(),
          "add_product": (context) => const AddProductScreen(),
          "edit_publication": (context) => const EditPublicationProduct(),
          "save_publication": (context) => const SavePublicationProduct(),
          "deleted_post": (context) => const DeletedPostScreen(),
          "history_sales":(context) => const HistorySalesScreen(),
          "home": (context) => HomeScreen(),
          "profile":(context) => PerfilComprador(),
          "company_profile":(context) => PerfilCompania(),
          "success": (context) => const SuccessScreen(),
        },
      ),
    );
  }
}
