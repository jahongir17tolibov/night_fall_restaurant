import 'package:night_fall_restaurant/data/remote/model/change_table_model_response.dart';

class TablesPasswordDto {
  final int? id;
  final int tableNumber;
  final String tablePassword;

  TablesPasswordDto({
    this.id,
    required this.tableNumber,
    required this.tablePassword,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'tableNumber': tableNumber,
        'tablePassword': tablePassword,
      };

  factory TablesPasswordDto.fromMap(Map<String, dynamic> map) =>
      TablesPasswordDto(
        id: map['id'],
        tableNumber: map['tableNumber'],
        tablePassword: map['tablePassword'],
      );

  factory TablesPasswordDto.fromTablesPasswordResponse({
    required ChangeTableModelResponse tablesResponse,
  }) =>
      TablesPasswordDto(
        tableNumber: tablesResponse.tableNumber,
        tablePassword: tablesResponse.tablePassword,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TablesPasswordDto &&
          id == other.id &&
          tableNumber == other.tableNumber &&
          tablePassword == other.tablePassword;

  @override
  int get hashCode =>
      id.hashCode ^ tableNumber.hashCode ^ tablePassword.hashCode;
}
