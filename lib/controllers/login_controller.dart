import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  // State variables
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs; // observable for loading state
  var errorMessage = ''.obs; // observable for error message
  var isPasswordVisible = false.obs; // observable for password visibility

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Regex for email validation
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  // Method to handle login
  Future<void> login() async {
    isLoading.value = true; // Start loading
    errorMessage.value = ''; // Reset error message

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Check for empty fields
    if (email.isEmpty || password.isEmpty) {
      showAlert("Please fill out all fields");
      isLoading.value = false; // Stop loading
      return;
    }

    // Validate email format
    if (!emailRegex.hasMatch(email)) {
      showAlert("Please enter a valid email address");
      isLoading.value = false; // Stop loading
      return;
    }

    // Check if password is at least 6 characters
    if (password.length < 6) {
      showAlert("Password must be at least 6 characters long");
      isLoading.value = false; // Stop loading
      return;
    }

    // Proceed with login if all validations pass
    try {
      // Sign in with Firebase
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed('/home'); // Navigate to home on success
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? "Login failed"; // Handle Firebase errors
      showAlert(errorMessage.value);
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  // Function to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Function to show alert messages
  void showAlert(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
