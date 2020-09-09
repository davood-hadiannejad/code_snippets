import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/http_exception.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  double _formProgress = 0;
  var _isLoading = false;

  @override
  void dispose() {
    _passwordTextController.dispose();
    _usernameTextController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Oooops...'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      // Log user in
      await Provider.of<Auth>(context, listen: false).login(
        _authData['email'],
        _authData['password'],
      );
    } on HttpException catch (error) {
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _formProgress),
          SizedBox(
            height: 12,
          ),
          Text('Anmeldung', style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: EdgeInsets.all(24.0),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: InputDecoration(hintText: 'Benutzername / Email'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Bitte Benutzername oder Email eingeben';
                }
                return null;
              },
              onSaved: (value) {
                _authData['email'] = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: TextFormField(
              controller: _passwordTextController,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Passwort'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Bitte Passwort eingeben';
                }
                return null;
              },
              onSaved: (value) {
                _authData['password'] = value;
              },
            ),
          ),
          SizedBox(
            height: 12,
          ),
          if (_isLoading)
            CircularProgressIndicator()
          else
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: _submit,
              child: Text(
                'Anmelden',
                style: TextStyle(fontSize: 18),
              ),
            ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
