/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:19:42 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

class CategoryExpenses {
  final double amount;
  final int categoryId;
  final String categoryName;

  CategoryExpenses(this.amount, this.categoryId, this.categoryName);
}

class PredictionPoint {
  final int timestamp;
  final double amount;
  final bool isPrediction;
  final bool isAboveMax;
  PredictionPoint(
      this.timestamp, this.amount, this.isPrediction, this.isAboveMax);
}

class PredictionPointDate {
  final DateTime timestamp;
  final double amount;
  final bool isPrediction;
  final bool isAboveMax;
  PredictionPointDate(
      this.timestamp, this.amount, this.isPrediction, this.isAboveMax);
}
