import 'package:flutter/foundation.dart';

import 'package:hive_flutter/adapters.dart';

import '../../models/transactions/transcationmodel.dart';

const transactionsdbname = 'transactiondbname';

abstract class TransactionsFunctionsAb {
  Future<void> inserttransactions(Transactionmodel value);
  Future<List<Transactionmodel>> gettransactions();
  Future<void> deletetransaction(String id);
}

class TransactionsFunctions implements TransactionsFunctionsAb {
  TransactionsFunctions._internal();
  static TransactionsFunctions instance = TransactionsFunctions._internal();

  factory TransactionsFunctions() {
    return instance;
  }

  ValueNotifier<List<Transactionmodel>> transactionlistnotifier = ValueNotifier(
    [],
  );
  ValueNotifier<double> incomenotifier = ValueNotifier(0);
  ValueNotifier<double> expensenotifier = ValueNotifier(0);
  ValueNotifier<double> totalnotifier = ValueNotifier(0);

  @override
  Future<void> inserttransactions(Transactionmodel obj) async {
    final transactionsdbopen = await Hive.openBox<Transactionmodel>(
      transactionsdbname,
    );
    await transactionsdbopen.put(obj.id, obj);
    refreshI();
  }

  @override
  Future<List<Transactionmodel>> gettransactions() async {
    final transactionsdbopen = await Hive.openBox<Transactionmodel>(
      transactionsdbname,
    );
    return transactionsdbopen.values.toList();
  }

  Future<void> refreshI() async {
    final transactionslist = await gettransactions();
    transactionslist.sort((first, second) => second.date.compareTo(first.date));
    transactionlistnotifier.value = List.from(transactionslist);
    incomeandexpense();
  }

  @override
  Future<void> deletetransaction(String id) async {
    final transactionsdbopen = await Hive.openBox<Transactionmodel>(
      transactionsdbname,
    );
    await transactionsdbopen.delete(id);
    refreshI();
  }

  Future<void> incomeandexpense() async {
    incomenotifier.value = 0;
    expensenotifier.value = 0;
    totalnotifier.value = 0;
    final list = await gettransactions();
    for (var i = 0; i < list.length; i++) {
      if (list[i].type.name == 'income') {
        incomenotifier.value += list[i].amount;
      } else {
        expensenotifier.value += list[i].amount;
      }
    }
    totalnotifier.value = incomenotifier.value - expensenotifier.value;
  }
}
