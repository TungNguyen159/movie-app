import 'package:flutter/material.dart';
import 'package:movie_app/Components/alert_dialog.dart';
import 'package:movie_app/models/user.dart';
import 'package:movie_app/service/user_service.dart';

class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.user,
  });
  final List<Users> user;
  @override
  Widget build(BuildContext context) {
    final userService = UserService();

    _onDelete(Users id) async {
      final result = await showDialog(
        context: context,
        builder: (BuildContext context) => const CustomAlertDialog(
          title: "Alert",
          description: "do you want delete this user?",
          confirmText: "yes",
          cancelText: "no",
        ),
      );
      if (result == true) {
        await userService.deleteUser(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("delete successful!.")),
        );
      } else {
        Navigator.of(context).pop;
      }
    }

    _oneditUser(BuildContext context, Users userId, String currentRole) {
      String selectedRole = currentRole;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Chỉnh sửa quyền"),
          content: DropdownButtonFormField<String>(
            value: selectedRole,
            items: ["admin", "staff", "customer"].map((role) {
              return DropdownMenuItem(
                  value: role, child: Text(role.toUpperCase()));
            }).toList(),
            onChanged: (value) => selectedRole = value!,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Hủy")),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                userService.updateUser(selectedRole, userId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("update successful!.")),
                );
              },
              child: const Text("Lưu"),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: user.length,
      itemBuilder: (ctx, index) {
        final users = user[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey[100],
              child: Text(users.name[0].toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(users.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle:
                Text(users.email, style: TextStyle(color: Colors.grey[700])),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(users.role.toUpperCase(),
                    style: const TextStyle(color: Colors.blueAccent)),
                IconButton(
                  onPressed: () => _oneditUser(ctx, users, users.role),
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
                IconButton(
                  onPressed: () => _onDelete(users),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
