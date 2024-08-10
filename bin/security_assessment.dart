import 'dart:io';  // Provides access to file and directory operations.
import 'package:path/path.dart' as path;  // Provides utilities for handling and manipulating file system paths.
import 'package:analyzer/dart/analysis/utilities.dart';  // Provides utilities for parsing and analyzing Dart code.
import 'package:analyzer/dart/ast/ast.dart';  // Provides classes representing the Abstract Syntax Tree (AST) of Dart code.
import 'package:analyzer/dart/ast/visitor.dart';  // Provides visitor classes for traversing the AST.

void main(List<String> args) {
  // Get the root directory of the project.
  final projectDir = Directory.current.path;
  final reportPath = path.join(projectDir, 'security_assessment_report.txt');  // Path to the security assessment report.

  // Backup the existing report if it exists.
  if (File(reportPath).existsSync()) {
    final backupReportPath = path.join(
      projectDir,
      'security_assessment_report_backup_${DateTime.now().toIso8601String().replaceAll(':', '-')}.txt',
    );  // Create a backup of the existing report with a timestamp.
    File(reportPath).renameSync(backupReportPath);  // Rename the existing report to the backup path.
    print('Previous report backed up as $backupReportPath');
  }

  print('Starting security assessment for Flutter project at $projectDir');

  // Initialize the report with a header.
  final report = StringBuffer();
  report.writeln('Security Assessment Report');
  report.writeln('==========================');
  report.writeln('Project Directory: $projectDir');
  report.writeln('');

  // List all Dart files in the project directory recursively.
  final dartFiles = Directory(projectDir)
      .listSync(recursive: true)
      .where((entity) => entity is File && entity.path.endsWith('.dart'))
      .map((entity) => entity.path)
      .toList();

  // Analyze each Dart file.
  for (final filePath in dartFiles) {
    final fileContent = File(filePath).readAsStringSync();  // Read the content of the Dart file.
    final parseResult = parseString(content: fileContent);  // Parse the file content into an AST.
    final compilationUnit = parseResult.unit;

    report.writeln('File: $filePath');
    _analyzeFile(filePath, compilationUnit, report);  // Analyze the parsed AST for security issues.
    report.writeln('');
  }

  // Save the completed report to a text file in the root directory.
  File(reportPath).writeAsStringSync(report.toString());
  print('Security assessment complete. Report saved to $reportPath');
}

// Analyze the AST of a Dart file for security issues.
void _analyzeFile(String filePath, CompilationUnit unit, StringBuffer report) {
  final visitor = SecurityAnalyzer(report);
  unit.visitChildren(visitor);  // Traverse the AST and visit each node.
}

// Custom AST visitor that checks for specific security issues.
class SecurityAnalyzer extends GeneralizingAstVisitor<void> {
  final StringBuffer report;

  SecurityAnalyzer(this.report);

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    // Check for hardcoded secrets in variable declarations.
    if (_isHardcodedSecret(node)) {
      report.writeln('  [WARNING] Hardcoded secret found in variable "${node.name.name}".');
      report.writeln('  Suggested Fix: Move sensitive data like API keys or passwords to secure storage or environment variables.\n');
    }
    super.visitVariableDeclaration(node);  // Continue visiting other nodes.
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // Check for insecure HTTP usage.
    if (_isInsecureHttpCall(node)) {
      report.writeln('  [WARNING] Insecure HTTP call found in method "${node.methodName.name}".');
      report.writeln('  Suggested Fix: Use HTTPS instead of HTTP to ensure secure communication.\n');
    }

    // Check for weak encryption usage.
    if (_isWeakEncryption(node)) {
      report.writeln('  [WARNING] Weak encryption method found in method "${node.methodName.name}".');
      report.writeln('  Suggested Fix: Replace weak algorithms like MD5 or SHA1 with stronger alternatives like SHA-256.\n');
    }

    super.visitMethodInvocation(node);  // Continue visiting other nodes.
  }

  // Determine if a variable declaration contains a hardcoded secret.
  bool _isHardcodedSecret(VariableDeclaration node) {
    final initializer = node.initializer;
    if (initializer is StringLiteral) {
      final value = initializer.stringValue ?? '';
      final secretKeywords = ['apiKey', 'password', 'secret', 'token'];  // Keywords indicating potential secrets.
      return secretKeywords.any((keyword) => node.name.name.toLowerCase().contains(keyword.toLowerCase())) &&
          value.isNotEmpty;  // Flag as a hardcoded secret if the variable name matches keywords and has a non-empty value.
    }
    return false;  // Not a hardcoded secret.
  }

  // Determine if a method invocation is an insecure HTTP call.
  bool _isInsecureHttpCall(MethodInvocation node) {
    return (node.methodName.name == 'get' || node.methodName.name == 'post')
        && node.argumentList.arguments.any((arg) => arg is StringLiteral && arg.stringValue?.startsWith('http://') == true);  // Flag HTTP requests that use "http://" instead of "https://".
  }

  // Determine if a method invocation uses weak encryption.
  bool _isWeakEncryption(MethodInvocation node) {
    final weakAlgorithms = ['MD5', 'SHA1'];  // Algorithms considered weak.
    return weakAlgorithms.any((algo) => node.methodName.name.toUpperCase().contains(algo));  // Flag if weak algorithms like MD5 or SHA1 are used.
  }
}