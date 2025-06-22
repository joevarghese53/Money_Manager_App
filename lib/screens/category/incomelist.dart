import 'package:flutter/material.dart';

import '../../db/category/categorydbfunctions.dart';

class Incomelist extends StatelessWidget {
  const Incomelist({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Categoryfunctions.instance.incomelistnotifier,
      builder: (context, newlist, _) {
        return ListView.separated(
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, index) {
            final category = newlist[index];
            return Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  onPressed: () {
                    Categoryfunctions.instance.deletecategory(category.id);
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10);
          },
          itemCount: newlist.length,
        );
      },
    );
  }
}
