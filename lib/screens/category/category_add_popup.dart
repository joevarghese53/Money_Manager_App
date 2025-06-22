import 'dart:async';

import 'package:flutter/material.dart';

import '../../db/category/categorydbfunctions.dart';
import '../../models/category/categorymodel.dart';

ValueNotifier<Categorytype> selectedvaluenotifier = ValueNotifier(
  Categorytype.income,
);

Future<void> showcategoryaddpopup(context) async {
  final nameeditingcontroller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Add Category'),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: nameeditingcontroller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Add Something',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Radiobuttonwidget(title: 'Income', type: Categorytype.income),
                Radiobuttonwidget(title: 'Expense', type: Categorytype.expense),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                final name = nameeditingcontroller.text;
                if (name.isEmpty) {
                  return;
                }
                final type = selectedvaluenotifier.value;
                final category = Categorymodel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  type: type,
                );
                Categoryfunctions.instance.insertcategory(category);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ),
        ],
      );
    },
  );
}

class Radiobuttonwidget extends StatelessWidget {
  const Radiobuttonwidget({super.key, required this.title, required this.type});

  final String title;
  final Categorytype type;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedvaluenotifier,
          builder: (context, newvalue, _) {
            return Radio(
              value: type,
              groupValue: newvalue,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                selectedvaluenotifier.value = value;
              },
            );
          },
        ),
        Text(title),
      ],
    );
  }
}
