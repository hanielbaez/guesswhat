
import 'package:Tekel/core/services/auth.dart';
import 'package:Tekel/core/services/db.dart';
import 'package:Tekel/core/services/location.dart';
import 'package:provider/provider.dart';

List<SingleChildCloneableWidget> providers = [
  ...independentServices,
  ...dependentServices,
];

List<SingleChildCloneableWidget> independentServices = [
  Provider.value(value: AuthenticationServices()),
  Provider.value(value: LocationServices()),
];
List<SingleChildCloneableWidget> dependentServices = [
  ProxyProvider<AuthenticationServices, DatabaseServices>(
    builder: (context, auth, db) => DatabaseServices(auth: auth),
  )
];

List<SingleChildCloneableWidget> uiConsumableProviders = [];
