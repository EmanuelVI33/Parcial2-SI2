import 'package:flutter/material.dart';

class DialogError extends StatelessWidget {
  const DialogError({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error'),
      content: Text('No se pudo obtener la ubicación.'),
      actions: [
        TextButton(
          child: Text('Aceptar'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
