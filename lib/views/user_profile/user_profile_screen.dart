import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/controllers/account_controller.dart';

import '../../components/page.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final account = Get.find<AccountController>();
    final type = account.type!;
    final user = account.user;
    final teacher = account.teacher;

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var nome = type == 0 ? user!.nome.toString() : teacher!.nome.toString();

    if (nome.length > 10) {
      nome = '${nome.substring(0, 10)}...';
    }

    return MasterPage(
      title: 'perfil',
      showBackButton: false,
      showHeader: false,
      usePadding: false,
      child: SizedBox(
        width: width,
        height: height - 64,
        child: Column(
          children: [
            Container(
              width: width,
              height: height * 0.3,
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    bgColorBlueLightSecondary,
                    bgColorBlueNormal,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(defaultRadiusLarger),
                  bottomRight: Radius.circular(defaultRadiusLarger),
                ),
                boxShadow: [boxShadowDefault],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  const SizedBox(width: defaultPadding),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        style: const TextStyle(
                          color: fontColorWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        type == 0 ? 'aluno' : 'professor',
                        style: const TextStyle(
                          color: fontColorWhite,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: fontColorWhite,
                    ),
                    onPressed: () => {
                      account.logout(),
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );
  }
}
