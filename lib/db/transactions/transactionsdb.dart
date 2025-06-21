import 'package:flutter/foundation.dart';

import 'package:hive_flutter/adapters.dart';

import '../../models/transactions/transcationmodel.dart';

const transactionsdbname = 'transactiondbname';

abstract class transactionsfunctionsab {
  Future<void> inserttransactions(Transactionmodel value);
  Future<List<Transactionmodel>> gettransactions();
  Future<void> deletetransaction(String id);
}

class transactionsfunctions implements transactionsfunctionsab {
  transactionsfunctions._internal();
  static transactionsfunctions instance = transactionsfunctions._internal();

  factory transactionsfunctions() {
    return instance;
  }

  ValueNotifier<List<Transactionmodel>> transactionlistnotifier = ValueNotifier(
    [],
  );

  @override
  Future<void> inserttransactions(Transactionmodel obj) async {
    final transactionsdbopen = await Hive.openBox<Transactionmodel>(
      transactionsdbname,
    );
    await transactionsdbopen.put(obj.id, obj);
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
  }

  @override
  Future<void> deletetransaction(String id) async {
    final transactionsdbopen = await Hive.openBox<Transactionmodel>(
      transactionsdbname,
    );
    await transactionsdbopen.delete(id);
    refreshI();
  }
}
