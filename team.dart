import 'car.dart';
import 'driver.dart';


const String DEFAULT_TEAM_NAME = "DEFAULT_TEAM_NAME";


class Team {
  //attributes
  String _team_name = DEFAULT_TEAM_NAME;
  late List<Driver> _drivers;
  late Car _car;

  //constructors
  Team(String team_name, {List<Driver>? drivers, Car? car}) {
    this._team_name = team_name;
    if(drivers != null) this._drivers = drivers;
    else this.drivers = [];

    if(car != null) this._car = car;
    else this._car = Car.Random();
  }

  //settters
  void set team_name(String value) => this._team_name = value;
  void set drivers(List<Driver> value) => this._drivers = value;
  void set car(Car value) => this._car = car;

  //getters
  String get team_name => this._team_name;
  List<Driver> get drivers => this._drivers;
  Car get car => this._car;
}