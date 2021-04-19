part of 'history_page.dart';

class HistoryDateTitle extends StatelessWidget {
  final DateTime date;

  const HistoryDateTitle({Key key, @required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat d = DateFormat.MMMEd(context.locale.toLanguageTag());

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 5.0),
      child: Text(d.format(date), style: Theme.of(context).textTheme.subtitle2),
    );
  }
}
