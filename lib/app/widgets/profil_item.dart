import 'package:flutter/material.dart';

Widget profileItem(
    IconData leading, String name, IconData trailing, Function() onTap) {
  return Container(
    margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF7090B0).withOpacity(0.2),
          blurRadius: 20.0,
          offset: const Offset(0, 10.0),
        )
      ],
    ),
    child: Material(
      child: ListTile(
        onTap: onTap,
        title: Text(
          name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: Icon(leading),
        trailing: Icon(
          trailing,
          size: 32,
        ),
      ),
    ),
  );
}
