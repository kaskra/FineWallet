import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/src/settings_page/settings_page.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddPageRework extends StatefulWidget {
  AddPageRework({
    Key key,
    @required this.isExpense,
    this.transaction,
  }) : super(key: key);

  final bool isExpense;
  final TransactionsWithCategory transaction;

  @override
  _AddPageReworkState createState() => _AddPageReworkState();
}

class _AddPageReworkState extends State<AddPageRework> {
  bool _editing = false;
  TransactionsWithCategory _transaction;

  double _amount = 0.00;
  int _date = dayInMillis(DateTime.now());
  int _subcategoryId = -1;
  String _subcategoryName = "";
  bool _isRecurring = false;

  @override
  void initState() {
    if (widget.transaction != null) {
      _transaction = widget.transaction;
      _editing = true;
      _amount = _transaction.amount;
      _date = _transaction.date;
      _subcategoryId = _transaction.subcategoryId;
      _subcategoryName = _transaction.subcategoryName;
      _isRecurring = _transaction.isRecurring;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add ${widget.isExpense ? "Expense" : "Income"}',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        iconTheme: Theme.of(context).iconTheme,
        // TODO Remove after testing
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => print("Pressed!"),
        tooltip: 'Save transaction',
        label: Text(
          "SAVE",
          style: TextStyle(
              fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
        ), //Change Icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, //Change for different locations
      body: Center(
        child: Container(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    List<Widget> items = []
      ..addAll(_buildAmountRow())
      ..addAll(_buildCategoryRow())
      ..addAll(_buildDateRow())
      ..addAll(_buildRecurrenceRow());

    if (_isRecurring) {
      items.addAll(_buildRecurrenceChoices());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  List<Widget> _buildAmountRow() {
    return [
      Padding(
          padding: const EdgeInsets.only(top: 8),
          child: _buildRowTitle("Amount")),
      _RowWrapper(
        text: _amount.toStringAsFixed(2) +
            Provider.of<LocalizationNotifier>(context).currency,
        iconSize: 24,
        leadingIcon: Icons.attach_money,
        isExpandable: false,
        onTap: () {
          print("Tapped AMOUNT!");
        },
      )
    ];
  }

  List<Widget> _buildCategoryRow() {
    return [
      _buildRowTitle("Category"),
      _RowWrapper(
        text: _subcategoryName ?? "",
        iconSize: 24,
        leadingIcon: Icons.category,
        isExpandable: false,
        onTap: () {
          print("Tapped CATEGORY!");
        },
      ),
    ];
  }

  List<Widget> _buildDateRow() {
    var formatter = new DateFormat('dd.MM.yy');
    String formattedDate =
        formatter.format(DateTime.fromMillisecondsSinceEpoch(_date));
    return [
      _buildRowTitle("Date"),
      _RowWrapper(
        text: formattedDate,
        iconSize: 24,
        leadingIcon: Icons.calendar_today,
        isExpandable: false,
        onTap: () {
          print("Tapped CALENDAR!");
        },
      ),
    ];
  }

  List<Widget> _buildRecurrenceRow() {
    return [
      _buildRowTitle("Recurrence"),
      _RowWrapper(
        iconSize: 24,
        leadingIcon: Icons.replay,
        isExpandable: true,
        isExpanded: _isRecurring,
        onSwitch: (val) {
          print("Switch to $val");
          setState(() {
            _isRecurring = val;
          });
        },
      ),
    ];
  }

  List<Widget> _buildRecurrenceChoices() {
    return [];
  }

  Widget _buildRowTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 48),
      child: Text(
        title,
        style: TextStyle(fontSize: 13),
      ),
    );
  }
}

/// This class is used to have recurring theme of column rows
/// of the add page.
class _RowWrapper extends StatelessWidget {
  final double _iconPadding = 8;

  final IconData leadingIcon;
  final bool isExpandable;
  final double iconSize;
  final String placeholderText;
  final bool isExpanded;
  final Function onTap;
  final Function(bool) onSwitch;

  final String text;

  const _RowWrapper({
    Key key,
    this.text,
    this.leadingIcon,
    this.isExpandable,
    this.iconSize,
    this.placeholderText,
    this.isExpanded,
    this.onTap,
    this.onSwitch,
  })  : assert(leadingIcon != null),
        assert(isExpandable != null),
        assert(iconSize != null),
        assert(isExpandable ? isExpanded != null : true),
        assert(!isExpandable ? onTap != null : true),
        assert(isExpandable ? onSwitch != null : true),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: <Widget>[
          _buildLeading(context),
          isExpandable ? _buildExpandableSwitch() : _buildMainContent(),
        ],
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    return SizedBox(
      width: iconSize + _iconPadding,
      height: iconSize + _iconPadding,
      child: Icon(
        leadingIcon,
        size: iconSize,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }

  Widget _buildMainContent() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: iconSize + _iconPadding,
        child: InkWell(
          onTap: () => onTap(),
          child: Container(
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 2, color: Colors.black54)),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  text,
                  style: TextStyle(fontSize: 16),
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildExpandableSwitch() {
    return Expanded(
      child: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: iconSize + _iconPadding,
        child: Switch.adaptive(
          value: true,
          onChanged: (val) => onSwitch(val),
        ),
      ),
    );
  }
}
