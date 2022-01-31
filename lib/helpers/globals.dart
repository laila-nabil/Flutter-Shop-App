import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


const _terminalApi = String.fromEnvironment("api_key");
var apiKey = kIsWeb ? _terminalApi : env['API_KEY'];