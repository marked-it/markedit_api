import 'package:markedit_api/markedit_api.dart';

/// A [Configuration] to represent a database connection configuration.
class SmtpServerConfiguration extends Configuration {
  /// Default constructor.
  SmtpServerConfiguration();

  SmtpServerConfiguration.fromFile(File file) : super.fromFile(file);

  SmtpServerConfiguration.fromString(String yaml) : super.fromString(yaml);

  SmtpServerConfiguration.fromMap(Map<dynamic, dynamic> yaml)
      : super.fromMap(yaml);

  /// A named constructor that contains all of the properties of this instance.
  SmtpServerConfiguration.withConnectionInfo(this.host, this.port, this.username, this.password,
      {bool ignoreBadCertificates = false, bool useSSL = true}) {
    this.ignoreBadCertificates = ignoreBadCertificates;
    this.useSSL = useSSL;
  }

  /// The host of the SMTP server to connect to.
  ///
  /// This property is required.
  String host;

  /// The port of the SMTP server to connect to.
  ///
  /// This property is required.
  int port;

  /// A username for authenticating to the database.
  ///
  /// This property is required.
  String username;

  /// A password for authenticating to the database.
  ///
  /// This property is required.
  String password;

  /// Ignore bad SSL certificates on the SMTP server.
  ///
  /// This property is optional. Defaults to false
  @optionalConfiguration
  bool ignoreBadCertificates;

  /// Use SSL to connect to the SMTP server.
  ///
  /// This property is optional. Defaults to true
  @optionalConfiguration
  bool useSSL;
}