part of '../flog.dart';

enum AnsiColors {
  // Regular Colors
  kDefault('\x1B[0m'),
  black('\x1B[30m'),
  red('\x1B[31m'),
  green('\x1B[32m'),
  yellow('\x1B[33m'),
  blue('\x1B[34m'),
  purple('\x1B[35m'),
  cyan('\x1B[36m'),
  white('\x1B[37m'),

  // Bright Colors
  brightBlack('\x1B[90m'),
  brightRed('\x1B[91m'),
  brightGreen('\x1B[92m'),
  brightYellow('\x1B[93m'),
  brightBlue('\x1B[94m'),
  brightPurple('\x1B[95m'),
  brightCyan('\x1B[96m'),
  brightWhite('\x1B[97m');

  // // Background Colors
  // bgBlack('\x1B[40m'),
  // bgRed('\x1B[41m'),
  // bgGreen('\x1B[42m'),
  // bgYellow('\x1B[43m'),
  // bgBlue('\x1B[44m'),
  // bgPurple('\x1B[45m'),
  // bgCyan('\x1B[46m'),
  // bgWhite('\x1B[47m'),

  // // Bright Background Colors
  // bgBrightBlack('\x1B[100m'),
  // bgBrightRed('\x1B[101m'),
  // bgBrightGreen('\x1B[102m'),
  // bgBrightYellow('\x1B[103m'),
  // bgBrightBlue('\x1B[104m'),
  // bgBrightPurple('\x1B[105m'),
  // bgBrightCyan('\x1B[106m'),
  // bgBrightWhite('\x1B[107m');

  const AnsiColors(this.code);

  final String code;

  String apply(String text) => '$code$text${kDefault.code}';
}
