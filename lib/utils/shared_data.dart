import 'dart:async';

import '../services/establishments_service.dart';

class SharedData {

  static final Completer<void> allEstablishmentsCompleter = Completer<void>();

  static late List<Establishment> allEstablishments;

  static Future<void> get allEstablishmentsInitializationDone => allEstablishmentsCompleter.future;


}