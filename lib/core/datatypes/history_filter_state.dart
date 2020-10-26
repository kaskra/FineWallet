class HistoryFilterState {
  bool onlyExpenses = true;
  bool onlyIncomes = true;
  bool showFuture = false;

  @override
  String toString() {
    return 'HistoryFilterState{'
        'onlyExpenses: $onlyExpenses, '
        'onlyIncomes: $onlyIncomes, '
        'showFuture: $showFuture '
        '}';
  }
}
