import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget{
  final Widget smartphoneScaffold;
  final Widget tabletScaffold;
  final Widget desktopScaffold;

  const ResponsiveLayout({super.key, 
    required this.smartphoneScaffold,
    required this.tabletScaffold,
    required this.desktopScaffold
  });
  
  @override
  Widget build(BuildContext context) {
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