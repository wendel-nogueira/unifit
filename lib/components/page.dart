import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/components/menu.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/controllers/account_controller.dart';

class MasterPage extends StatefulWidget {
  MasterPage(
      {super.key,
      required this.child,
      required this.title,
      this.showBackButton = true,
      this.showHeader = true,
      this.usePadding = true,
      this.showMenu = true,
      this.backButtonFunction});

  final Widget child;
  final String title;
  final int type = Get.find<AccountController>().type!;
  final bool showBackButton;
  final bool showHeader;
  final bool usePadding;
  final bool showMenu;
  final Function? backButtonFunction;

  @override
  State<MasterPage> createState() => _MasterPage();
}

class _MasterPage extends State<MasterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorWhiteLight,
      body: SingleChildScrollView(
        child: Container(
          color: bgColorWhiteLight,
          alignment: Alignment.topCenter,
          child: widget.child,
        ),
      ),
      appBar: widget.showHeader
          ? AppBar(
              backgroundColor: bgColorWhiteLight,
              elevation: 0,
              title: Text(
                widget.title,
                style: GoogleFonts.roboto(
                  color: fontColorBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              leading: widget.showBackButton
                  ? IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: fontColorBlue,
                      ),
                      onPressed: () => widget.backButtonFunction != null
                          ? widget.backButtonFunction!()
                          : Get.back(),
                    )
                  : const SizedBox(),
            )
          : null,
      bottomNavigationBar: widget.showMenu
          ? Container(
              height: 64,
              alignment: Alignment.bottomCenter,
              color: bgColorWhiteLight,
              child: Menu(accountType: widget.type),
            )
          : null,
    );
  }
}
