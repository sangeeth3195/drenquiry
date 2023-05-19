import 'dart:convert';
import 'package:dr_enquiry/TextFieldExample.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;


  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text;
    String password = _passwordController.text;

    // Define API endpoint and request body
    String apiUrl = 'https://teamexapi.zsoftservices.com/api/customer/login';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, String> body = {'phone_with_code': '+91'+username, 'password': password,"fcm_token":"test"};

    // Make API request
    try {
      var response = await http.post(Uri.parse(apiUrl), headers: headers, body: jsonEncode(body));
      print(response.body);

      if (response.statusCode == 200) {
        // Login successful, navigate to next screen
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TextFieldExample()));
      } else {
        // Login failed, display error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Error'),
            content: Text('Invalid username or password.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred. Please try again later.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(kDebugMode){
      _usernameController.text='8344716194';
      _passwordController.text='123';

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}