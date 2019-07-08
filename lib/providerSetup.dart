import 'package:guess_what/core/services/db.dart';
import 'package:provider/provider.dart';

List<SingleChildCloneableWidget> providers = [
  ...independentServices,
];

List<SingleChildCloneableWidget> independentServices = [
  Provider.value(value: DatabaseServices())
];
List<SingleChildCloneableWidget> dependentServices = [];
