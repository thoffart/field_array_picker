import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;
class PickerArrayField extends FormField<String> {
  PickerArrayField({
    @required this.onShowPicker,
    @required this.options,

    Key key,
    this.resetIcon = const Icon(Icons.close),
    this.showClearIcon = true,
    this.onChanged,
    this.controller,
    this.focusNode,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    String initialValue,
    bool autovalidate = false,
    bool enabled = true,
    InputDecoration decoration = const InputDecoration(),
    TextInputType keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction,
    TextStyle style,
    StrutStyle strutStyle,
    TextDirection textDirection,
    TextAlign textAlign = TextAlign.start,
    bool autofocus = false,
    bool obscureText = false,
    bool autocorrect = true,
    bool maxLengthEnforced = true,
    int maxLines = 1,
    int minLines,
    bool expands = false,
    int maxLength,
    VoidCallback onEditingComplete,
    ValueChanged<String> onFieldSubmitted,
    List<TextInputFormatter> inputFormatters,
    double cursorWidth = 2.0,
    Radius cursorRadius,
    Color cursorColor,
    Brightness keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder buildCounter,
  }) : super(
            key: key,
            autovalidate: autovalidate,
            initialValue: initialValue,
            enabled: enabled ?? true,
            validator: validator,
            onSaved: onSaved,
            builder: (field) {
              final _PickerArrayFieldState state = field;
              final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration()).applyDefaults(Theme.of(field.context).inputDecorationTheme);
              return TextField(
                controller: state._effectiveController,
                focusNode: state._effectiveFocusNode,
                decoration: effectiveDecoration.copyWith(
                  errorText: field.errorText,
                  suffixIcon: state.shouldShowClearIcon(effectiveDecoration)
                      ? IconButton(
                          icon: resetIcon,
                          onPressed: state.clear,
                        )
                      : effectiveDecoration.suffixIcon,
                ),
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                style: style,
                strutStyle: strutStyle,
                textAlign: textAlign,
                textDirection: textDirection,
                textCapitalization: textCapitalization,
                autofocus: autofocus,
                obscureText: obscureText,
                autocorrect: autocorrect,
                maxLengthEnforced: maxLengthEnforced,
                maxLines: maxLines,
                minLines: minLines,
                expands: expands,
                maxLength: maxLength,
                onChanged: (string) =>
                    field.didChange(tryParse(string, options)),
                onEditingComplete: onEditingComplete,
                onSubmitted: (string) => onFieldSubmitted == null ? null : onFieldSubmitted(tryParse(string, options)),
                inputFormatters: inputFormatters,
                enabled: enabled,
                cursorWidth: cursorWidth,
                cursorRadius: cursorRadius,
                cursorColor: cursorColor,
                scrollPadding: scrollPadding,
                keyboardAppearance: keyboardAppearance,
                enableInteractiveSelection: enableInteractiveSelection,
                buildCounter: buildCounter,
              );
            });

  final Function(BuildContext context, String currentValue) onShowPicker;
  final List<String> options;
  final Icon resetIcon;
  final bool showClearIcon;

  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String value) onChanged;

  @override
  _PickerArrayFieldState createState() => _PickerArrayFieldState();

  static String tryParse(String string, List<String> options) {
    if (string?.isNotEmpty ?? false) {
      List<String> choose = options.where((option) => option == string.replaceAll(new RegExp(r'\['), '"').replaceAll(new RegExp(r'\]'), '"')).toList();
      if (choose.length >= 0) {
        return string.replaceAll(new RegExp(r'\['), '').replaceAll(new RegExp(r'\]'), '');
      }
    }
    return '';
  }
}

class _PickerArrayFieldState extends FormFieldState<String> {
  TextEditingController _controller;
  FocusNode _focusNode;
  bool isShowingDialog = false;
  bool hadFocus = false;

  @override
  PickerArrayField get widget => super.widget;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;
  FocusNode get _effectiveFocusNode => widget.focusNode ?? _focusNode;

  bool get hasFocus => _effectiveFocusNode.hasFocus;
  bool get hasText => _effectiveController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: parse(widget.initialValue));
    }
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    }
    _effectiveController.addListener(_handleControllerChanged);
    _effectiveFocusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(PickerArrayField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null) {
      setValue(parse(widget.controller.text));
    }
    if (oldWidget.controller == null) _controller = null;
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller =
            TextEditingController.fromValue(oldWidget.controller.value);
      }
    }
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
      widget.focusNode?.addListener(_handleFocusChanged);

      if (oldWidget.focusNode != null && widget.focusNode == null) {
        _focusNode = FocusNode();
        _focusNode.addListener(_handleFocusChanged);
      }
      if (widget.focusNode != null && oldWidget.focusNode == null) {
        _focusNode?.dispose();
        _focusNode = null;
      }
    }
  }

  @override
  void didChange(value) {
    if (widget.onChanged != null) widget.onChanged(value);
    super.didChange(value);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    widget.focusNode?.removeListener(_handleFocusChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    _effectiveController.text = parse(widget.initialValue);
    didChange(widget.initialValue);
  }

  void _handleControllerChanged() {
    if (_effectiveController.text != parse(value))
      didChange(parse(_effectiveController.text));
  }

  String parse(String text) => PickerArrayField.tryParse(text, widget.options);

  Future<void> requestUpdate() async {
    if (!isShowingDialog) {
      isShowingDialog = true;
      showPicker(context, value);
      final newValue = widget.controller.text;
      isShowingDialog = false;
      if (newValue != null) {
        _effectiveController.text = parse(newValue);
      }
    }
  }

  Future<void> showPicker(context, value) async {
    await widget.onShowPicker(context, value);
  }

  void _handleFocusChanged() {
    if (hasFocus && !hadFocus) {
      hadFocus = hasFocus;
      _hideKeyboard();
      requestUpdate();
    } else {
      hadFocus = hasFocus;
    }
  }

  void _hideKeyboard() {
    Future.microtask(() => FocusScope.of(context).requestFocus(FocusNode()));
  }

  void clear() async {
    _hideKeyboard();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _effectiveController.clear());
    });
  }

  bool shouldShowClearIcon([InputDecoration decoration]) =>
      widget.resetIcon != null &&
      (hasText || hasFocus)
      && widget.showClearIcon;
}
