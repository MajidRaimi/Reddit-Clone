import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils.dart';
import '../../../model/user_model.dart';
import '../repository/auth_repository.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);


// in general it's regular Provider but the object that provides it extends StateNotifier
// so we change it from (Provider) to (StateNotifierProvider)
final authControllerProvider = StateNotifierProvider<AuthController , bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangedProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;

}  ) ; 



// similar to ChangeNotifierProvider from (Provider)
class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false); // represent if isLoading

  Stream<User?> get authStateChange => _authRepository.authStateChanges;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    // l for errors r for success

    user.fold(
      (l) => showSnackBar(context, l.message),
      // update the use in the app
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
    
  }

  Stream<UserModel> getUser(String uid) => _authRepository.getUserData(uid);
}
