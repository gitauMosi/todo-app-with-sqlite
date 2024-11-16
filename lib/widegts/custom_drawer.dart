import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_sqapp/pages/inbox_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),
            customTile("Inbox", Icons.inbox, () {
              Get.to(() => const InboxPage());
            }),
            customTile("Today", Icons.star, () {}),
            customTile("Tomorrow", Icons.calendar_month_outlined, () {}),
            const SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Projects",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary),
            )
          ],
        ),
      ),
    );
  }

  ListTile customTile(String label, IconData icon, Function() function) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: Icon(
        icon,
      ),
      title: Text(label),
      onTap: function,
    );
  }
}
