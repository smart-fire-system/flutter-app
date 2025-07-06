enum AppHwRequest {
  noRequest,
  activatePin,
  deactivatePin,
  configurePin,
}

enum AppPinMode {
  notConfigured(0, "Not Configured"),
  inputSmoke(1, "Smoke Sensor"),
  inputGas(2, "Gas Sensor"),
  inputHeat(3, "Heat Sensor"),
  inputButton(4, "Button"),
  maxInput(5, "-"),
  outputBuzzer(6, "Buzzer"),
  outputRelay(7, "Relay"),
  outputLed(8, "LED"),
  maxOutput(9, "-"),
  outputLcd(10, "LCD"),
  outputKeypad(11, "Keypad Output"),
  inputKeypad(12, "Keypad Input");

  final int value;
  final String label;
  const AppPinMode(this.value, this.label);
}

enum AppPinDirection {
  notConfigured(0, "Not Configured"),
  input(1, "Input"),
  inputPullup(2, "Input with Pull-Up"),
  inputPulldown(3, "Input with Pull-Down"),
  output(4, "Output");

  final int value;
  final String label;
  const AppPinDirection(this.value, this.label);
}

class PinConfig {
  final int index;
  final int number;
  final int mode;
  final int direction;
  final bool isActive;

  PinConfig({
    required this.index,
    required this.number,
    required this.mode,
    required this.direction,
    required this.isActive,
  });

  factory PinConfig.fromMap(Map<dynamic, dynamic> map, int pinIndex) {
    return PinConfig(
      index: pinIndex,
      number: map['number'] ?? 0,
      mode: map['mode'] ?? 0,
      direction: map['direction'] ?? 0,
      isActive: map['isActive'] ?? false,
    );
  }
}

class Master {
  final int id;
  final int branchCode;
  bool isActive;
  DateTime lastSeen;
  final List<List<PinConfig>> pinsConfig;
  final List<bool> isClientAlive;
  final List<bool> isClientConfigured;
  Master({
    required this.id,
    required this.branchCode,
    required this.isActive,
    required this.lastSeen,
    required this.pinsConfig,
    required this.isClientAlive,
    required this.isClientConfigured,
  });
}
