import 'package:flutter/material.dart';  // Provides Flutter's UI components for building the app's interface.
import 'package:http/http.dart' as http;  // Allows making HTTP requests to external services.
import 'dart:convert';  // Provides utilities for encoding and decoding data, such as UTF-8 encoding.
import 'package:crypto/crypto.dart';  // Provides cryptographic algorithms, such as MD5, for hashing data.

void main() {
  runApp(MyApp());  // Launch the Flutter application by calling the runApp function with MyApp as the root widget.

  // Test Case 1: Hardcoded Secret
  String apiKey = '12345-abcde-67890-fghij';  // Example of a hardcoded API key, which is a security risk.
  print('API Key: $apiKey');  // Output the hardcoded API key to the console.

  // Test Case 2: Insecure HTTP Call
  fetchData();  // Demonstrate an insecure HTTP request by calling the fetchData function.

  // Test Case 3: Weak Encryption Usage
  hashPassword('mypassword');  // Demonstrate weak encryption using the MD5 algorithm by calling the hashPassword function.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Security Assessment Demo',  // Set the title of the app.
      theme: ThemeData(
        primarySwatch: Colors.blue,  // Define the primary color theme for the app.
      ),
      home: MyHomePage(),  // Set MyHomePage as the home page of the app.
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security Assessment Demo'),  // Set the title of the app bar.
      ),
      body: Center(
        child: Text(
          'Check the console output for security assessment results.',  // Display a message on the home screen.
          style: TextStyle(fontSize: 18),  // Set the text size to 18.
        ),
      ),
    );
  }
}

void fetchData() async {
  // Example of an insecure HTTP call (Test Case 2)
  var response = await http.get(Uri.parse('http://example.com/api/data'));  // Make an HTTP GET request to an insecure (HTTP) URL.
  print('Response status: ${response.statusCode}');  // Output the HTTP response status code to the console.
}

void hashPassword(String password) {
  // Example of weak encryption using MD5 (Test Case 3)
  var bytes = utf8.encode(password);  // Convert the password to a list of UTF-8 encoded bytes.
  var digest = md5.convert(bytes);  // Hash the bytes using the MD5 algorithm.
  print('MD5 hash: $digest');  // Output the resulting MD5 hash to the console.
}