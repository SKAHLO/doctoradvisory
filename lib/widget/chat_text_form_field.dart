import 'package:flutter/material.dart';

class ChatTextFormField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool isReadOnly;
  final void Function(String)? onFieldSubmitted;

  const ChatTextFormField({
    super.key,
    this.focusNode,
    this.controller,
    this.isReadOnly = false,
    required this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      autocorrect: false,
      focusNode: focusNode,
      controller: controller,
      readOnly: isReadOnly,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: null,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintText: "Type your message here...",
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your message';
        }
        return null;
      },
    );
  }
}
