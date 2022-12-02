import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_tutorial/core/common/loader.dart';
import 'package:redit_tutorial/core/providers/firebase_providers.dart';
import 'package:redit_tutorial/features/auth/controller/auth_controller.dart';

import '../../../core/common/sign_in_button.dart';
import '../../../core/constants/constants.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    final isLoading =  ref.watch(authControllerProvider) ; 
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.logoPath,
          height: 40,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            child: const Text(
              "Skip",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {},
          )
        ],
      ),
      body: isLoading ? const Loader() : Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Dive into anything",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              Constants.loginEmotePath,
              width: double.infinity,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const SignInButton(),
        ],
      ),
    );
  }
}
