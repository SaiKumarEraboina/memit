import 'package:flutter/material.dart';
import 'package:memit/localization/string_hardcoded.dart';

/// Search field used to filter products by name
class MemeSearchTextField extends StatefulWidget {
  const MemeSearchTextField({super.key});

  @override
  State<MemeSearchTextField> createState() => _MemeSearchTextFieldState();
}

class _MemeSearchTextFieldState extends State<MemeSearchTextField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    // * TextEditingControllers should be always disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // See this article for more info about how to use [ValueListenableBuilder]
    // with TextField:
    // https://codewithandrea.com/articles/flutter-text-field-form-validation/
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        return TextField(
          controller: _controller,
          autofocus: false,
          style: Theme.of(context).textTheme.titleSmall,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
            ),
            hintText: 'Search memes,Creators, Hashtags'.hardcoded,
            prefixIcon: const Icon(Icons.search),
            suffixIcon:
                value.text.isNotEmpty
                    ? IconButton(
                      onPressed: () {
                        _controller.clear();
                        // TODO: Clear search state
                      },
                      icon: const Icon(Icons.clear),
                    )
                    : null,
          ),
          // TODO: Implement onChanged
          onChanged: null,
        );
      },
    );
  }
}
