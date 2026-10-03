import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/user_model.dart';
import '../../data/auth_repository.dart';
import '../../domain/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState()) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _repository.authStateChanges.listen((user) {
      if (user != null) {
        state = AuthState(
          status: AuthStatus.authenticated,
          user: _userFromFirebaseUser(user),
        );
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    });
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _repository.signInWithEmailAndPassword(email, password);
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _mapFirebaseError(e),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'সাইন ইন ব্যর্থ হয়েছে। আবার চেষ্টা করুন।',
      );
    }
  }

  Future<void> createUserWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _repository.createUserWithEmailAndPassword(
        name,
        email,
        password,
      );
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _mapFirebaseError(e),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'অ্যাকাউন্ট তৈরি ব্যর্থ হয়েছে। আবার চেষ্টা করুন।',
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _repository.signInWithGoogle();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'গুগল সাইন ইন ব্যর্থ হয়েছে। আবার চেষ্টা করুন।',
      );
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'এই ইমেইল দিয়ে কোনো অ্যাকাউন্ট নেই।';
      case 'wrong-password':
        return 'ভুল পাসওয়ার্ড।';
      case 'email-already-in-use':
        return 'এই ইমেইল ইতিমধ্যে ব্যবহৃত হচ্ছে।';
      case 'invalid-email':
        return 'অবৈধ ইমেইল ঠিকানা।';
      case 'weak-password':
        return 'পাসওয়ার্ড খুব দুর্বল।';
      case 'too-many-requests':
        return 'অনেকবার চেষ্টা হয়েছে। কিছুক্ষণ পর আবার চেষ্টা করুন।';
      default:
        return 'কিছু ভুল হয়েছে। আবার চেষ্টা করুন।';
    }
  }

  UserModel _userFromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
