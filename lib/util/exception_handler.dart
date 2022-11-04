void handleException(e, StackTrace? stacktrace, {String info = ""}) {
  // Log somewhere (e.g. sentry)
  print(e.toString());
  print(stacktrace.toString());
  print(info);
}
