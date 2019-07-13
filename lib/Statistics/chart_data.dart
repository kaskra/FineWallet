/*
 * Developed by Lukas Krauch 10.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

class DataPoint {
  final int timeStamp;
  final double expense;
  final double income;
  DataPoint(this.timeStamp, this.expense, this.income);
}

class CategoryExpenses {
  final double amount;
  final int categoryId;
  final String categoryName;

  CategoryExpenses(this.amount, this.categoryId, this.categoryName);
}
