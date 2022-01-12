import 'package:flutter/material.dart';
import 'package:the_baby_shop_app/constants/colors.dart';
import 'package:the_baby_shop_app/services/auth_services.dart';

import '../app.dart';

class SignUpScreen extends StatefulWidget {
  /// Callback for when this form is submitted successfully. Parameters are (email, password)
  final Function(String name, String email, String password) onSubmitted;

  const SignUpScreen({this.onSubmitted, Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String name, email, password, confirmPassword;
  String nameError, emailError, passwordError;
  Function(String name, String email, String password) get onSubmitted =>
      widget.onSubmitted;

  @override
  void initState() {
    super.initState();
    name = "";
    email = "";
    password = "";
    confirmPassword = "";

    nameError = null;
    emailError = null;
    passwordError = null;
  }

  void resetErrorText() {
    setState(() {
      nameError = null;
      emailError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();

    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    RegExp pwdExp = RegExp(r"^.{6,}$");

    bool isValid = true;
    if (name.isEmpty) {
      setState(() {
        nameError = "Name is required";
      });
      isValid = false;
    }

    if (email.isEmpty || !emailExp.hasMatch(email)) {
      setState(() {
        emailError = "Email is invalid";
      });
      isValid = false;
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        passwordError = "Please enter a password";
      });
      isValid = false;
    }
    if (password != confirmPassword) {
      setState(() {
        passwordError = "Passwords do not match";
      });
      isValid = false;
    }

    if (!pwdExp.hasMatch(password) && !pwdExp.hasMatch(confirmPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password should be at least 6 characters.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      isValid = false;
    }

    if (isValid) {
      createAccount(name, email, password).then((user) {
        if (user != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TheBabyShopApp()));
          // print('Account created successfully');
        } else {
          isValid = false;
          final snackbar = SnackBar(
            content: const Text(
                'An error occurred, you might have registered before.'),
            action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      });
    }

    return isValid;
  }

  void submit() {
    if (validate()) {
      if (onSubmitted != null) {
        onSubmitted(name, email, password);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * .12),
            const Text(
              "Create Account,",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * .01),
            Text(
              "Sign up to get started!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(.6),
              ),
            ),
            SizedBox(height: screenHeight * .12),
            InputField(
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              labelText: "Name",
              errorText: nameError,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              labelText: "Email",
              errorText: emailError,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              labelText: "Password",
              errorText: passwordError,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  confirmPassword = value;
                });
              },
              onSubmitted: (value) => submit(),
              labelText: "Confirm Password",
              errorText: passwordError,
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(
              height: screenHeight * .075,
            ),
            FormButton(
              text: "Sign Up",
              onPressed: submit,
            ),
            SizedBox(
              height: screenHeight * .125,
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: RichText(
                text: const TextSpan(
                  text: "I'm already a member, ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Sign In",
                      style: TextStyle(
                        color: kSecondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  const FormButton({this.text = "", this.onPressed, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed as void Function(),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        primary: kSecondaryColor,
        padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String labelText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final String errorText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool autoFocus;
  final bool obscureText;
  const InputField(
      {this.labelText,
      this.onChanged,
      this.onSubmitted,
      this.errorText,
      this.keyboardType,
      this.textInputAction,
      this.autoFocus = false,
      this.obscureText = false,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autoFocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      cursorColor: Colors.black,
      obscureText: obscureText,
      decoration: InputDecoration(
        focusColor: kSecondaryColor,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: kSecondaryColor,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
