import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomDropdownMulti extends StatefulWidget {
  final String title;
  final String subtitle;
  final String allSelectedText;
  final String noSelectedText;
  final List<String> items;
  final void Function(List<String> selectedItems) onChanged;
  final IconData? icon;
  const CustomDropdownMulti({
    super.key,
    required this.title,
    required this.subtitle,
    required this.allSelectedText,
    required this.noSelectedText,
    required this.items,
    required this.onChanged,
    this.icon,
  });

  @override
  CustomDropdownMultiState createState() => CustomDropdownMultiState();
}

class CustomDropdownMultiState extends State<CustomDropdownMulti> {
  List<String> _selectedItems = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.items);
    _controller.text = widget.allSelectedText;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Center(
        child: TextField(
          controller: _controller,
          readOnly: true,
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.subtitle,
                                style: CustomStyle.mediumTextB,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.keyboard_return,
                                  color: CustomStyle.redDark,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        CheckboxListTile(
                          title: Text(widget.allSelectedText),
                          tristate: true,
                          activeColor:
                              (_selectedItems.length == widget.items.length)
                                  ? CustomStyle.redDark
                                  : CustomStyle.greyDark,
                          value: (_selectedItems.length == widget.items.length)
                              ? true
                              : _selectedItems.isEmpty
                                  ? false
                                  : null,
                          onChanged: (bool? value) {
                            if (_selectedItems.length == widget.items.length) {
                              _selectedItems = [];
                              _controller.text = widget.noSelectedText;
                            } else {
                              _selectedItems = List.from(widget.items);
                              _controller.text = widget.allSelectedText;
                            }
                            setState(() {
                              widget.onChanged(_selectedItems);
                            });
                          },
                        ),
                        const Divider(height: 1.0),
                        Expanded(
                          child: ListView(
                            children: widget.items.asMap().entries.map((entry) {
                              var item = entry.value;
                              return CheckboxListTile(
                                title: Text(item),
                                activeColor: CustomStyle.redDark,
                                value: _selectedItems.contains(item),
                                onChanged: (bool? value) {
                                  if (_selectedItems.contains(item)) {
                                    _selectedItems.remove(item);
                                    if (_selectedItems.isEmpty) {
                                      _controller.text = widget.noSelectedText;
                                    } else {
                                      _controller.text = _selectedItems
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        return entry.value;
                                      }).join(", ");
                                    }
                                  } else {
                                    _selectedItems.add(item);
                                    if (_selectedItems.length ==
                                        widget.items.length) {
                                      _controller.text = widget.allSelectedText;
                                    } else {
                                      _controller.text = _selectedItems
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        return entry.value;
                                      }).join(", ");
                                    }
                                  }
                                  setState(() {
                                    widget.onChanged(_selectedItems);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                });
              },
            );
          },
          decoration: InputDecoration(
            labelText: widget.title,
            labelStyle: CustomStyle.smallTextBRed,
            border: const OutlineInputBorder(),
            prefixIcon: (widget.icon == null)
                ? null
                : Icon(widget.icon, color: CustomStyle.redDark),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomStyle.redDark,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDropdownSingle extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<String> items;
  final void Function(String selectedItem) onChanged;
  final String? initialValue;
  final IconData? icon;
  const CustomDropdownSingle({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.onChanged,
    this.initialValue,
    this.icon,
  });

  @override
  CustomDropdownSingleState createState() => CustomDropdownSingleState();
}

class CustomDropdownSingleState extends State<CustomDropdownSingle> {
  String? _selectedItem;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue;
    _controller.text = widget.initialValue ?? "";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 10.0),
      child: Center(
        child: TextField(
          controller: _controller,
          readOnly: true,
          style: CustomStyle.mediumText,
          decoration: InputDecoration(
            labelText: widget.title,
            prefixIcon: (widget.icon == null)
                ? null
                : Icon(widget.icon, color: CustomStyle.redDark),
            labelStyle: CustomStyle.smallTextBRed,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: CustomStyle.greyMedium,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: CustomStyle.greyMedium,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: CustomStyle.redDark,
                width: 2.0,
              ),
            ),
          ),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.subtitle,
                                style: CustomStyle.mediumTextB,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.keyboard_return,
                                  color: CustomStyle.redDark,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: widget.items.asMap().entries.map((entry) {
                              var item = entry.value;
                              return RadioListTile<String>(
                                title: Text(item),
                                value: item,
                                groupValue: _selectedItem,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedItem = value;
                                    _controller.text = value!;
                                    widget.onChanged(value);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                });
              },
            );
          },
        ),
      ),
    );
  }
}
