import 'package:app3/features/profile/data/presentation/profile_cubit.dart';
import 'package:app3/features/profile/data/presentation/ui/edit_profile_screen.dart';
//import 'package:app3/features/profile/data/presentation/ui/new_password_screen.dart';
import 'package:app3/features/profile/data/presentation/ui/widgets/new_password_screen.dart';
import 'package:app3/features/profile/data/presentation/ui/widgets/profile_app_bar.dart';
import 'package:app3/features/profile/data/presentation/ui/profile_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'my_orders_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _push(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ProfileCubit>(),
          child: screen,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            const ProfileAppBar(),
            20.verticalSpace,
            BlocBuilder<ProfileCubit, ProfileState>(
              buildWhen: (_, s) =>
              s is GetProfileLoading ||
                  s is GetProfileSuccess ||
                  s is GetProfileError,
              builder: (context, state) {
                if (state is GetProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetProfileSuccess) {
                  final user = state.profileDate;
                  final image = user?.image ?? "";

                  final hasImage =
                      image.isNotEmpty && !image.endsWith('/storage');

                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 35.r,
                        backgroundColor: const Color(0xFFE0E0E0),
                        backgroundImage:
                        hasImage ? NetworkImage(image) : null,
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? "",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              user?.email ?? "",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text("Error");
                }
              },
            ),
            24.verticalSpace,
            Expanded(
              child: ListView(
                children: [
                  ProfileListTile(
                    title: "My Orders",
                    onTap: () {
                      context.read<ProfileCubit>().getOrders();
                      _push(context, const MyOrdersScreen());
                    },
                  ),
                  ProfileListTile(
                    title: "Edit Profile",
                    onTap: () => _push(context, const EditProfileScreen()),
                  ),
                  ProfileListTile(
                    title: "Reset Password",
                    onTap: () => _push(context, const NewPasswordScreen()),
                  ),
                  ProfileListTile(
                    title: "FAQ",
                    onTap: () {},
                  ),
                  ProfileListTile(
                    title: "Contact Us",
                    onTap: () {},
                  ),
                  ProfileListTile(
                    title: "Privacy & Terms",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}