import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/src/add_page/add_page.dart';
import 'package:FineWallet/src/history_page/history_date_title.dart';
import 'package:FineWallet/src/history_page/history_item.dart';
import 'package:FineWallet/src/history_page/history_month_divider.dart';
import 'package:FineWallet/src/widgets/general_widgets.dart';
import 'package:FineWallet/src/widgets/selection_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  const HistoryPage({
    Key key,
    this.filterSettings,
    @required this.onChangeSelectionMode,
  }) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  TransactionFilterSettings _filterSettings;
  Map<int, TransactionsWithCategory> _selectedItems = new Map();
  bool _isSelectionActive = false;

  @override
  void initState() {
    _filterSettings = widget.filterSettings;
    if (widget.filterSettings == null) {
      _filterSettings = TransactionFilterSettings.beforeDate(DateTime.now());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          _isSelectionActive ? _buildSelectionAppBar() : Container(),
          Expanded(
            child: Container(
              child: MediaQuery.removePadding(
                context: context,
                child: _buildHistoryList(),
                removeTop: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionAppBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SelectionAppBar(
        title: "FineWallet",
        selectedItems: _selectedItems,
        onClose: () => _closeSelection(),
        onEdit: () => _editItem(_selectedItems.values.first),
        onDelete: () => _deleteItems(),
      ),
    );
  }

  Widget _buildHistoryList() {
    return StreamBuilder<List<TransactionsWithCategory>>(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchTransactionsWithFilter(_filterSettings),
      builder: (BuildContext context,
          AsyncSnapshot<List<TransactionsWithCategory>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return _buildItems(snapshot.data);
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  /// Returns a [ListView] containing every queried [TransactionsWithCategory].
  ///
  /// Before every new date in the list, a [HistoryDateTitle] is added to
  /// show to which date the following [HistoryItem]s belong.
  ///
  /// When the month between two transactions changes, an additional
  /// item [HistoryMonthDivider] is added to visually divide the transactions.
  ///
  /// Input
  /// -----
  /// List of [TransactionsWithCategory] to display.
  ///
  /// Return
  /// -----
  /// [ListView] containing [HistoryItem], [HistoryMonthDivider]
  /// and [HistoryDateTitle].
  ///
  Widget _buildItems(List<TransactionsWithCategory> data) {
    List<Widget> items = [];

    DateTime lastDate = DateTime.fromMillisecondsSinceEpoch(data.first.date);
    items.add(HistoryDateTitle(date: lastDate));
    for (var d in data) {
      var date = DateTime.fromMillisecondsSinceEpoch(d.date);

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
      children: items,
      shrinkWrap: true,
    );
  }

  /// Returns the [HistoryItem] for a specific [TransactionsWithCategory]
  /// that is passed in.
  ///
  /// Input
  /// -----
  /// [TransactionsWithCategory] to display in history.
  ///
  /// Return
  /// ------
  /// [HistoryItem] with transaction information.
  ///
  Widget _buildItem(TransactionsWithCategory d) {
    return HistoryItem(
      key: new Key(d.hashCode.toString()),
      transaction: d,
      isSelected: _selectedItems.containsKey(d.originalId),
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
  /// - [TransactionsWithCategory] which is displayed on the item.
  ///
  void _toggleSelectionMode(bool selected, TransactionsWithCategory data) {
    if (selected) {
      if (!_selectedItems.containsKey(data.originalId)) {
        _selectedItems.putIfAbsent(data.originalId, () => data);
        _isSelectionActive = true;
      }
    } else {
      _selectedItems.remove(data.originalId);
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
  void _checkSelectionMode() async {
    if (widget.onChangeSelectionMode != null) {
      widget.onChangeSelectionMode(_isSelectionActive);
    }
  }

  /// Deletes the selected items from database. Close selection mode afterwards.
  ///
  /// Before deleting the transaction, a confirm dialog will show,
  /// requiring the user to authorize the deletion.
  ///
  void _deleteItems() async {
    if (await showConfirmDialog(
        context, "Delete transaction?", "This will delete the transaction.")) {
      for (TransactionsWithCategory tx in _selectedItems.values) {
        Provider.of<AppDatabase>(context)
            .transactionDao
            .deleteTransactionById(tx.originalId);
      }
      _closeSelection();
    }
  }

  /// Edit an item on the add page. Close selection mode afterwards.
  ///
  void _editItem(TransactionsWithCategory tx) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddPage(isExpense: tx.isExpense, transaction: tx)));
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
