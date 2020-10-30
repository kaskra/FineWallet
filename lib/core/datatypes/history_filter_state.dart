class HistoryFilterState {
  final bool onlyExpenses;
  final bool onlyIncomes;
  final bool showFuture;
  final bool showRecurrent;
  final String label;

  HistoryFilterState({
    this.onlyExpenses = true,
    this.onlyIncomes = true,
    this.showFuture = false,
    this.showRecurrent = false,
    this.label = "",
  });

  @override
  String toString() {
    return 'HistoryFilterState{onlyExpenses: $onlyExpenses, '
        'onlyIncomes: $onlyIncomes, '
        'showFuture: $showFuture, '
        'showRecurrent: $showRecurrent, '
        'label: $label}';
  }

  HistoryFilterState copyWith(
      {bool onlyExpenses,
      bool onlyIncomes,
      bool showFuture,
      bool showRecurrent,
      String label}) {
    return HistoryFilterState(
      onlyExpenses: onlyExpenses ?? this.onlyExpenses,
      onlyIncomes: onlyIncomes ?? this.onlyIncomes,
      showFuture: showFuture ?? this.showFuture,
      showRecurrent: showRecurrent ?? this.showRecurrent,
      label: label ?? this.label,
    );
  }
}
