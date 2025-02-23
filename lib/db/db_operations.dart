// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/foundation.dart';
import 'package:miscratch/models/cards_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

class DbOperations {
  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'tarjetas.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE tarjetas(id INTEGER PRIMARY KEY AUTOINCREMENT, tarjeta TEXT UNIQUE, pin TEXT, pin64 TEXT)');
    }, version: 1);
  }

  static Future<Future<int>> insert(Tarjeta tarjeta) async {
    Database database = await _openDB();
    return database.insert(
      "tarjetas",
      tarjeta.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  static Future<List<Tarjeta>> tarjetas() async {
    Database database = await _openDB();

    final List<Map<String, dynamic>> tarjetasMaps =
        await database.query('tarjetas');

    return List.generate(
        tarjetasMaps.length,
        (i) => Tarjeta(
            id: tarjetasMaps[i]['id'],
            tarjeta: tarjetasMaps[i]['tarjeta'],
            pin: tarjetasMaps[i]['pin'],
            pin64: tarjetasMaps[i]['pin64']));
  }

  static Future<void> deleteTarjeta(int id) async {
    // Get a reference to the database.
    Database database = await _openDB();

    await database.delete(
      'tarjetas',
      // Use a `where` clause to delete a specific card.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  static Future<List<Tarjeta>> searchTarjeta(String text) async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> searchMaps = await database
        .rawQuery("SELECT * FROM tarjetas WHERE tarjeta LIKE '%${text}%'");

    if (kDebugMode) {
      print(searchMaps.toString());
    }

    return List.generate(
        searchMaps.length,
        (i) => Tarjeta(
            id: searchMaps[i]['id'], tarjeta: searchMaps[i]['tarjeta']));
  }
}
