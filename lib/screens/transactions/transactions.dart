import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_project/db/transactions/transactionsdb.dart';

import '../../db/category/categorydbfunctions.dart';
import '../../models/category/categorymodel.dart';
import '../../models/transactions/transcationmodel.dart';

class Transactionscreen extends StatelessWidget {
  const Transactionscreen({super.key});

  @override
  Widget build(BuildContext context) {
    transactionsfunctions.instance.refreshI();

    Categoryfunctions.instance.refreshui();

    return ValueListenableBuilder(
        valueListenable: transactionsfunctions.instance.transactionlistnotifier,
        builder:
            (BuildContext context, List<Transactionmodel> newlist, Widget? _) {
          return ListView.separated(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (context, index) {
                final _value = newlist[index];
                return Slidable(
                  key: Key(_value.id!),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          transactionsfunctions.instance
                              .deletetransaction(_value.id!);
                        },
                        icon: Icons.delete,
                        label: 'delete',
                      )
                    ],
                  ),
                  child: Card(
                    elevation: 1,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Text(
                          parsedate(_value.date),
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: _value.type == Categorytype.income
                            ? Colors.green
                            : Colors.red,
                      ),
                      title: Text('RS.${_value.amount}'),
                      subtitle: Text(_value.category.name),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: newlist.length);
        });
  }

  String parsedate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _spliteddate = _date.split(' ');
    return '${_spliteddate.last}\n${_spliteddate.first}';
  }
}
