import 'package:flutter/material.dart';
import '/components/button.dart';

class AddLinkBottomSheet extends StatefulWidget {
  final String iconPath;
  final String title;
  final String labelText;
  final String hintText;
  final String buttonText;

  const AddLinkBottomSheet({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.labelText,
    required this.hintText,
    required this.buttonText,
  }) : super(key: key);

  @override
  State<AddLinkBottomSheet> createState() => _AddLinkBottomSheetState();
}

class _AddLinkBottomSheetState extends State<AddLinkBottomSheet> {
  final TextEditingController _textController = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    // Update button state when text changes
    _textController.addListener(() {
      _isButtonEnabled.value = _textController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, // Align content left
        children: [
          // Icon at the top (centered)
          Center(
            child: Image.asset(
              widget.iconPath,
              height: 100,
              width: 100,
            ),
          ),
          // Title (center-aligned)
          Center(
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Label (left-aligned)
          Text(
            widget.labelText,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          // TextField
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Add Button (Full Width with Enabled/Disabled Logic)
          ValueListenableBuilder<bool>(
            valueListenable: _isButtonEnabled,
            builder: (context, isEnabled, child) {
              return SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: widget.buttonText,
                  onPressed: isEnabled
                      ? () {
                          // Add action here
                        }
                      : null, // Disable button when no data
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
