enum UpdateModifierFlag { all, onlyFuture, onlySelected }

class UpdateModifier {
  UpdateModifierFlag flag;
  DateTime selectedDate;

  UpdateModifier(this.flag, [this.selectedDate])
      : assert(flag != null),
        assert((flag != UpdateModifierFlag.all && selectedDate != null) ||
            (flag == UpdateModifierFlag.all));

  @override
  String toString() {
    return 'UpdateModifier{flag: $flag, selectedDate: $selectedDate}';
  }
}
