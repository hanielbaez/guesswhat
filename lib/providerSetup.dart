import 'package:Tekel/core/services/auth.dart';
import 'package:Tekel/core/services/db.dart';
import 'package:provider/provider.dart';

List<SingleChildCloneableWidget> providers = [
  ...independentServices,
  ...dependentServices,
];

List<SingleChildCloneableWidget> independentServices = [
  Provider.value(value: DatabaseServices()),
  Provider.value(value: AuthenticationServices()),
];
List<SingleChildCloneableWidget> dependentServices = [
];

List<SingleChildCloneableWidget> uiConsumableProviders = [
 
];
