import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_project/db/transactions/transactionsdb.dart';

import '../../db/category/categorydbfunctions.dart';
import '../../models/category/categorymodel.dart';
import '../../models/transactions/transcationmodel.dart';
import 'edittransaction.dart';

class Transactionscreen extends StatelessWidget {
  const Transactionscreen({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionsFunctions.instance.refreshI();

    Categoryfunctions.instance.refreshui();

    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: TransactionsFunctions.instance.totalnotifier,
          builder: (context, total, _) {
            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Balance',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '₹ ${total.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.south_west_rounded,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 8),
                          ValueListenableBuilder(
                            valueListenable:
                                TransactionsFunctions.instance.incomenotifier,
                            builder: (context, income, _) {
                              return Row(
                                children: [
                                  Text(
                                    '₹${income.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Income',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.north_east_rounded,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 8),
                          ValueListenableBuilder(
                            valueListenable:
                                TransactionsFunctions.instance.expensenotifier,
                            builder: (context, expense, _) {
                              return Row(
                                children: [
                                  Text(
                                    '₹${expense.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Expenses',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable:
                TransactionsFunctions.instance.transactionlistnotifier,
            builder:
                (
                  BuildContext context,
                  List<Transactionmodel> newlist,
                  Widget? _,
                ) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (context, index) {
                      final value = newlist[index];
                      return Slidable(
                        key: Key(value.id!),
                        startActionPane: ActionPane(
                          motion: const BehindMotion(),
                          extentRatio: 0.4,
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                TransactionsFunctions.instance
                                    .deletetransaction(value.id!);
                              },
                              icon: Icons.delete,
                              label: 'Delete',
                              backgroundColor: Colors.red[400]!,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ScreenEditTransaction(
                                      transaction: value,
                                    ),
                                  ),
                                );
                              },
                              icon: Icons.edit,
                              label: 'Edit',
                              backgroundColor: Colors.blue[400]!,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 1,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 16,
                            ),
                            leading: CircleAvatar(
                              radius: 22,
                              backgroundColor: value.type == Categorytype.income
                                  ? Colors.green[200]
                                  : Colors.red[200],
                              child: Icon(
                                value.type == Categorytype.income
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: value.type == Categorytype.income
                                    ? Colors.green[800]
                                    : Colors.red[800],
                                size: 20,
                              ),
                            ),
                            title: Text(
                              '₹ ${value.amount}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(value.category.name),
                            trailing: Text(
                              parsedate(value.date),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
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
          ),
        ),
      ],
    );
  }

  String parsedate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }
}
