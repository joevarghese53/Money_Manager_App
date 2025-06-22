import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

import '../../models/category/categorymodel.dart';

const categorydbname = 'categorydbname';

abstract class Categoryfunctionsab {
  Future<List<Categorymodel>> getcategories();
  Future<void> insertcategory(Categorymodel value);
  Future<void> deletecategory(String categoryid);
}

class Categoryfunctions implements Categoryfunctionsab {
  Categoryfunctions._internal();
  static Categoryfunctions instance = Categoryfunctions._internal();

  factory Categoryfunctions() {
    final instance = Categoryfunctions._internal();
    instance._initializeDefaultCategories();
    return instance;
  }

  ValueNotifier<List<Categorymodel>> incomelistnotifier = ValueNotifier([]);
  ValueNotifier<List<Categorymodel>> expenselistnotifier = ValueNotifier([]);

  Future<void> _initializeDefaultCategories() async {
    final categorydbopen = await Hive.openBox<Categorymodel>(categorydbname);

    // Only add default categories if the database is empty
    if (categorydbopen.isEmpty) {
      // Default Income Categories
      final defaultIncomeCategories = [
        Categorymodel(
          id: 'income_salary',
          name: 'Salary',
          type: Categorytype.income,
        ),
        Categorymodel(
          id: 'income_freelance',
          name: 'Freelance',
          type: Categorytype.income,
        ),
        Categorymodel(
          id: 'income_business',
          name: 'Business',
          type: Categorytype.income,
        ),
        Categorymodel(
          id: 'income_investment',
          name: 'Investment',
          type: Categorytype.income,
        ),
        Categorymodel(
          id: 'income_other',
          name: 'Other Income',
          type: Categorytype.income,
        ),
      ];

      // Default Expense Categories
      final defaultExpenseCategories = [
        Categorymodel(
          id: 'expense_food',
          name: 'Food & Dining',
          type: Categorytype.expense,
        ),
        Categorymodel(
          id: 'expense_transport',
          name: 'Transportation',
          type: Categorytype.expense,
        ),
        Categorymodel(
          id: 'expense_shopping',
          name: 'Shopping',
          type: Categorytype.expense,
        ),
        Categorymodel(
          id: 'expense_bills',
          name: 'Bills & Utilities',
          type: Categorytype.expense,
        ),
        Categorymodel(
          id: 'expense_entertainment',
          name: 'Entertainment',
          type: Categorytype.expense,
        ),
        Categorymodel(
          id: 'expense_health',
          name: 'Healthcare',
          type: Categorytype.expense,
        ),
        Categorymodel(
          id: 'expense_education',
          name: 'Education',
          type: Categorytype.expense,
        ),
        Categorymodel(
          id: 'expense_other',
          name: 'Other Expenses',
          type: Categorytype.expense,
        ),
      ];

      // Add all default categories to the database
      for (final category in [
        ...defaultIncomeCategories,
        ...defaultExpenseCategories,
      ]) {
        await categorydbopen.put(category.id, category);
      }
    }

    // Refresh the UI to show the categories
    refreshui();
  }

  @override
  Future<void> insertcategory(Categorymodel value) async {
    final categorydbopen = await Hive.openBox<Categorymodel>(categorydbname);
    categorydbopen.put(value.id, value);
    refreshui();
  }

  @override
  Future<List<Categorymodel>> getcategories() async {
    final categorydbopen = await Hive.openBox<Categorymodel>(categorydbname);
    return categorydbopen.values.toList();
  }

  Future<void> refreshui() async {
    final allcategorylist = await getcategories();
    List<Categorymodel> incomeList = [];
    List<Categorymodel> expenseList = [];

    for (final category in allcategorylist) {
      if (category.type == Categorytype.income) {
        incomeList.add(category);
      } else {
        expenseList.add(category);
      }
    }

    incomelistnotifier.value = incomeList;
    expenselistnotifier.value = expenseList;
  }

  @override
  Future<void> deletecategory(String categoryid) async {
    final categorydbopen = await Hive.openBox<Categorymodel>(categorydbname);
    await categorydbopen.delete(categoryid);
    await refreshui();
  }
}
