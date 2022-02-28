class Success {
  String code;
  Object response;
  Success({this.code = '200', required this.response});
}

class Failure {
  String code;
  Object errorResponse;
  Failure({required this.code, required this.errorResponse});

  @override
  String toString(){
    return "Error: $code \n$errorResponse";
  }
}

class Error{
  String code;
  Object message;
  Error({required this.code, required this.message});
}