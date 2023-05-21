import 'car.dart';
import 'driver.dart';

import 'helpers.dart';


const String defaultTeamName = "defaultTeamName";
const List<String> officialTeamNames = ["redbull", "ferrari", "mercedes", "alpine", "mclaren", "alfaromeo", "astonmartin",
                                        "haas", "alphatauri", "williams"];



class Team {
  //attributes
  String _teamName = defaultTeamName;
  late List<Driver> _drivers;
  late Car _car;

  //constructors
  Team(String teamName, {List<Driver>? drivers, Car? car}) {
    this._teamName = teamName.replaceAll(' ', '').toLowerCase();

    this._drivers = (drivers != null && drivers.length <= 2) ? drivers : [];

    if(inList(officialTeamNames, this._teamName)) this._car = Car.Official(this._teamName);
    else if(car != null) this._car = car;
    else this._car = Car.Random();
  }

  //setters
  void set teamName(String value) => this._teamName = value;
  void set drivers(List<Driver>? value) => (value != null && value.length <= 2) ? value : [];
  void set car(Car value) => this._car = car;

  //getters
  String get teamName => this._teamName;
  List<Driver> get drivers => this._drivers;
  Car get car => this._car;
}