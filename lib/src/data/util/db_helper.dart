import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sample_architecture/src/data/repository/db_movie_model.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String movTable = 'watched_movie';
  String movId = 'id';
  String movTitle = 'title';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    //initialize object
    if(_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if(_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'watched_movie1.db';

    var movDatabase = await openDatabase(path, version: 1, onCreate: _createDb);

    return movDatabase;
  }

  void _createDb(Database db, int newVersion) async {
      await db.execute('CREATE TABLE $movTable($movId INTEGER PRIMARY KEY AUTOINCREMENT, $movTitle TEXT)');
  }

  Future<List<Map<String, dynamic>>> getMovieMapList() async {
    Database db = await this.database;

    //var result = await db.rawQuery('SELECT * FROM $movTable order by $movId ASC');
    var result = await db.query(movTable, orderBy: '$movId ASC');
    return result;
  }

  Future<List<Movie>> getMovieList() async {
    var movieMapList = await getMovieMapList();
    int count = movieMapList.length;

    List<Movie> movieList = List<Movie>();

    for(int i = 0; i < count; i++) {
      movieList.add(Movie.fromMapObject(movieMapList[i]));
    }

    return movieList;
  }

  Future<int> insertMovie(Movie movie) async {
    Database db = await this.database;
    var result = await db.insert(movTable, movie.toMap());
    return result;
  }

  Future<int> updateMovie(Movie movie) async {
    Database db = await this.database;
    var result = await db.update(movTable, movie.toMap(), where: '$movId = ?', whereArgs: [movie.id]);
    return result;
  }

  Future<int> deleteMovie(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $movTable WHERE $movId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String,dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $movTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

}