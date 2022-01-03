import 'package:flutter/material.dart';
import 'package:the_baby_shop_app/app.dart';
import 'package:the_baby_shop_app/constants/colors.dart';
import 'package:the_baby_shop_app/screens/sign_up.dart';
import 'package:the_baby_shop_app/services/auth_services.dart';

class SignInScreen extends StatefulWidget {
  /// Callback for when this form is submitted successfully. Parameters are (email, password)
  final Function(String email, String password) onSubmitted;

  const SignInScreen({this.onSubmitted, Key key}) : super(key: key);
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String email, password;
  String emailError, passwordError;
  Function(String email, String password) get onSubmitted => widget.onSubmitted;

  @override
  void initState() {
    super.initState();
    email = "";
    password = "";

    emailError = null;
    passwordError = null;
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();

    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    bool isValid = true;
    if (email.isEmpty || !emailExp.hasMatch(email)) {
      setState(() {
        emailError = "Email is invalid";
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = "Please enter a password";
      });
      isValid = false;
    }

    if (email.isEmpty && password.isEmpty) {
      isValid = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Email and password are required.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }

    /// Login service
    logIn(email, password).then((user) {
      if (user != null) {
        // print('Login success');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const TheBabyShopApp()));
      } else {
        isValid = false;
        final snackbar = SnackBar(
          content: const Text(
              'There is no user record corresponding to this identifier. The user may have been deleted. Your email or password may be wrongly entered.'),
          action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    });

    return isValid;
  }

  void submit() {
    if (validate()) {
      if (onSubmitted != null) {
        onSubmitted(email, password);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              SizedBox(height: screenHeight * .12),
              const Text(
                "Welcome,",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * .01),
              Text(
                "Sign in to continue!",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(.6),
                ),
              ),
              SizedBox(height: screenHeight * .12),
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
                onSubmitted: (val) => submit(),
                labelText: "Password",
                errorText: passwordError,
                obscureText: true,
                textInputAction: TextInputAction.next,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * .075,
              ),
              FormButton(
                text: "Log In",
                onPressed: submit,
              ),
              SizedBox(
                height: screenHeight * .15,
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignUpScreen(),
                  ),
                ),
                child: RichText(
                  text: const TextSpan(
                    text: "I'm a new user, ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                          color: kPrimaryColor,
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
      ),
    );
  }
}

class FormButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  const FormButton({
    Key key,
    this.text = "",
    this.onPressed,
  }) : super(key: key);

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
        primary: kPrimaryColor,
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
        focusColor: kPrimaryColor,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: kPrimaryColor,
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
