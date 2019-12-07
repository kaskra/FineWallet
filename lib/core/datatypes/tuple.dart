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

///This class represents a 3-tuple with generic types [E], [E2] and [E3].
class Tuple3<E, E2, E3> {
  E first;
  E2 second;
  E3 third;

  Tuple3(this.first, this.second, this.third);

  @override
  String toString() {
    return "Tuple3($first, $second, $third)";
  }
}
