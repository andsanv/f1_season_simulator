import 'dart:io';
import 'dart:math';

import 'helpers.dart';



const double carDefaultStat = 0.825;



class Aero {
  //attributes
  double _downforce = -1;
  double _efficiency = -1;

  //constructors
  Aero(double downforce, double efficiency) {
    this._downforce = (isValid(downforce)) ? downforce : defaultStat;
    this._efficiency = (isValid(efficiency)) ? efficiency : defaultStat;
  }

  //methods
  
  //setters
  void set downforce(double value) => (isValid(value)) ? roundTo2Decimals(value) : defaultStat;
  void set efficiency(double value) => (isValid(value)) ? roundTo2Decimals(value) : defaultStat;

  //getters
  double get downforce => this._downforce;
  double get efficiency => this._efficiency;
}




class Car {
  //attributes
  double _engine = -1;
  Aero _aero = Aero(-1, -1);
  double _chassis = -1;
  double _reliability = -1;


  //constructors
  Car({double engine = defaultStat, double downforce = defaultStat, double efficiency = defaultStat,
               double chassis = defaultStat, double reliability = defaultStat}) {
    this._engine = (isValid(engine)) ? roundTo2Decimals(engine) : defaultStat;
    this._chassis = (isValid(chassis)) ? roundTo2Decimals(chassis) : defaultStat;
    this._reliability = (isValid(reliability)) ? roundTo2Decimals(reliability) : defaultStat;

    double d = (isValid(downforce)) ? roundTo2Decimals(downforce) : defaultStat;
    double e = (isValid(efficiency)) ? roundTo2Decimals(efficiency) : defaultStat;
    this._aero = Aero(d, e);
  }
  
  Car.Random({double engine = -1, double downforce = -1, double efficiency = -1, double chassis = -1,
              double reliability = -1}) {
    this._engine = (isValid(engine)) ? roundTo2Decimals(engine) : getRandomStat(carDefaultStat);
    this._chassis = (isValid(chassis)) ? roundTo2Decimals(chassis) : getRandomStat(carDefaultStat);
    this._reliability = (isValid(reliability)) ? roundTo2Decimals(reliability) : getRandomStat(carDefaultStat);

    double d = (isValid(downforce)) ? roundTo2Decimals(downforce) : getRandomStat(carDefaultStat);
    double e = (isValid(efficiency)) ? roundTo2Decimals(efficiency) : getRandomStat(carDefaultStat);
    this._aero = Aero(d, e);
  }

  Car.Official(String officialTeamName) {
    File file = File(officialCarsCsvPath);
    List<String> lines = file.readAsLinesSync();

    for(int i = 1; i < 11; i++) {
      List<String> words = lines[i].split(',');

      if(words[1].replaceAll(' ', '').toLowerCase() == officialTeamName.replaceAll(' ', '').toLowerCase()) {
        this._engine = double.parse(words[2]);
        this._aero = Aero(double.parse(words[4]), double.parse(words[3]));
        this._chassis = double.parse(words[5]);
        this.reliability = double.parse(words[6]);
        return;
      }

      Car randomCar = Car.Random();
      this._engine = randomCar.engine;
      this._aero = randomCar.aero;
      this._chassis = randomCar.chassis;
      this._reliability = randomCar.reliability;
    }
  }


  //methods


  //setters
  void set engine(double value) => (isValid(value)) ? roundTo2Decimals(value) : defaultStat;
  void set aero(Aero value)
    => (isValid(value.downforce) && isValid(value.efficiency)) ? value : Aero(defaultStat, defaultStat);
  void set chassis(double value) => (isValid(value)) ? roundTo2Decimals(value) : defaultStat;
  void set reliability(double value) => (isValid(value)) ? roundTo2Decimals(value) : defaultStat;


  //getters
  double get engine => this._engine;
  double get downforce => this._aero.downforce;
  double get efficiency => this._aero.efficiency;
  Aero get aero => this._aero;
  double get chassis => this._chassis;
  double get reliability => this._reliability;
}