import 'package:flutter/material.dart';
import '../details/district_home.dart';

class AlWesta extends StatelessWidget {
  const AlWesta({super.key});

  @override
  Widget build(BuildContext context) {
    return const DistrictHome(
      district: "الوسطى",
      title: "الوسطى",
    );
  }
}