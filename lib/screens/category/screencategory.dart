import 'package:flutter/material.dart';

import '../../db/category/categorydbfunctions.dart';
import 'expenselist.dart';
import 'incomelist.dart';

class Categoryscreen extends StatefulWidget {
  const Categoryscreen({super.key});

  @override
  State<Categoryscreen> createState() => _CategoryscreenState();
}

class _CategoryscreenState extends State<Categoryscreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    Categoryfunctions.instance.refreshui();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            controller: tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(
                text: 'INCOME',
              ),
              Tab(
                text: 'EXPENSE',
              )
            ]),
        Expanded(
            child: TabBarView(
                controller: tabController,
                children: const [Incomelist(), Expenselist()]))
      ],
    );
  }
}
