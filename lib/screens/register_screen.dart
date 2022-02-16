import 'package:flutter/material.dart';
import 'package:flutter_login/providers/login_form_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login/ui/input_decorations.dart';
import 'package:flutter_login/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 150),
            CardContainer(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Registro',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ChangeNotifierProvider(
                    create: (_) => LoginFormProvider(),
                    child: _LoginForm(),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                      Colors.deepOrange.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(StadiumBorder())),
              child: const Text(
                '¿Ya tienes cuenta?',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      )),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress, // teclado con @
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'alberto@precursorsinaptico.com',
                  labelText: 'Correo electronico',
                  prefixIcon: Icons.alternate_email_rounded),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'No es un email valido';
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress, // teclado con @
              decoration: InputDecorations.authInputDecoration(
                  hintText: '******',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe ser de mas de 6 caracteres';
              },
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Enviando...' : 'Ingresar',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        if (!loginForm.isValidForm()) return;
                        loginForm.isLoading = true;

                        await Future.delayed(const Duration(seconds: 2));
                        loginForm.isLoading = false;
                        Navigator.pushReplacementNamed(context, 'home');
                      })
          ],
        ),
      ),
    );
  }
}
