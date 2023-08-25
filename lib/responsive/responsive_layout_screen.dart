import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/global_variables.dart';

class ResponsiveScreen extends StatefulWidget {
  const ResponsiveScreen(
      {required this.mobileScreen, required this.webScreen, Key? key})
      : super(key: key);
  final Widget webScreen;
  final Widget mobileScreen;

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= webScreenSize) {
        return widget.webScreen;
      }
      return widget.mobileScreen;
    });
  }

  getData() async {
    try {
      UserProvider userProvider = Provider.of(context, listen: false);
      await userProvider.refreshUser();
    } catch (err) {
      print(err.toString());
    }
  }
}
