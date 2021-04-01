part of 'history_page.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    Key key,
    @required this.transaction,
    @required this.onSelect,
    @required this.isSelected,
    @required this.isSelectionActive,
    this.userCurrencyId = 1,
  }) : super(key: key);

  final TransactionWithDetails transaction;
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
            _buildListItemContent(context),
            _buildInteractiveLayer(),
          ],
        ),
      ),
    );
  }

  /// Builds a layer on top of the stack which shows the [InkWell] reaction.
  ///
  Widget _buildInteractiveLayer() {
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

  /// Builds the list items contents to be shown under the interactive layer.
  ///
  Widget _buildListItemContent(BuildContext context) {
    return ClipPath(
      clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardRadius))),
      child: CustomPaint(
        foregroundPainter: IndicatorPainter(
          color: transaction.isExpense ? Colors.red : Colors.green,
          thickness: 6,
          side:
              transaction.isExpense ? IndicatorSide.right : IndicatorSide.left,
        ),
        child: Container(
          margin: const EdgeInsets.all(2),
          child: ListTile(
            dense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tryTranslatePreset(transaction.s),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isSelected
                          ? Theme.of(context).colorScheme.secondary
                          : null),
                ),
                if (transaction.label.isNotEmpty) const SizedBox(height: 4),
                if (transaction.label.isNotEmpty)
                  Text(
                    transaction.label,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: isSelected ? Colors.white : null,
                        fontSize: 13),
                  )
              ],
            ),
            trailing: _buildAmountText(context),
            leading: isSelected
                ? const HistoryItemCheckmark()
                : HistoryItemIcon(categoryId: transaction.s.categoryId),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountText(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (transaction.recurrenceType > 1)
          Icon(
            Icons.replay,
            color: Theme.of(context).colorScheme.secondary,
            size: 18,
          )
        else
          const SizedBox(),
        CombinedAmountString(
          amount: transaction.amount,
          originalAmount: transaction.originalAmount,
          isExpense: transaction.isExpense,
          currencySymbol: transaction.c.symbol,
          currencyId: transaction.currencyId,
          userCurrencyId: userCurrencyId,
        ),
      ],
    );
  }
}

class HistoryItemIcon extends StatelessWidget {
  final int categoryId;

  const HistoryItemIcon({Key key, @required this.categoryId})
      : assert(categoryId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Icon(
        CategoryIcon(categoryId - 1).data,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}

class HistoryItemCheckmark extends StatelessWidget {
  const HistoryItemCheckmark({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Icon(
        Icons.check,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
