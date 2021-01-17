import 'dart:convert';

import 'package:field_array_picker/picker-array-field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class PickerArrayWidget extends StatelessWidget {
  const PickerArrayWidget({
    Key key,
    @required this.controller,
    @required this.focusNode,
    @required this.options,
    @required this.title,
    @required this.inputDecoration,
    this.onSaved,
    this.onFieldSubmitted,
    this.validator,
    this.style,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.actAfterSelected,
    this.onChanged,
    this.showClearIcon = true,
  }) : super(key: key);
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<String> options;
  final Text title;
  final InputDecoration inputDecoration;
  final Function() onFieldSubmitted;
  final Function(String param) onSaved;
  final Function(String param) validator;
  final TextStyle style;
  final String confirmText;
  final String cancelText;
  final Function actAfterSelected;
  final Function onChanged;
  final bool showClearIcon;
  @override
  Widget build(BuildContext context) {
    return PickerArrayField(
      decoration: inputDecoration,
      controller: controller,
      options: options,
      focusNode: focusNode,
      onSaved: onSaved,
      validator: validator,
      style: style,
      onFieldSubmitted: (value) {
        onFieldSubmitted();
      },
      onChanged: onChanged,
      showClearIcon: showClearIcon,
      onShowPicker: (context, currentValue) {
        Picker(
          confirmText: confirmText,
          cancelText: cancelText,
          adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert('[' + options.toString() + ']'),
            isArray: true,
          ),
          hideHeader: true,
          title: title,
          onConfirm: (Picker picker, List value) {
            controller.text = picker.getSelectedValues().toString().replaceAll(new RegExp(r'\['), '').replaceAll(new RegExp(r'\]'), '');
            if(actAfterSelected != null) 
              actAfterSelected(picker.getSelectedValues().toString().replaceAll(new RegExp(r'\['), '').replaceAll(new RegExp(r'\]'), ''));
          }
        ).showDialog(context);
      },
    );
  }
}