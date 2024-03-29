import 'package:flutter/material.dart';
import 'package:toy_trader/screens/HomeScreen.dart';

import '../../firebase_services/AuthService.dart';
import 'RegistrationScreen.dart';

class SignInScreen extends StatefulWidget {
  final Function toggleView;

  const SignInScreen({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  //text field state
  String email = '';
  String pw = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: const Color(0xffC4DFCB),
        appBar: AppBar(
            title: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 40, 0),
                child: Image.asset('assets/images/logo.png')),
            actions: <Widget>[
              Directionality(
                  textDirection: TextDirection.rtl,
                  child:
                  TextButton.icon(
                      onPressed: () {
                        widget.toggleView();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegistrationScreen(toggleView: widget.toggleView,)),
                        );
                      },
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ))
              )

            ]
            // backgroundColor: Colors.white,
            ),
        body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Column(children: <Widget>[
                  Image.asset('assets/images/logo.png',
                      width: 350, height: 175),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Email',
                            ),
                            validator: (val) =>
                                val!.isEmpty ? 'Email must not be empty' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            }),
                        SizedBox(height: 20.0),
                        TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Password',
                            ),
                            validator: (val) => val!.length < 2
                                ? 'Password must be > 2 chars'
                                : null,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => pw = val);
                            }),
                        SizedBox(height: 60.0),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.fromLTRB(50, 10, 50, 10),
                                elevation: 12.0,
                                textStyle: const TextStyle(
                                    color: Colors.white, fontSize: 16)),
                            child: const Text('Sign in'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                dynamic result =
                                    await authService.signIn(email, pw);
                                if (result == null) {
                                  setState(() => error = 'Couldnt sign in...');
                                }
                                else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomeScreen(),
                                    ),
                                  );
                                }
                              }
                            }),
                        SizedBox(height: 20.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        )
                      ],
                    ),
                  ),
                ]))));
  }
}
