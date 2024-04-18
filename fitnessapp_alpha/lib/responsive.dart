import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget{
  final Widget smartphoneScaffold;
  final Widget tabletScaffold;
  final Widget desktopScaffold;

  ResponsiveLayout({
    required this.smartphoneScaffold,
    required this.tabletScaffold,
    required this.desktopScaffold
  });
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LayoutBuilder(builder: (context, constraints) {
      if(constraints.maxWidth < 500){
        return smartphoneScaffold;
      }else if(constraints.maxWidth < 1100){
        return tabletScaffold;
      }else{
        return desktopScaffold;
      }
    },);
  }
}