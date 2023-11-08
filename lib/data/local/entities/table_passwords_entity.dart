// ignore_for_file: constant_identifier_names

import 'package:night_fall_restaurant/data/remote/model/tables_password_response.dart';

class TablePasswordsEntity {
  static const String CM_ID = "id";
  static const String CM_TABLE_NUMBER = "table_number";
  static const String CM_TABLE_PASSWORD = "table_password";
  static const String TABLE_NAME = "tables_password_entity";

  final int? id;
  final int tableNumber;
  final String tablePassword;

  TablePasswordsEntity({
    this.id,
    required this.tableNumber,
    required this.tablePassword,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        CM_ID: id,
        CM_TABLE_NUMBER: tableNumber,
        CM_TABLE_PASSWORD: tablePassword,
      };

  factory TablePasswordsEntity.fromMap(Map<String, dynamic> map) =>
      TablePasswordsEntity(
        id: map[CM_ID],
        tableNumber: map[CM_TABLE_NUMBER],
        tablePassword: map[CM_TABLE_PASSWORD],
      );

  factory TablePasswordsEntity.fromTablesPasswordResponse({
    required TablesPasswordResponse tablesResponse,
  }) {
    return TablePasswordsEntity(
      tableNumber: tablesResponse.tableNumber,
      tablePassword: tablesResponse.tablePassword,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TablePasswordsEntity &&
          id == other.id &&
          tableNumber == other.tableNumber &&
          tablePassword == other.tablePassword;

  @override
  int get hashCode =>
      id.hashCode ^ tableNumber.hashCode ^ tablePassword.hashCode;
}
