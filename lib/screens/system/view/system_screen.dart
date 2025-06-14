import 'dart:async';

import 'package:fire_alarm_system/models/pin.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/screens/system/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/system/bloc/event.dart';
import 'package:fire_alarm_system/screens/system/bloc/state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class SystemScreen extends StatefulWidget {
  final int branchCode;
  const SystemScreen({super.key, required this.branchCode});
  @override
  SystemScreenState createState() => SystemScreenState();
}

class SystemScreenState extends State<SystemScreen> {
  List<Master> _masters = [];
  late Timer _timer;
  List<ExpansionTileController> _expansionTileControllers = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context
          .read<SystemBloc>()
          .add(RefreshRequested(branchCode: widget.branchCode));
    });
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      context
          .read<SystemBloc>()
          .add(LastSeenRequested(branchCode: widget.branchCode));
    });
    _expansionTileControllers = [
      ExpansionTileController(),
      ExpansionTileController(),
      ExpansionTileController(),
      ExpansionTileController(),
      ExpansionTileController(),
      ExpansionTileController()
    ];

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<SystemBloc>().add(CancelStreamRequested());
    });
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, state) {
        if (state is SystemNotAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (Route<dynamic> route) => false,
            );
          });
        } else if (state is SystemAuthenticated) {
          _masters = state.masters;
          handleLastSeen();
          return _buildSystem(context);
        }
        return const CustomLoading();
      },
    );
  }

  void handleLastSeen() {
    final now = DateTime.now();
    for (Master master in _masters) {
      final lastUpdate = master.lastSeen;
      final difference = now.difference(lastUpdate);
      if (difference.inSeconds <= 10) {
        master.isActive = true;
      } else {
        master.isActive = false;
      }
    }
  }

  String formatDateTime(DateTime dt) {
    final localTime = dt.toLocal();
    final timeZoneOffset = localTime.timeZoneOffset;
    final offsetHours = timeZoneOffset.inHours;
    final offsetMinutes = timeZoneOffset.inMinutes.remainder(60);
    final gmtSign = offsetHours >= 0 ? '+' : '-';
    final formattedOffset =
        'GMT$gmtSign${offsetHours.abs().toString().padLeft(2, '0')}:${offsetMinutes.toString().padLeft(2, '0')}';
    final formatter = DateFormat('dd/MM/yyyy - hh:mm:ss a');
    return '${formatter.format(localTime)} $formattedOffset';
  }

  Widget _buildSystem(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<SystemBloc>()
            .add(RefreshRequested(branchCode: widget.branchCode));
      },
      child: Scaffold(
        appBar: CustomAppBar(title: S.of(context).system),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Image.asset(
                  'assets/images/devices/${_masters[0].isActive ? 'online' : 'offline'}.png',
                  width: 50,
                  height: 50,
                ),
                title: Text(
                  "System is ${_masters[0].isActive ? 'online' : 'offline'}",
                  style: CustomStyle.largeTextB,
                ),
                subtitle: Text(
                  "Last seen: ${formatDateTime(_masters[0].lastSeen)}",
                  style: CustomStyle.smallText,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: _masters[0].pinsConfig.asMap().entries.map((entry) {
                  final clientId = entry.key;
                  final pins = entry.value;
                  bool isAlive = _masters[0].isClientAlive[clientId];
                  final outputPins =
                      pins.where((pin) => isOutput(pin.mode)).toList();
                  final inputPins =
                      pins.where((pin) => isInput(pin.mode)).toList();
                  final otherPins = pins
                      .where((pin) => !isOutput(pin.mode) && !isInput(pin.mode))
                      .toList();
                  isAlive &= _masters[0].isActive;
                  if (!isAlive) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      try {
                        _expansionTileControllers[clientId].collapse();
                      } catch (e) {
                        /* Do Nothing */
                      }
                    });
                  }
                  return ExpansionTile(
                    enabled: isAlive,
                    controller: _expansionTileControllers[clientId],
                    leading: Image.asset(
                      isAlive
                          ? 'assets/images/devices/active.png'
                          : 'assets/images/devices/inactive.png',
                      width: 32,
                    ),
                    title: Text(
                      "Client $clientId - ${isAlive ? 'Active' : 'Inactive'}",
                      style: CustomStyle.mediumTextB,
                    ),
                    children: [
                      if (outputPins.isNotEmpty)
                        _buildPinSection(context, "Outputs",
                            clientId.toString(), outputPins),
                      if (inputPins.isNotEmpty)
                        _buildPinSection(
                            context, "Inputs", clientId.toString(), inputPins),
                      if (otherPins.isNotEmpty)
                        _buildPinSection(
                            context, "Other", clientId.toString(), otherPins),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinSection(BuildContext context, String title, String clientId,
      List<PinConfig> pins) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                title == "Outputs"
                    ? Icons.output
                    : title == "Inputs"
                        ? Icons.input
                        : Icons.developer_board,
                size: 30,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: CustomStyle.largeTextB,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pins.map((pin) {
              return _buildPinCard(context, clientId, pin);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPinCard(BuildContext context, String clientId, PinConfig pin) {
    double cardWidth = 170;
    double remainingWidth = MediaQuery.of(context).size.width % 170;
    int numberOfCards = (MediaQuery.of(context).size.width / 170).floor();
    if (remainingWidth > 30 * numberOfCards) {
      remainingWidth = remainingWidth - 30 * numberOfCards;
      cardWidth = 170 + remainingWidth / numberOfCards;
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        width: cardWidth,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    _getPinNumberIcon(pin.index),
                    size: 20,
                    color: CustomStyle.redDark,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      getPinModeName(pin.mode),
                      style: CustomStyle.smallTextBRed,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                _getModeIconPath(pin.mode, pin.isActive),
                width: 60,
                height: 60,
              ),
            ),
            if (isInput(pin.mode) || isOutput(pin.mode))
              GestureDetector(
                onTap: () {
                  if (isOutput(pin.mode)) {
                    context.read<SystemBloc>().add(
                          SendCommandRequested(
                            branchCode: widget.branchCode,
                            masterId: 1,
                            clientId: int.parse(clientId),
                            pinIndex: pin.index,
                            request: pin.isActive
                                ? AppHwRequest.deactivatePin
                                : AppHwRequest.activatePin,
                          ),
                        );
                  }
                },
                child: Image.asset(
                  isOutput(pin.mode)
                      ? pin.isActive
                          ? 'assets/images/devices/on.png'
                          : 'assets/images/devices/off.png'
                      : pin.isActive
                          ? 'assets/images/devices/warning.png'
                          : 'assets/images/devices/no_warning.png',
                  width: 48,
                ),
              ),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.edit_square,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () async {
                AppPinMode selectedMode = AppPinMode.values[pin.mode];
                AppPinDirection selectedDirection =
                    AppPinDirection.values[pin.direction];
                int selectedNumber = pin.number;

                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  'Change Pin Configuration',
                                  style: CustomStyle.largeTextB,
                                ),
                                subtitle: Text(
                                  'Client: $clientId, Pin: ${pin.index}',
                                  style: CustomStyle.mediumText,
                                ),
                                leading: const Icon(
                                  Icons.settings,
                                  color: CustomStyle.redDark,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DropdownButtonFormField<AppPinMode>(
                                value: selectedMode,
                                decoration: InputDecoration(
                                  labelText:
                                      "Pin Mode", // 🏷️ Your dropdown label
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                onChanged: (newMode) {
                                  setState(() {
                                    selectedMode = newMode!;
                                  });
                                },
                                items: AppPinMode.values
                                    .where((mode) =>
                                        mode != AppPinMode.maxInput &&
                                        mode != AppPinMode.maxOutput)
                                    .map((mode) => DropdownMenuItem(
                                          value: mode,
                                          child: Text(mode.label),
                                        ))
                                    .toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DropdownButtonFormField<AppPinDirection>(
                                value: selectedDirection,
                                decoration: InputDecoration(
                                  labelText:
                                      "Pin Direction", // 🏷️ Your dropdown label
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                onChanged: (newDirection) {
                                  setState(() {
                                    selectedDirection = newDirection!;
                                  });
                                },
                                items: AppPinDirection.values
                                    .map((direction) => DropdownMenuItem(
                                          value: direction,
                                          child: Text(direction.label),
                                        ))
                                    .toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DropdownButtonFormField<int>(
                                value: selectedNumber,
                                decoration: InputDecoration(
                                  labelText:
                                      "Pin Number", // 🏷️ Your dropdown label
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                onChanged: (newNumber) {
                                  setState(() {
                                    selectedNumber = newNumber!;
                                  });
                                },
                                items: List.generate(
                                    41,
                                    (index) => DropdownMenuItem(
                                          value: index,
                                          child: Text(index.toString()),
                                        )),
                              ),
                            ),
                            CustomNormalButton(
                              label: 'Save',
                              fullWidth: true,
                              backgroundColor: Colors.green,
                              onPressed: () {
                                if (selectedNumber == pin.number &&
                                    selectedDirection.value == pin.direction &&
                                    selectedMode.value == pin.mode) {
                                  Navigator.pop(context);
                                  return;
                                } else {
                                  context.read<SystemBloc>().add(
                                        SendCommandRequested(
                                          branchCode: widget.branchCode,
                                          masterId: 1,
                                          clientId: int.parse(clientId),
                                          pinIndex: pin.index,
                                          request: AppHwRequest.configurePin,
                                          pinConfig: PinConfig(
                                            index: pin.index,
                                            number: selectedNumber,
                                            mode: selectedMode.value,
                                            direction: selectedDirection.value,
                                            isActive: false,
                                          ),
                                        ),
                                      );
                                }
                                Navigator.pop(context);
                              },
                            ),
                            CustomNormalButton(
                              label: 'Cancel',
                              fullWidth: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    });
                  },
                );
              },
              label: Text(
                'Edit',
                style: CustomStyle.smallTextB,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPinNumberIcon(int number) {
    switch (number) {
      case 0:
        return FontAwesomeIcons.zero;
      case 1:
        return FontAwesomeIcons.one;
      case 2:
        return FontAwesomeIcons.two;
      case 3:
        return FontAwesomeIcons.three;
      case 4:
        return FontAwesomeIcons.four;
      case 5:
        return FontAwesomeIcons.five;
      case 6:
        return FontAwesomeIcons.six;
      case 7:
        return FontAwesomeIcons.seven;
      default:
        return FontAwesomeIcons.minus;
    }
  }

  String _getModeIconPath(int mode, bool isActive) {
    String assetPath;
    if (mode == AppPinMode.notConfigured.value) {
      assetPath = 'assets/images/devices/disconnected.png';
    } else if (mode == AppPinMode.inputButton.value) {
      assetPath = "assets/images/devices/button_${isActive ? "on" : "off"}.png";
    } else if (mode == AppPinMode.inputGas.value) {
      assetPath = "assets/images/devices/gas_${isActive ? "on" : "off"}.png";
    } else if (mode == AppPinMode.inputHeat.value) {
      assetPath = "assets/images/devices/heat_${isActive ? "on" : "off"}.png";
    } else if (mode == AppPinMode.inputSmoke.value) {
      assetPath = "assets/images/devices/smoke_${isActive ? "on" : "off"}.png";
    } else if (mode == AppPinMode.outputLed.value) {
      assetPath = "assets/images/devices/led_${isActive ? "on" : "off"}.png";
    } else if (mode == AppPinMode.outputBuzzer.value) {
      assetPath = "assets/images/devices/buzzer_${isActive ? "on" : "off"}.png";
    } else if (mode == AppPinMode.outputRelay.value) {
      assetPath = "assets/images/devices/relay_${isActive ? "on" : "off"}.png";
    } else if (mode == AppPinMode.outputLcd.value) {
      assetPath = "assets/images/devices/lcd.png";
    } else if (mode == AppPinMode.outputKeypad.value ||
        mode == AppPinMode.inputKeypad.value) {
      assetPath = "assets/images/devices/keypad.png";
    } else {
      assetPath = 'assets/images/devices/disconnected.png';
    }
    return assetPath;
  }

  String getPinModeName(int mode) {
    switch (mode) {
      case 0:
        return "Not Configured";
      case 1:
        return "Smoke Sensor";
      case 2:
        return "Gas Sensor";
      case 3:
        return "Heat Sensor";
      case 4:
        return "Button";
      case 6:
        return "Buzzer";
      case 7:
        return "Relay";
      case 8:
        return "LED";
      case 10:
        return "LCD";
      case 11:
      case 12:
        return "Keypad";
      default:
        return "UNKNOWN";
    }
  }

  bool isOutput(int mode) {
    switch (mode) {
      case 6:
      case 7:
      case 8:
        return true;
      default:
        return false;
    }
  }

  bool isInput(int mode) {
    switch (mode) {
      case 1: // Smoke Sensor
      case 2: // Gas Sensor
      case 3: // Heat Sensor
      case 4: // Button
        return true;
      default:
        return false;
    }
  }
}
