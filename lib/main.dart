import 'package:firebase_core/firebase_core.dart';
import 'package:flower/provider/admin_mode.dart';
import 'package:flower/provider/cart_provider.dart';
import 'package:flower/splash_screen.dart';
import 'package:flower/views/screens/admin_panels/options.dart';
import 'package:flower/views/screens/auth/login_screen.dart';
import 'package:flower/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
return
     MultiProvider(
       providers: [
         ChangeNotifierProvider<CartProvider>(
         create: (context) => CartProvider(),),
         ChangeNotifierProvider<AdminMode>(
           create: (context) => AdminMode(),),
       ],
       child:  const MaterialApp(
    home: LoginScreen(),
    debugShowCheckedModeBanner: false,
 
),
     );
  }

}