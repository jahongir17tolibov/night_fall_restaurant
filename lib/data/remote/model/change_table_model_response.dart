class ChangeTableModelResponse {
  final int tableNumber;
  final String tablePassword;

  ChangeTableModelResponse({required this.tableNumber, required this.tablePassword});

  Map<String, dynamic> toMap() => <String, dynamic>{
        'tableNumber': tableNumber,
        'tablePassword': tablePassword,
      };

  factory ChangeTableModelResponse.fromMap(Map<String, dynamic> map) =>
      ChangeTableModelResponse(
        tableNumber: map['tableNumber'],
        tablePassword: map['tablePassword'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangeTableModelResponse &&
          tableNumber == other.tableNumber &&
          tablePassword == other.tablePassword;

  @override
  int get hashCode => tableNumber.hashCode ^ tablePassword.hashCode;
}
