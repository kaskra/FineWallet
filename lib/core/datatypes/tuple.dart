/// This class represents a 2-tuple with generic types [E] and [V].
class Tuple2<E, V> {
  E first;
  V second;

  Tuple2(this.first, this.second);

  @override
  String toString() {
    return "Tuple2($first, $second)";
  }
}
