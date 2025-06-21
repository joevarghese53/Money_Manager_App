import 'dart:async';

import 'package:flutter/material.dart';

import '../../db/category/categorydbfunctions.dart';
import '../../models/category/categorymodel.dart';

ValueNotifier<Categorytype> selectedvaluenotifier = ValueNotifier(
  Categorytype.income,
);

Future<void> showcategoryaddpopup(context) async {
  final _nameeditingcontroller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: const Text('Add Category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameeditingcontroller,
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
                final _name = _nameeditingcontroller.text;
                if (_name.isEmpty) {
                  return;
                }
                final _type = selectedvaluenotifier.value;
                final _category = Categorymodel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _name,
                  type: _type,
                );
                Categoryfunctions.instance.insertcategory(_category);
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
