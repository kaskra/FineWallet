import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/formatted_strings.dart';
import 'package:FineWallet/src/widgets/standalone/indicator.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem(
      {Key key,
      @required this.transaction,
      @required this.onSelect,
      @required this.isSelected,
      @required this.isSelectionActive,
      this.userCurrencyId = 1})
      : super(key: key);

  final TransactionWithCategoryAndCurrency transaction;
  final Function(bool) onSelect;
  final bool isSelected;
  final bool isSelectionActive;
  final int userCurrencyId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DecoratedCard(
        color: isSelected ? const Color(0xFF6F6F6F) : null,
        elevation: Theme.of(context).cardTheme.elevation,
        padding: 0,
        child: Stack(
          children: [
            ClipPath(
              clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(cardRadius))),
              child: CustomPaint(
                foregroundPainter: IndicatorPainter(
                  color: transaction.tx.isExpense ? Colors.red : Colors.green,
                  thickness: 6,
                  side: transaction.tx.isExpense
                      ? IndicatorSide.right
                      : IndicatorSide.left,
                ),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  child: ListTile(
                    dense: true,
                    title: Text(
                      transaction.sub.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isSelected
                              ? Theme.of(context).colorScheme.secondary
                              : null),
                    ),
                    subtitle: Text(
                      transaction.sub.name,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: isSelected ? Colors.white : null,
                          fontSize: 13),
                    ),
                    trailing: _buildAmountText(context),
                    leading: _buildItemIcon(context),
                  ),
                ),
              ),
            ),
            _buildTappableLayer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTappableLayer() {
    return Positioned.fill(
        child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(cardRadius),
        onLongPress: () {
          if (onSelect != null) {
            onSelect(true);
          }
        },
        onTap: () {
          bool isSelect = false;
          if (isSelected) {
            isSelect = false;
          } else if (isSelectionActive) {
            isSelect = true;
          }
          if (onSelect != null) {
            onSelect(isSelect);
          }
        },
      ),
    ));
  }

  Widget _buildItemIcon(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Icon(
        isSelected
            ? Icons.check
            : CategoryIcon(transaction.sub.categoryId - 1).data,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }

  Widget _buildAmountText(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (transaction.tx.isRecurring)
          Icon(
            Icons.replay,
            color: Theme.of(context).colorScheme.secondary,
            size: 18,
          )
        else
          const SizedBox(),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AmountString(
              transaction.tx.amount * (transaction.tx.isExpense ? -1 : 1),
              textStyle: TextStyle(
                  fontSize: 16,
                  color: isSelected
                      ? Colors.white
                      : (transaction.tx.isExpense ? Colors.red : Colors.green),
                  fontWeight: FontWeight.bold),
            ),
            if (userCurrencyId != transaction.tx.currencyId)
              ForeignAmountString(
                transaction.tx.originalAmount *
                    (transaction.tx.isExpense ? -1 : 1),
                currencySymbol: transaction.currency.symbol,
                textStyle: TextStyle(
                    fontSize: 10,
                    color: isSelected
                        ? Colors.white
                        : (transaction.tx.isExpense
                            ? Colors.red
                            : Colors.green),
                    fontWeight: FontWeight.bold),
              )
          ],
        ),
      ],
    );
  }
}
