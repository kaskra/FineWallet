part of 'history_page.dart';

class HistoryDateTitle extends StatelessWidget {
  final DateTime date;

  const HistoryDateTitle({Key key, @required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat d = DateFormat.MMMEd(context.locale.toLanguageTag());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: StructureTitle(
        text: d.format(date),
      ),
    );
  }
}
