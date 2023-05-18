import 'dart:io';
import 'dart:math';
import 'distribution.dart';


const double default_stat = 0.75;
const String official_cars_path = "cars.csv";


bool stat_is_valid(double stat) => 0 <= stat && stat <= 1;
double round_to_2_decimals(double value) => (value * 100).round() / 100;



class Aero {
  //attributes
  late double _downforce;
  late double _efficiency;

  //constructors
  Aero(double downforce, double efficiency) {
    this._downforce = downforce;
    this._efficiency = efficiency;
  }

  //methods
  
  //setters
  void set downforce(double value) {
    if(stat_is_valid(downforce)) this._downforce = round_to_2_decimals(downforce);
    else this._downforce = default_stat;
  }
  
  void set efficiency(double value) {
    if(stat_is_valid(efficiency)) this._downforce = round_to_2_decimals(efficiency);
    else this._efficiency = default_stat;
  }

  //getters
  double get downforce => this._downforce;
  double get efficiency => this._efficiency;
}




class Car {
  //attributes
  late double _engine;
  late Aero _aero;
  late double _chassis;
  late double _reliability;

  //constructors
  Car(double engine, double downforce, double efficiency, double chassis, double reliability) {
    if(stat_is_valid(engine)) this._engine = round_to_2_decimals(engine);
    else this._engine = default_stat;

    if(stat_is_valid(downforce) && stat_is_valid(efficiency)) this._aero = Aero(downforce, efficiency);
    else this._aero = Aero(default_stat, default_stat);

    if(stat_is_valid(chassis)) this._chassis = round_to_2_decimals(chassis);
    else this._chassis = default_stat;

    if(stat_is_valid(reliability)) this._reliability = round_to_2_decimals(reliability);
    else this._reliability = default_stat;
  }
  
  Car.Random() {
    double get_random_stat() => (100 * min(max(0.50, get_gaussian_double(0.825, 0.005)), 0.99)).round() / 100;
    
    this._engine = get_random_stat();
    this._aero = Aero(get_random_stat(), get_random_stat());
    this._chassis = get_random_stat();
    this._reliability = get_random_stat();
  }

  //methods

  //setters
  void set engine(double value) {
    if(stat_is_valid(value)) this._engine = round_to_2_decimals(value);
    else this._engine = default_stat;
  }
  
  void set downforce(double value) {
    if(stat_is_valid(value)) this._aero.downforce = round_to_2_decimals(value);
    else this._aero.downforce = default_stat;
  }
  
  void set efficiency(double value) {
    if(stat_is_valid(value)) this._aero.efficiency = round_to_2_decimals(value);
    else this._aero.efficiency = default_stat;
  }

  void set chassis(double value) {
    if(stat_is_valid(value)) this._chassis = round_to_2_decimals(value);
    else this._chassis = default_stat;
  }
  
  void set reliability(double value) {
    if(stat_is_valid(value)) this._reliability = round_to_2_decimals(value);
    else this._reliability = default_stat;
  }

  //getters
  double get engine => this._engine;
  double get downforce => this._aero.downforce;
  double get efficiency => this._aero.efficiency;
  Aero get aero => this._aero;
  double get chassis => this._chassis;
  double get reliability => this._reliability;
}