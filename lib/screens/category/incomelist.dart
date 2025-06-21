import 'package:flutter/material.dart';

import '../../db/category/categorydbfunctions.dart';

class Incomelist extends StatelessWidget {
  const Incomelist({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Categoryfunctions().incomelistnotifier,
        builder: (context, newlist, _) {
          return ListView.separated(
            itemBuilder: (context, index) {
              final _category = newlist[index];
              return Card(
                child: ListTile(
                  title: Text(_category.name),
                  trailing: IconButton(
                    onPressed: () {
                      Categoryfunctions.instance.deletecategory(_category.id);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: newlist.length,
          );
        });
  }
}
