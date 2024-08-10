# Security Assessment Tool for Flutter

## Overview

This project is a Flutter application that includes a built-in security assessment tool designed to identify common security issues in Dart code. The tool analyzes the codebase for potential vulnerabilities, such as hardcoded secrets, insecure HTTP calls, and the use of weak encryption algorithms. The output is a detailed security assessment report that provides warnings and suggested fixes for each identified issue.

## Features

- *Hardcoded Secret Detection:* Identifies hardcoded secrets, such as API keys and passwords, and provides recommendations for secure storage.
- *Insecure HTTP Call Detection:* Detects the use of insecure HTTP calls (http://) and suggests switching to secure HTTPS (https://).
- *Weak Encryption Detection:* Flags the usage of weak encryption algorithms like MD5 and SHA-1, recommending stronger alternatives like SHA-256.

## Project Structure

- *lib/*: Contains the Flutter application code.
    - *main.dart:* The main entry point of the Flutter application, which also includes test cases to demonstrate the security assessment tool.
- *bin/*: Contains the security assessment tool script.
    - *security_assessment.dart:* The script that scans the Dart files and generates the security assessment report.
- *test/*: Contains test files for the Flutter application.

## Getting Started

### Prerequisites

- *Flutter SDK:* Ensure that Flutter is installed on your system. You can install it from the [official Flutter website](https://flutter.dev/get-started/install).
- *Dart SDK:* Dart is included with Flutter, but you can install it separately if needed from the [official Dart website](https://dart.dev/get-dart).

### Setup

1. *Clone the Repository:*

   ```bash
   git clone https://github.com/gp02august/security-assessment-tool.git
   cd security-assessment-tool
   
### Install Dependencies
    '''bash
     flutter pub get
     flutter run

### Running the security_asssessment.dart
    '''bash
    dart bin/security_assessment.dart