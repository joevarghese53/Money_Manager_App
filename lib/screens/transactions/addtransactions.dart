import 'package:flutter/material.dart';

import 'package:money_manager_project/db/transactions/transactionsdb.dart';

import '../../db/category/categorydbfunctions.dart';
import '../../models/category/categorymodel.dart';
import '../../models/transactions/transcationmodel.dart';

class screenaddtransactions extends StatefulWidget {
  const screenaddtransactions({super.key});

  @override
  State<screenaddtransactions> createState() => _screenaddtransactionsState();
}

class _screenaddtransactionsState extends State<screenaddtransactions> {
  DateTime? _selecteddate;
  Categorytype? _selectedcategorytype;
  Categorymodel? _selectedcategorymodel;
  String? _dropdowncategoryID;

  final purposecontroller = TextEditingController();
  final amountcontroller = TextEditingController();

  @override
  void initState() {
    _selectedcategorytype = Categorytype.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          //purpose
          children: [
            TextFormField(
              controller: purposecontroller,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(hintText: 'Purpose'),
            ),

            //amount
            TextFormField(
              controller: amountcontroller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Amount'),
            ),

            TextButton.icon(
                onPressed: () async {
                  final _selecteddatetemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (_selecteddatetemp == null) {
                    return;
                  } else {
                    setState(() {
                      _selecteddate = _selecteddatetemp;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_month),
                label: Text(_selecteddate == null
                    ? 'Select Date'
                    : _selecteddate.toString())),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                        value: Categorytype.income,
                        groupValue: _selectedcategorytype,
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          } else {
                            setState(() {
                              _selectedcategorytype = value;
                              _dropdowncategoryID = null;
                            });
                          }
                        }),
                    const Text('Income'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: Categorytype.expense,
                        groupValue: _selectedcategorytype,
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          } else {
                            setState(() {
                              _selectedcategorytype = value;
                              _dropdowncategoryID = null;
                            });
                          }
                        }),
                    const Text('Expense'),
                  ],
                )
              ],
            ),

            DropdownButton(
                hint: const Text('Select Category'),
                value: _dropdowncategoryID,
                items: (_selectedcategorytype == Categorytype.income
                        ? Categoryfunctions.instance.incomelistnotifier
                        : Categoryfunctions.instance.expenselistnotifier)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                    onTap: () {
                      _selectedcategorymodel = e;
                    },
                  );
                }).toList(),
                onChanged: (selectedvalue) {
                  setState(() {
                    _dropdowncategoryID = selectedvalue;
                  });
                }),
            ElevatedButton(
                onPressed: () {
                  addtransactions();
                },
                child: const Text('Submit'))
          ],
        ),
      )),
    );
  }

  Future<void> addtransactions() async {
    final _purposetext = purposecontroller.text;
    final _amounttext = amountcontroller.text;
    if (_purposetext.isEmpty) {
      return;
    }
    if (_amounttext.isEmpty) {
      return;
    }
    if (_selectedcategorymodel == null) {
      return;
    }
    if (_selecteddate == null) {
      return;
    }
    final _parsedamount = double.tryParse(_amounttext);
    if (_parsedamount == null) {
      return;
    }

    final model = Transactionmodel(
      purpose: _purposetext,
      amount: _parsedamount,
      date: _selecteddate!,
      type: _selectedcategorytype!,
      category: _selectedcategorymodel!,
    );
    await transactionsfunctions.instance.inserttransactions(model);
    Navigator.of(context).pop();
    transactionsfunctions.instance.refreshI();
  }
}
