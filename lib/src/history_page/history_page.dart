import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/core/datatypes/history_filter_state.dart';
import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/logger.dart';
import 'package:FineWallet/src/add_page/page.dart';
import 'package:FineWallet/src/widgets/widgets.dart';
import 'package:FineWallet/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'history_date_title.dart';
part 'history_filter.dart';
part 'history_item.dart';
part 'history_month_divider.dart';

/// This class is used to create a page which shows all recorded transactions.
///
/// By passing in a [TransactionFilterSettings] the user can decide
/// which transactions to see.
///
/// By default every recorded transaction up to the current day is shown.
///
class HistoryPage extends StatefulWidget {
  final TransactionFilterSettings filterSettings;
  final void Function(bool) onChangeSelectionMode;
  final bool showFilters;

  const HistoryPage({
    Key key,
    this.filterSettings,
    this.showFilters = false,
    @required this.onChangeSelectionMode,
  }) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  TransactionFilterSettings _filterSettings;
  final Map<int, TransactionWithCategoryAndCurrency> _selectedItems =
      <int, TransactionWithCategoryAndCurrency>{};
  bool _isSelectionActive = false;

  /// The history filter state that holds every filter setting.
  ///
  /// Used to synchronize between the different setting rows.
  HistoryFilterState _filterState = HistoryFilterState();

  final showExpenseKey = GlobalKey<HistoryFilterSwitchItemState>();
  final showIncomeKey = GlobalKey<HistoryFilterSwitchItemState>();
  final showFutureKey = GlobalKey<HistoryFilterSwitchItemState>();

  /// The currency id of the user's home currency.
  int _userCurrencyId = 1;

  Future loadUserCurrency() async {
    _userCurrencyId = (await Provider.of<AppDatabase>(context, listen: false)
            .currencyDao
            .getUserCurrency())
        ?.id;
  }

  @override
  void initState() {
    loadUserCurrency();
    setState(() {
      _filterSettings = widget.filterSettings;
      if (widget.filterSettings == null) {
        _filterState = UserSettings.getDefaultFilterSettings();
        _handleFilterSettings();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          if (_isSelectionActive) _buildSelectionAppBar() else Container(),
          if (widget.showFilters ?? true)
            _buildFilterSettingsRow()
          else
            Container(),
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: _buildHistoryList(),
            ),
          ),
        ],
      ),
    );
  }

  Future _buildModalSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(cardRadius),
          topLeft: Radius.circular(cardRadius),
        ),
      ),
      builder: (context) {
        final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
        return Material(
          borderRadius: BorderRadius.circular(cardRadius),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: HistoryFilterTextField(
                  iconData: Icons.search,
                  initialData: _filterState.label,
                  onChanged: (text) {
                    setState(() {
                      _filterState = _filterState.copyWith(label: text);
                    });
                    _handleFilterSettings();
                  },
                ),
              ),
              if (!isKeyboardOpen) const Divider(),
              if (!isKeyboardOpen)
                HistoryFilterSwitchItem(
                  key: showExpenseKey,
                  initialValue: _filterState.onlyExpenses,
                  title: LocaleKeys.history_page_show_expenses.tr(),
                  enabled: !_filterState.showRecurrent,
                  onChanged: (b) {
                    setState(() {
                      _filterState = _filterState.copyWith(onlyExpenses: b);
                    });
                    _handleFilterSettings();
                  },
                ),
              if (!isKeyboardOpen)
                HistoryFilterSwitchItem(
                  key: showIncomeKey,
                  initialValue: _filterState.onlyIncomes,
                  title: LocaleKeys.history_page_show_incomes.tr(),
                  enabled: !_filterState.showRecurrent,
                  onChanged: (b) {
                    setState(() {
                      _filterState = _filterState.copyWith(onlyIncomes: b);
                    });
                    _handleFilterSettings();
                  },
                ),
              if (!isKeyboardOpen)
                HistoryFilterSwitchItem(
                  key: showFutureKey,
                  initialValue: _filterState.showFuture,
                  title: LocaleKeys.history_page_show_future.tr(),
                  enabled: !_filterState.showRecurrent,
                  onChanged: (b) {
                    setState(() {
                      _filterState = _filterState.copyWith(showFuture: b);
                    });
                    _handleFilterSettings();
                  },
                ),
              if (!isKeyboardOpen)
                HistoryFilterCheckboxItem(
                  initialValue: _filterState.showRecurrent,
                  title: LocaleKeys.history_page_show_recurrent.tr(),
                  onChanged: (b) {
                    setState(() {
                      _filterState = _filterState.copyWith(showRecurrent: b);
                    });
                    _toggleSwitches(value: !b);
                    _handleFilterSettings();
                  },
                ),
              const SizedBox(height: 8)
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSettingsRow() {
    return HistoryFilter(
      onTap: () {
        _buildModalSheet();
      },
    );
  }

  void _toggleSwitches({bool value}) {
    showExpenseKey.currentState.setEnabled(value: value);
    showIncomeKey.currentState.setEnabled(value: value);
    showFutureKey.currentState.setEnabled(value: value);
  }

  void _handleFilterSettings() {
    setState(() {
      _filterSettings = TransactionFilterSettings.beforeDate(today());
    });
    if (widget.showFilters) {
      _filterSettings = TransactionFilterSettings();

      if (_filterState.showRecurrent) {
        _filterSettings = _filterSettings.copyWith(onlyRecurrences: true);
        return;
      }

      if (!_filterState.showFuture) {
        _filterSettings = _filterSettings.copyWith(before: today());
      }

      if (_filterState.onlyExpenses && _filterState.onlyIncomes) {
        return;
      }

      _filterSettings = _filterSettings.copyWith(
          incomes: _filterState.onlyIncomes,
          expenses: _filterState.onlyExpenses);
    }
  }

  Widget _buildSelectionAppBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SelectionAppBar<TransactionWithCategoryAndCurrency>(
        title: "FineWallet",
        selectedItems: _selectedItems,
        onClose: () => _closeSelection(),
        onEdit: () => _editItem(_selectedItems.values.first),
        onDelete: () => _deleteItems(),
        onShare: () => _shareItem(_selectedItems.values.first),
      ),
    );
  }

  Widget _buildHistoryList() {
    return StreamBuilder<List<TransactionWithCategoryAndCurrency>>(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchTransactionsWithFilter(_filterSettings),
      builder: (BuildContext context,
          AsyncSnapshot<List<TransactionWithCategoryAndCurrency>> snapshot) {
        if (snapshot.hasData) {
          final foundTransactions = snapshot.data
              .where((element) => element.tx.label
                  .contains(RegExp(_filterState.label, caseSensitive: false)))
              .toList();
          if (foundTransactions.isNotEmpty) {
            return _buildItems(foundTransactions);
          } else {
            return SizedBox(
                child:
                    Center(child: Text(LocaleKeys.found_no_transactions.tr())));
          }
        } else {
          return SizedBox(
              child:
                  Center(child: Text(LocaleKeys.found_no_transactions.tr())));
        }
      },
    );
  }

  /// Returns a [ListView] containing every queried [TransactionWithCategoryAndCurrency].
  ///
  /// Before every new date in the list, a [HistoryDateTitle] is added to
  /// show to which date the following [HistoryItem]s belong.
  ///
  /// When the month between two transactions changes, an additional
  /// item [HistoryMonthDivider] is added to visually divide the transactions.
  ///
  /// Input
  /// -----
  /// List of [TransactionWithCategoryAndCurrency] to display.
  ///
  /// Return
  /// -----
  /// [ListView] containing [HistoryItem], [HistoryMonthDivider]
  /// and [HistoryDateTitle].
  ///
  Widget _buildItems(List<TransactionWithCategoryAndCurrency> data) {
    final items = <Widget>[];

    DateTime lastDate = data.first.tx.date;
    items.add(HistoryDateTitle(date: lastDate));
    for (final d in data) {
      final date = d.tx.date;

      // Visually divide transactions when the month changes.
      if (date.month != lastDate.month) {
        items.add(HistoryMonthDivider());
      }

      // Add a date string to indicate to which day the transactions belong.
      if (date != lastDate) {
        items.add(HistoryDateTitle(date: date));
      }

      items.add(_buildItem(d));
      lastDate = date;
    }

    return ListView(
      shrinkWrap: true,
      children: items,
    );
  }

  /// Returns the [HistoryItem] for a specific [TransactionWithCategoryAndCurrency]
  /// that is passed in.
  ///
  /// Input
  /// -----
  /// [TransactionWithCategoryAndCurrency] to display in history.
  ///
  /// Return
  /// ------
  /// [HistoryItem] with transaction information.
  ///
  Widget _buildItem(TransactionWithCategoryAndCurrency d) {
    return HistoryItem(
      key: Key(d.hashCode.toString()),
      transaction: d,
      userCurrencyId: _userCurrencyId,
      isSelected: _selectedItems.containsKey(d.tx.originalId),
      isSelectionActive: _isSelectionActive,
      onSelect: (selected) {
        _toggleSelectionMode(selected, d);
        _checkSelectionMode();
      },
    );
  }

  /// Toggles between selection ON and OFF. When ON, the main appbar is
  /// replaced by the [SelectionAppBar], which shows how many items
  /// are selected and provides actions to apply to the selected items.
  ///
  /// The selected items are identified by the `originalId` of
  /// their transaction. By using this id, every recurring transaction of
  /// an original transaction is selected once a single one is selected.
  ///
  /// Input
  /// -----
  /// - [bool] received from a item.
  /// - [TransactionWithCategoryAndCurrency] which is displayed on the item.
  ///
  void _toggleSelectionMode(
      bool selected, TransactionWithCategoryAndCurrency data) {
    if (selected) {
      if (!_selectedItems.containsKey(data.tx.originalId)) {
        _selectedItems.putIfAbsent(data.tx.originalId, () => data);
        _isSelectionActive = true;
      }
    } else {
      _selectedItems.remove(data.tx.originalId);
      if (_selectedItems.isEmpty) {
        _isSelectionActive = false;
      }
    }
  }

  /// Executes the passed function when the selection mode changes.
  ///
  /// The selection mode gets activated when some history item is pressed for a longer time.
  /// In selection mode the displayed app bar changes to the selection app bar.
  ///
  Future _checkSelectionMode() async {
    if (widget.onChangeSelectionMode != null) {
      widget.onChangeSelectionMode(_isSelectionActive);
    }
  }

  /// Deletes the selected items from database. Close selection mode afterwards.
  ///
  /// Before deleting the transaction, a confirm dialog will show,
  /// requiring the user to authorize the deletion.
  ///
  Future _deleteItems() async {
    if (await showConfirmDialog(
      context,
      LocaleKeys.delete_dialog_title.tr(),
      LocaleKeys.delete_dialog_text.tr(),
    )) {
      for (final tx in _selectedItems.values) {
        Provider.of<AppDatabase>(context, listen: false)
            .transactionDao
            .deleteTransactionById(tx.tx.originalId);
      }
      _closeSelection();
    }
  }

  /// Edit an item on the add page. Close selection mode afterwards.
  ///
  void _editItem(TransactionWithCategoryAndCurrency tx) {
    logMsg(tx.toString());
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddPage(isExpense: tx.tx.isExpense, transaction: tx)));
    _closeSelection();
  }

  /// Shares an item using TX SHARE. Closes selection mode afterwards.
  ///
  void _shareItem(TransactionWithCategoryAndCurrency tx) {
    showConfirmDialog(
      context,
      LocaleKeys.history_page_share_title.tr(),
      LocaleKeys.history_page_share_text.tr(),
    );
    _closeSelection();
  }

  /// Closes selection mode and clears the selected items list.
  ///
  void _closeSelection() {
    setState(() {
      _selectedItems.clear();
      _isSelectionActive = false;
    });
    _checkSelectionMode();
  }
}
