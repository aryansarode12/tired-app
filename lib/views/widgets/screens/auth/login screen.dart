import 'package:flutter/material.dart';
import 'package:tired/constants.dart';
import 'package:tired/views/widgets/screens/auth/signup%20screen.dart';
import 'package:tired/views/widgets/text%20input%20field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MemesBook',
              style: TextStyle(
                fontSize: 35,
                color: buttonColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextInputField(
                controller: _emailcontroller,
                labelText: 'Email',
                icon: Icons.email,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextInputField(
                controller: _passwordcontroller,
                labelText: 'Password',
                icon: Icons.lock,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 50,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: InkWell(
                onTap: () => authController.loginUser(
                    _emailcontroller.text, _passwordcontroller.text),
                child: const Center(
                    child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                )),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Dont Have An Account ? ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignupScreen(),
                        )),
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 20, color: buttonColor),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
