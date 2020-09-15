import 'package:markedit_api/markedit_api.dart';

Future main() async {
  // Load the configuration file
  final _config = MarkeditApiConfiguration('config.yaml');

  // Configure the application with the configuration file
  final app = Application<MarkeditApiChannel>()
      ..options.configurationFilePath = "config.yaml"
      ..options.port = _config.port;

  // Start the processes that run the API
  await app.start(numberOfInstances: _config.threads ?? Platform.numberOfProcessors ~/ 2);

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}