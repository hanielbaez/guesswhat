import 'package:guess_what/core/services/auth.dart';
import 'package:guess_what/core/services/db.dart';
import 'package:provider/provider.dart';

List<SingleChildCloneableWidget> providers = [
  ...independentServices,
  ...dependentServices,

];

List<SingleChildCloneableWidget> independentServices = [
  Provider.value(value: DatabaseServices()),
];
List<SingleChildCloneableWidget> dependentServices = [
  ProxyProvider<DatabaseServices, AuthenticationServices>(
    builder: (context, dataBase, authenticationServices) =>
        AuthenticationServices(dataBase: dataBase),
  )
];


