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
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Money Manager'),
              Text('Track your finances', style: TextStyle(fontSize: 12)),
            ],
          ),
          actions: [
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/user.png'),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const Bottomnavigation(),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0f172a), Color(0xFF1e293b), Color(0xFF0f172a)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ValueListenableBuilder(
            valueListenable: selectedindexnotifier,
            builder: (context, value, child) {
              return pages[value];
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedindexnotifier.value == 0) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const ScreenAddTransactions();
                  },
                ),
              );
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
