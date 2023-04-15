import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_note/Screens/Home.dart';

class NewLog extends StatefulWidget {
  const NewLog({Key? key}) : super(key: key);

  @override
  _NewLogState createState() => _NewLogState();
}

class _NewLogState extends State<NewLog> {
  TextEditingController emailControls = TextEditingController();
  TextEditingController passControls = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailControls.dispose();
    passControls.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emailForm = TextFormField(
      autofocus: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      controller: emailControls,
      validator: (value) {
        if (value!.isEmpty) {
          return ('Please Enter Your Email');
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailControls.text = value!;
      },
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color(0xff7e4f32))),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          prefixIcon: Icon(
            Icons.email,
            color: Color(0xff524432),
          ),
          hintText: 'Enter Email',
          hintStyle: TextStyle(fontFamily: 'Neon'),
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
    final passForm = TextFormField(
      textInputAction: TextInputAction.next,
      obscureText: _isObscure,
      controller: passControls,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) {
        passControls.text = value!;
      },
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color(0xff7e4f32))),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          suffixIcon: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
                color: Color(0xff7e4f32),
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              }),
          prefixIcon: Icon(
            Icons.lock,
            color: Color(0xff524432),
          ),
          hintText: 'Enter Password',
          hintStyle: TextStyle(fontFamily: 'Neon'),
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
    return Scaffold(
        backgroundColor: Color(0xffEDE6E2),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                child: Column(children: <Widget>[
              emailForm,
              SizedBox(
                height: 10,
              ),
              passForm,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 18,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Forget Password?',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontFamily: 'Neon'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: ElevatedButton(
                    onPressed: () {
                      signIn(emailControls.text, passControls.text);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffd76633),
                        fixedSize: const Size(400, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                          fontFamily: 'Neon',
                          color: Colors.white,
                          fontSize: 20),
                    )),
              ),
            ])),
          ))
        ])));
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MyHome())),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
}
