import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StartButton extends StatelessWidget{
  final VoidCallback onPressed;

  const StartButton({required this.onPressed});

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 251, 119, 67),
        foregroundColor: Colors.brown[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      elevation: 50.0,
      ),
      child: Text(
        'Start',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}