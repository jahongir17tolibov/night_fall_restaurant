class TablesPasswordResponse {
  final int tableNumber;
  final String tablePassword;

  TablesPasswordResponse({required this.tableNumber, required this.tablePassword});

  Map<String, dynamic> toMap() => <String, dynamic>{
        'tableNumber': tableNumber,
        'tablePassword': tablePassword,
      };

  factory TablesPasswordResponse.fromMap(Map<String, dynamic> map) =>
      TablesPasswordResponse(
        tableNumber: map['tableNumber'],
        tablePassword: map['tablePassword'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TablesPasswordResponse &&
          tableNumber == other.tableNumber &&
          tablePassword == other.tablePassword;

  @override
  int get hashCode => tableNumber.hashCode ^ tablePassword.hashCode;
}
