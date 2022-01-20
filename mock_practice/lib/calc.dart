class Calc {
  int value = 0;

  void increment() => value++;

  Helper help = Helper();

  int syncHelper(Helper help) {
    value = help.setUp();
    value = help.bonusClick();

    increment();

    return value;
  }
}

class Helper {
  int setUp() => 0;
  int bonusClick() => 0;
}
