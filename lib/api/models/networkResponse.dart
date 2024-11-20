class NetworkResponse {
  final bool isSuccess; // Indicates success status
  final int statusCode; // HTTP status code
  final dynamic responseData; // Holds response data (if any)
  final String errorMessage; // Holds error message (if any)

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.responseData, // Optional: dynamic to allow flexible response types
    this.errorMessage = 'Something went wrong!', // Default error message
  });
}
