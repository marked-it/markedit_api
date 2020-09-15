import 'package:markedit_api/markedit_api.dart';

/// Configure the [Configuration] for the application.
class MarkeditApiConfiguration extends Configuration {
  MarkeditApiConfiguration(String fileName) : super.fromFile(File(fileName));

  // Database configuration
  DatabaseConfiguration database;

  // Number of threads to use
  int threads;

  // Port to run the API on
  int port;

  // SMTP Server Configuration
  SmtpServerConfiguration smtpServer;
}