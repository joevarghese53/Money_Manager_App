import 'package:flutter/material.dart';

import '../category/category_add_popup.dart';
import '../category/screencategory.dart';
import '../transactions/addtransactions.dart';
import '../transactions/transactions.dart';
import 'widgets/widgetbottomnavigation.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  static ValueNotifier<int> selectedindexnotifier = ValueNotifier(0);
  final pages = const [Transactionscreen(), Categoryscreen()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('MONEY MANAGER'),
          centerTitle: true,
        ),
        bottomNavigationBar: const Bottomnavigation(),
        body: ValueListenableBuilder(
          valueListenable: selectedindexnotifier,
          builder: (context, value, child) {
            return pages[value];
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedindexnotifier.value == 0) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const screenaddtransactions();
              }));
            } else {
              showcategoryaddpopup(context);
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
