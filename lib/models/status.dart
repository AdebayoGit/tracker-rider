class Success {
  int code;
  Object response;
  Success({this.code = 200, required this.response});
}

class Failure {
  int code;
  Object errorResponse;
  Failure({required this.code, required this.errorResponse});
}

class Error{
  int code;
  Object message;
  Error({required this.code, required this.message});
}