import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'models/category/categorymodel.dart';
import 'models/transactions/transcationmodel.dart';
import 'screens/home/screenhome.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(CategorytypeAdapter().typeId)) {
    Hive.registerAdapter(CategorytypeAdapter());
  }
  if (!Hive.isAdapterRegistered(CategorymodelAdapter().typeId)) {
    Hive.registerAdapter(CategorymodelAdapter());
  }
  if (!Hive.isAdapterRegistered(TransactionmodelAdapter().typeId)) {
    Hive.registerAdapter(TransactionmodelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Homescreen(),
    );
  }
}
