class ChangeTableModel {
  final num tableNumber;
  final String tablePassword;

  ChangeTableModel({required this.tableNumber, required this.tablePassword});

  Map<String, dynamic> toMap() => <String, dynamic>{
        'tableNumber': tableNumber,
        'tablePassword': tablePassword,
      };

  factory ChangeTableModel.fromMap(Map<String, dynamic> map) =>
      ChangeTableModel(
        tableNumber: map['tableNumber'],
        tablePassword: map['tablePassword'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangeTableModel &&
          tableNumber == other.tableNumber &&
          tablePassword == other.tablePassword;

  @override
  int get hashCode => tableNumber.hashCode ^ tablePassword.hashCode;
}
