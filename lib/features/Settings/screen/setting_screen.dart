import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/Components/app_button.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/core/theme/gap.dart';
import 'package:movie_app/features/Settings/widgets/custom_profile.dart';
import 'package:movie_app/service/auth_service.dart';
import 'package:movie_app/service/user_service.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSwitched = false;
  final authService = AuthService();
  final userService = UserService();

  void _logout() async {
    await authService.signOut();
    if (mounted) {
      Modular.to.navigate("/authen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const TextHead(text: 'Profile'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Gap.mL, vertical: Gap.mL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://static.vecteezy.com/system/resources/thumbnails/007/209/020/small_2x/close-up-shot-of-happy-dark-skinned-afro-american-woman-laughs-positively-being-in-good-mood-dressed-in-black-casual-clothes-isolated-on-grey-background-human-emotions-and-feeligs-concept-photo.jpg"),
              radius: 70,
            ),
            const SizedBox(height: Gap.sM),
            FutureBuilder<Map<String, dynamic>?>(
              future: userService.getUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return Center(
                      child: Text(
                          "Error: ${snapshot.error ?? "Failed to load profile"}"));
                }
                final userProfile = snapshot.data!;
                final role = userProfile['role'];
                return Column(
                  children: [
                    TextHead(
                      text: userProfile['name'],
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Gap.lgHeight,
                    if (role == "customer")
                      const CustomProfile()
                    else
                      ListTile(
                        leading: const Icon(Icons.manage_accounts),
                        title: Text("Manage",
                            style: Theme.of(context).textTheme.bodyMedium),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Modular.to.pushNamed("/manage/");
                        },
                      ),
                  ],
                );
              },
            ),
            Gap.lXHeight,
            Align(
              alignment: Alignment.centerLeft,
              child: TextHead(
                text: 'Settings',
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Gap.mLHeight,
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title:
                  Text("Theme", style: Theme.of(context).textTheme.bodyMedium),
              trailing: Switch(
                value: isSwitched,
                onChanged: (value) => setState(() => isSwitched = value),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: AppButton(text: "Logout", onPressed: _logout),
            ),
          ],
        ),
      ),
    );
  }
}
