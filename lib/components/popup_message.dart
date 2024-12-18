import 'package:flutter/material.dart';

void showCustomPopup(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents dismissing by tapping outside
    builder: (BuildContext context) {
      // Use a Future to dismiss the popup after a few seconds
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });

      return Align(
        alignment: Alignment.bottomCenter, // Align the popup towards the bottom
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 40), // Reduce the size
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjusted padding for a smaller size
            color: Colors.black, // Solid black background
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Green circle with a white tick
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8), // Space between tick and text
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14, // Smaller text size
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
