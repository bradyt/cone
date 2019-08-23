import 'package:flutter/material.dart';

SnackBar transactionSnackBar(String transaction) {
  return SnackBar(
    content: RichText(
      text: TextSpan(
        text: transaction,
        style: const TextStyle(
          fontFamily: 'IBMPlexMono',
        ),
      ),
    ),
  );
}
