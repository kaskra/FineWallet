extension StringToBool on String {
  bool toBool() {
    if (this != "true" && this != "false")
      throw FormatException(
          "The String $this cant't be converted to a boolean value!");

    return this == "true";
  }
}
