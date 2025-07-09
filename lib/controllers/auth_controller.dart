import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> _user = Rxn<User>();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isLoading = false.obs;
  final errorMessage = RxString('');
  
  User? get user => _user.value;
  bool get isLoggedIn => _user.value != null;
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
  }

  Future<void> register() async {
    if (!_validateForm()) return;
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAllNamed(AppRoutes.tasks);
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? 'Registration failed';
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
  
  bool _validateForm() {
    if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
      errorMessage.value = 'Please enter a valid email';
      return false;
    }
    
    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters';
      return false;
    }
    
    return true;
  }

  Future<void> login() async {
    if (!_validateForm()) return;
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAllNamed(AppRoutes.tasks);
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? 'Login failed';
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      errorMessage.value = 'Logout failed';
      rethrow;
    }
  }

  // Redirect to login if not authenticated
  void requireAuth() {
    if (!isLoggedIn) {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
