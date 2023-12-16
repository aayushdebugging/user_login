import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue, // Light primary color
        colorScheme: ThemeData.light().colorScheme.copyWith(
              secondary: Colors.cyanAccent, // Accent color
            ),
        scaffoldBackgroundColor: Colors.grey[100], // Light background color
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyanAccent, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue[700]!, width: 1.0),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey[900], // Dark primary color
        colorScheme: ThemeData.dark().colorScheme.copyWith(
              secondary: Colors.cyanAccent, // Accent color
            ),
        scaffoldBackgroundColor: Colors.grey[900]!, // Dark background color
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyanAccent, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey[700]!, width: 1.0),
          ),
        ),
      ),
      themeMode: ThemeMode.system, // Use system theme mode (light/dark)
      home: SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyPasswordController =
      TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  Map<String, Map<String, String>> users = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _verifyPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Verify Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _handleSignup,
              child: Text('Sign Up'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                textStyle: TextStyle(fontSize: 18.0),
                primary: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage(users)),
                );
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                textStyle: TextStyle(fontSize: 18.0),
                primary: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSignup() async {
    String name = _nameController.text;
    String username = _usernameController.text;
    String phone = _phoneController.text;
    String password = _passwordController.text;
    String verifyPassword = _verifyPasswordController.text;

    if (_validateInputs()) {
      if (!users.containsKey(username)) {
        // Generate and send OTP (For simplicity, we are not sending OTP in this example)
        // Replace this part with your actual OTP service integration
        // You can use packages like 'otp' or integrate with SMS APIs for OTP verification
        // For now, we're just using a placeholder OTP "123456"
        String generatedOtp = '123456';

        // Show OTP verification dialog
        bool otpVerified = await _showOtpDialog(generatedOtp);

        if (otpVerified) {
          // Sign up the user
          users[username] = {
            'name': name,
            'phone': phone,
            'password': password,
          };

          print('User signed up: $username');
          _showMessage('Sign up successful. You can now log in.');
        } else {
          _showMessage('OTP verification failed.');
        }
      } else {
        _showMessage('Username already exists. Please choose a different one.');
      }
    }
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _verifyPasswordController.text.isEmpty) {
      _showMessage('Please fill in all fields.');
      return false;
    }

    if (_passwordController.text != _verifyPasswordController.text) {
      _showMessage('Passwords do not match.');
      return false;
    }

    return true;
  }

  Future<bool> _showOtpDialog(String generatedOtp) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('OTP Verification'),
          content: Column(
            children: [
              Text('Enter the OTP sent to your phone: $generatedOtp'),
              SizedBox(height: 10.0),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false); // OTP verification failed
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String enteredOtp = _otpController.text;
                Navigator.of(context)
                    .pop(enteredOtp == generatedOtp); // OTP verification result
              },
              child: Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final Map<String, Map<String, String>> users;

  LoginPage(this.users);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                textStyle: TextStyle(fontSize: 18.0),
                primary: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (widget.users.containsKey(username)) {
      Map<String, String> userInfo = widget.users[username]!;
      if (userInfo['password'] == password) {
        // Password matches, navigate to the home or dashboard screen
        // Replace this line with the navigation logic for your app
        print('Login successful for user: $username');
      } else {
        _showMessage('Incorrect password. Please try again.');
      }
    } else {
      _showMessage('User not found. Please sign up.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
