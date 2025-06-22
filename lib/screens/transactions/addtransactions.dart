import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:money_manager_project/db/transactions/transactionsdb.dart';

import '../../db/category/categorydbfunctions.dart';
import '../../models/category/categorymodel.dart';
import '../../models/transactions/transcationmodel.dart';

class ScreenAddTransactions extends StatefulWidget {
  const ScreenAddTransactions({super.key});

  @override
  State<ScreenAddTransactions> createState() => _ScreenAddTransactionsState();
}

class _ScreenAddTransactionsState extends State<ScreenAddTransactions> {
  DateTime? _selecteddate;
  Categorytype? _selectedcategorytype;
  Categorymodel? _selectedcategorymodel;
  String? _dropdowncategoryID;

  final purposecontroller = TextEditingController();
  final amountcontroller = TextEditingController();

  @override
  void initState() {
    _selectedcategorytype = Categorytype.income;
    _selecteddate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Add Transaction'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: purposecontroller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Purpose',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: amountcontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: const Icon(Icons.monetization_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: () async {
                  final selecteddatetemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 30),
                    ),
                    lastDate: DateTime.now(),
                  );
                  if (selecteddatetemp != null && mounted) {
                    setState(() {
                      _selecteddate = selecteddatetemp;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _selecteddate == null
                      ? 'Select Date'
                      : DateFormat.yMMMd().format(_selecteddate!),
                  style: const TextStyle(fontSize: 16),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SegmentedButton<Categorytype>(
                segments: const [
                  ButtonSegment(
                    value: Categorytype.income,
                    label: Text('Income'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                  ButtonSegment(
                    value: Categorytype.expense,
                    label: Text('Expense'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                ],
                selected: {_selectedcategorytype!},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _selectedcategorytype = newSelection.first;
                    _dropdowncategoryID = null;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                hint: const Text('Select Category'),
                value: _dropdowncategoryID,
                items:
                    (_selectedcategorytype == Categorytype.income
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
                        })
                        .toList(),
                onChanged: (selectedvalue) {
                  setState(() {
                    _dropdowncategoryID = selectedvalue;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  addtransactions();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Submit', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addtransactions() async {
    final purposetext = purposecontroller.text;
    final amounttext = amountcontroller.text;
    if (purposetext.isEmpty) {
      return;
    }
    if (amounttext.isEmpty) {
      return;
    }
    if (_selectedcategorymodel == null) {
      return;
    }
    if (_selecteddate == null) {
      return;
    }
    final parsedamount = double.tryParse(amounttext);
    if (parsedamount == null) {
      return;
    }

    final model = Transactionmodel(
      purpose: purposetext,
      amount: parsedamount,
      date: _selecteddate!,
      type: _selectedcategorytype!,
      category: _selectedcategorymodel!,
    );
    await TransactionsFunctions.instance.inserttransactions(model);
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
