import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unifit/constants.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, required this.accountType});

  final int accountType;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    final Map<String, IconData> iconList = {
      '/my_plans': Icons.description,
      '/my_assessments': Icons.assessment,
      '/profile': Icons.person_outline,
      '/students-list': Icons.people_outline,
      '/frequency': Icons.calendar_month,
    };

    final Map<int, List<dynamic>> routesList = {
      0: [
        {
          'route': '/my_plans',
          'text': 'meus planos',
        },
        {
          'route': '/my_assessments',
          'text': 'minhas avaliações',
        },
        {
          'route': '/profile',
          'text': 'meu perfil',
        },
      ],
      1: [
        {
          'route': '/students-list',
          'text': 'alunos cadastrados',
        },
        {
          'route': '/frequency',
          'text': 'frequência',
        },
        {
          'route': '/profile',
          'text': 'meu perfil',
        },
      ],
    };

    final List<dynamic> userRoutes = routesList[widget.accountType]!;
    String activeRoute = ModalRoute.of(context)!.settings.name!;

    return Container(
      alignment: Alignment.bottomCenter,
      width: 136,
      height: 40,
      margin: const EdgeInsets.only(bottom: defaultPadding),
      decoration: const BoxDecoration(
        color: bgColorWhiteNormal,
        borderRadius: BorderRadius.all(Radius.circular(defaultRadiusLarger)),
        boxShadow: [
          BoxShadow(
            color: bgColorWhiteDark,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
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
                      if (activeRoute != userRoutes[index]['route'])
                        {
                          Get.offNamed(userRoutes[index]['route']),
                        }
                    },
                    hoverColor: fontColorBlue,
                    child: Icon(
                      iconList[userRoutes[index]['route']]!,
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
