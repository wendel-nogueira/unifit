import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/controllers/account_controller.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, required this.accountType});

  final int accountType;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    AccountController accountController = Get.find<AccountController>();

    final Map<int, List<dynamic>> routesList = {
      0: [
        {
          'route': '/my-sheets',
          'text': 'meus planos',
          'icon': Icons.description_outlined,
        },
        {
          'route': accountController.type == 0 && accountController.user != null
              ? '/user-physical-assessments/${accountController.user!.idAluno}'
              : '/physical-assessments',
          'text': 'minhas avaliações',
          'icon': Icons.assessment_outlined,
        },
        {
          'route': '/profile',
          'text': 'meu perfil',
          'icon': Icons.person_outline,
        },
      ],
      1: [
        {
          'route': '/students-list',
          'text': 'alunos cadastrados',
          'icon': Icons.people_outline,
        },
        {
          'route': '/frequency',
          'text': 'frequência',
          'icon': Icons.calendar_month_outlined,
        },
        {
          'route': '/sheets-list',
          'text': 'fichas de treino',
          'icon': Icons.description_outlined,
        },
        {
          'route': '/profile',
          'text': 'meu perfil',
          'icon': Icons.person_outline,
        },
      ],
    };

    final List<dynamic> userRoutes =
        widget.accountType != -1 ? routesList[widget.accountType]! : [];
    String activeRoute = ModalRoute.of(context)!.settings.name!;

    return Container(
      alignment: Alignment.bottomCenter,
      width: 136,
      height: 40,
      margin: const EdgeInsets.only(bottom: defaultPadding),
      decoration: const BoxDecoration(
        color: bgColorWhiteNormal,
        borderRadius: BorderRadius.all(Radius.circular(defaultRadiusLarger)),
        boxShadow: [boxShadowDefault],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: userRoutes.length,
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => {
                      Get.offAllNamed(userRoutes[index]['route']),
                      if (activeRoute != userRoutes[index]['route'])
                        {
                          Get.offNamed(userRoutes[index]['route']),
                        }
                    },
                    hoverColor: fontColorBlue,
                    child: Icon(
                      userRoutes[index]['icon'],
                      color: activeRoute == userRoutes[index]['route']
                          ? fontColorBlue
                          : fontColorGray,
                    ),
                  ),
                  if (index < userRoutes.length - 1) const SizedBox(width: 8),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
