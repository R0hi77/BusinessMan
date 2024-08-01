import 'package:flutter/material.dart';

class DropdownListTextField extends StatelessWidget {
  final List<String> items;
  final String? hint;
  final ValueChanged<String?>? onChanged;
  final String? value;
  final String? Function(String?)? validator;

  DropdownListTextField({
    required this.items,
    this.hint,
    this.onChanged,
    this.value,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: hint != null ? Text(hint!) : null,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          
        ),
    )
    );
  }
}
