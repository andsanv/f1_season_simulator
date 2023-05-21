import 'dart:io';
import 'dart:math';

import 'car.dart';
import 'helpers.dart';
import 'team.dart';



//DATA STRUCTURES
List<String> names = [], surnames = [];
List<Driver> driversList = [];

enum AbilityEnum {def, bad, lacking, mediocre, decent, good}
List<AbilityEnum> abilityLevels = AbilityEnum.values;

const int driversAmount = 20, minAge = 18, maxAge = 32, defaultAge = 18, defaultCareerYears = 0;
const double minHeight = 160.0, maxHeight = 195.0, minWeight = 55.0, maxWeight = 75.0, defaultHeight = 178.5,
             defaultWeight = 65.0, driverDefaultStat = 0.75, defaultPotential = 0.83, defaultExperience = 0.5;

const String defaultName = "And", defaultSurname = "Sanv", defaultGender = "Male", defaultNationality = "Italian";



//CLASSES
class PaceStats {
  //attributes
  double _race = -1;
  double _qualifying = -1;
  double _dry = -1;
  double _wet = -1;

  //constructors
  PaceStats({double race = defaultStat, double qualifying = defaultStat, double dry = defaultStat,
             double wet = defaultStat}) {
    this._race = (isValid(race)) ? race : defaultStat;
    this._qualifying = (isValid(qualifying)) ? qualifying : defaultStat;
    this._dry = (isValid(dry)) ? dry : defaultStat;
    this._wet = (isValid(wet)) ? wet : defaultStat;
  }

  PaceStats.Random({double race = -1, double qualifying = -1, double dry = -1, double wet = -1}) {
    this._race = (isValid(race)) ? race : getRandomStat(driverDefaultStat);
    this._qualifying = (isValid(qualifying)) ? qualifying : getRandomStat(driverDefaultStat);
    this._dry = (isValid(dry)) ? dry : getRandomStat(driverDefaultStat);
    this._wet = (isValid(wet)) ? wet : getRandomStat(driverDefaultStat);
  }

  //setters
  void set race(double value) => (isValid(value)) ? value : this._race;
  void set qualifying(double value) => (isValid(value)) ? value : this._qualifying;
  void set dry(double value) => (isValid(value)) ? value : this._dry;
  void set wet(double value) => (isValid(value)) ? value : this._wet;
  
  //getters
  double get race => this._race;
  double get qualifying => this._qualifying;
  double get dry => this._dry;
  double get wet => this._wet;
}



class RacingStats {
  //attributes
  AbilityEnum _ability = AbilityEnum.def;
  double _potential = -1;
  double _cornering = -1;
  double _braking = -1;
  late PaceStats _pace;
  double _attack = -1;
  double _defense = -1;
  double _consistency = -1;
  double _experience = -1;
  
  
  //constructors
  RacingStats({double potential = defaultPotential, double cornering = defaultStat,
               double braking = defaultStat, double attack = defaultStat, double defense = defaultStat,
               double consistency = defaultStat, double dryPace = defaultStat,
               double wetPace = defaultStat, double racePace = defaultStat, double qualifyingPace = defaultStat,
               int careerYears = 0, PaceStats? pace = null}) {
    if(isValid(potential)) {
      this._potential = potential;
      this._ability = potentialToAbilityEnum(this._potential);
    }
    else {
      this.potential = defaultStat;
      this._ability = potentialToAbilityEnum(this._potential);
    }

    this._cornering = (isValid(cornering)) ? cornering : defaultStat;
    this._braking = (isValid(braking)) ? braking : defaultStat;
    this._attack = (isValid(attack)) ? attack : defaultStat;
    this._defense = (isValid(defense)) ? defense : defaultStat;
    this._consistency = (isValid(consistency)) ? consistency : defaultStat;
    this._experience = (careerYears >= 0) ? experienceCalc(careerYears) : defaultExperience;

    this._pace = (pace != null) ? pace : PaceStats(dry: (isValid(dryPace)) ? dryPace : defaultStat,
                                                   wet: (isValid(wetPace)) ? wetPace : defaultStat,
                                                   race: (isValid(racePace)) ? racePace : defaultStat,
                                                   qualifying: (isValid(qualifyingPace)) ? qualifyingPace : defaultStat,
                                                  );
  }

  RacingStats.Random({double potential = -1, double cornering = -1,
                      double braking = -1, double attack = -1, double defense = -1,
                      double consistency = -1, double dryPace = -1,
                      double wetPace = -1, double racePace = -1, double qualifyingPace = -1,
                      int careerYears = 0, PaceStats? pace = null}) {
    if(isValid(potential)) {
      this._potential = potential;
      this._ability = potentialToAbilityEnum(this._potential);
    }
    else {
      this.potential = randomPotential();
      this._ability = potentialToAbilityEnum(this._potential);
    }

    this._cornering = (isValid(cornering)) ? cornering : randomStat(this._ability);
    this._braking = (isValid(braking)) ? braking : randomStat(this._ability);
    this._attack = (isValid(attack)) ? attack : randomStat(this._ability);
    this._defense = (isValid(defense)) ? defense : randomStat(this._ability);
    this._consistency = (isValid(consistency)) ? consistency : randomStat(this._ability);
    this._experience = (careerYears >= 0) ? experienceCalc(careerYears) : defaultExperience;

    this._pace = (pace != null) ? pace : PaceStats(dry: (isValid(dryPace)) ? dryPace : randomStat(this._ability),
                                                   wet: (isValid(wetPace)) ? wetPace : randomStat(this._ability),
                                                   race: (isValid(racePace)) ? racePace : randomStat(this._ability),
                                                   qualifying: (isValid(qualifyingPace)) ? qualifyingPace : randomStat(this._ability),
                                                  );    
  }


  //methods
  
  
  //setters
  void set potential(double value) {
    this._potential = (isValid(value)) ? value : defaultStat;
    this._ability = potentialToAbilityEnum(this._potential);
  }
  void set cornering(double value) => this._cornering = (isValid(value)) ? value : defaultStat;
  void set braking(double value) => this._braking = (isValid(value)) ? value : defaultStat;
  void set pace(PaceStats value) => this._pace = value;
  void set attack(double value) => this._attack = (isValid(value)) ? value : defaultStat;
  void set defense(double value) => this._defense = (isValid(value)) ? value : defaultStat;
  void set consistency(double value) => this._consistency = (isValid(value)) ? value : defaultStat;

  
  //getters
  AbilityEnum get ability => this._ability;
  double get potential => this._potential;
  double get cornering => this._cornering;
  double get braking => this._braking;
  PaceStats get pace => this._pace;
  double get attack => this._attack;
  double get defense => this._defense;
  double get consistency => this._consistency;
  double get experience => this._experience;
}



class PersonalInfo {
  //attributes
  String _name = "";
  String _surname = "";
  String _gender = "";
  String _nationality = "";
  int _age = -1;
  int _careerYears = -1;
  double _height = -1;
  double _weight = -1;
  Team? _currentTeam = null;
  

  //constructors
  PersonalInfo({String name = defaultName, String surname = defaultSurname, String gender = defaultGender,
                    String nationality = defaultNationality, int age = defaultAge, int careerYears = defaultCareerYears,
                    double height = defaultHeight, double weight = defaultWeight, Team? currentTeam}) {
    this._name = (name != "") ? name : defaultName;
    this._surname = (surname != "") ? surname : defaultSurname;
    this._gender = (gender == "Male" || gender == "Female") ? gender : defaultGender;
    this._nationality = (nationality != "") ? nationality : defaultNationality;
    this._age = (minAge <= age && age <= maxAge) ? age : defaultAge;
    this._careerYears = (0 <= careerYears && careerYears <= this._age - minAge) ? careerYears : defaultCareerYears;
    this._height = (minHeight <= height && height <= maxHeight) ? height : defaultHeight;
    this._weight = (minWeight <= weight && weight <= maxWeight) ? weight : defaultWeight;
    this._currentTeam = (currentTeam != null && inList(officialTeamNames, currentTeam.teamName)) ? currentTeam : null;
  }
  
  PersonalInfo.Random({String name = "", String surname = "", String gender = "",
                    String nationality = "", int age = -1, int careerYears = -1,
                    double height = -1, double weight = -1, Team? currentTeam}) {
    this._name = (name != "") ? name : randomFromList(names);
    this._surname = (surname != "") ? surname : randomFromList(surnames);
    this._gender = (gender == "Male" || gender == "Female") ? gender : randomFromList(["Male", "Female"]);
    this._nationality = (nationality != "") ? nationality : defaultNationality;
    this._age = (minAge <= age && age <= maxAge) ? age : min(max(minAge, getGaussianDouble(minAge + 3.5, 3.5).round()), maxAge);
    this._careerYears = (0 <= careerYears && careerYears <= this._age - minAge) ? careerYears : defaultCareerYears;
    this._height = (minHeight <= height && height <= maxHeight) ?
      height : min(max(minHeight, getGaussianDouble(defaultHeight, 15).round()), maxHeight) / 100;
    this._weight = (minWeight <= weight && weight <= maxWeight) ?
      weight : min(max(minWeight, roundTo2Decimals(getGaussianDouble(65, 15))), maxWeight);
    this._currentTeam = (currentTeam != null && inList(officialTeamNames, currentTeam.teamName)) ?
      currentTeam : Team(randomFromList(officialTeamNames));
  }


  //methods


  //setters
  void set name(String value) => this._name = (value != "") ? value : defaultName;
  void set surname(String value) => this._surname = (value != "") ? value : defaultSurname;
  void set gender(String value)
    => this._gender = (gender == "Male" || gender == "Female") ? gender : defaultGender;
  void set nationality(String value) => (nationality != "") ? value : defaultNationality;  /* still need to implement nations list */
  void set age(int value) => this._age = (minAge <= value && value <= maxAge) ? value : minAge;
  void set careerYears(int value)
    => careerYears = (0 <= value && value <= this._age - minAge) ? value : 0;
  void set height(double value)
    => this._height = (minHeight <= value && value <= maxHeight) ? value : minHeight;
  void set weight(double value)
    => this._weight = (minWeight <= value && value <= maxWeight) ? value : minWeight;
  void set currentTeam(Team? value) =>
    (value != null && inList(officialTeamNames, value.teamName)) ? value : null;


  //getters
  String get name => this._name;
  String get surname => this._surname;
  String get gender => this._gender;
  String get nationality => this._nationality;    
  int get age => this._age;
  int get careerYears => this._careerYears;
  double get height => this._height;
  double get weight => this._weight;
  Team? get currentTeam => this._currentTeam;
}



class Driver {
  //attributes
  late PersonalInfo _personalInfo;
  late RacingStats _racingStats;


  //constructors
  Driver({String name = defaultName, String surname = defaultSurname, String gender = defaultGender,
          String nationality = defaultNationality, int age = defaultAge, int careerYears = defaultCareerYears,
          double height = defaultHeight, double weight = defaultWeight, Team? currentTeam, double potential = defaultPotential,
          double cornering = defaultStat, double braking = defaultStat, double attack = defaultStat, double defense = defaultStat,
          double consistency = defaultStat, double dryPace = defaultStat, double wetPace = defaultStat,
          double racePace = defaultStat, double qualifyingPace = defaultStat, PaceStats? pace = null}) {
    
    this._personalInfo = PersonalInfo(name: name, surname: surname, gender: gender, nationality: nationality, age: age,
                                      careerYears: careerYears, height: height, weight: weight, currentTeam: currentTeam);
    this._racingStats = RacingStats(potential: potential, cornering: cornering, braking: braking, attack: attack, defense: defense,
                                    consistency: consistency, dryPace: dryPace, wetPace: wetPace, racePace: racePace,
                                    qualifyingPace: qualifyingPace, careerYears: careerYears, pace: pace);
  }

  Driver.Random({String name = "", String surname = "", String gender = "", String nationality = "", int age = -1,
                 int careerYears = -1, double height = -1, double weight = -1, Team? currentTeam, double potential = -1,
                 double cornering = -1, double braking = -1, double attack = -1, double defense = -1,
                 double consistency = -1, double dryPace = -1, double wetPace = -1, double racePace = -1,
                 double qualifyingPace = -1, PaceStats? pace = null}) {

    this._personalInfo = PersonalInfo.Random(name: name, surname: surname, gender: gender, nationality: nationality, age: age,
                                             careerYears: careerYears, height: height, weight: weight, currentTeam: currentTeam);
    this._racingStats = RacingStats.Random(potential: potential, cornering: cornering, braking: braking, attack: attack,
                                           defense: defense, consistency: consistency, dryPace: dryPace, wetPace: wetPace,
                                           racePace: racePace, qualifyingPace: qualifyingPace, careerYears: careerYears, pace: pace);                  
  }


  //methods
  

  //methods
  void print() {
    stdout.write( """${this._personalInfo._surname}, ${this._personalInfo._name}
    - info:\n\tgender = ${this._personalInfo._gender}
    \tage = ${this._personalInfo._age}\n\tnationality = ${this._personalInfo._nationality}
    \theight = ${this._personalInfo._height}m\n\tweight = ${this._personalInfo._weight}kg
    \tcurrent team = ${(this._personalInfo.currentTeam != null) ? this._personalInfo.currentTeam!.teamName : "None"}
    - stats:\n\tPotential: ${this._racingStats._potential} (${this._racingStats._ability})
    \tcornering: ${this._racingStats._cornering}\n\tbraking: ${this._racingStats._braking}
    \tpace: race = ${this._racingStats._pace._race}, qualifying = ${this._racingStats._pace._qualifying}, dry = ${this._racingStats._pace._dry}, wet = ${this._racingStats._pace._wet}
    \tattack: ${this._racingStats._attack}\n\tdefense: ${this._racingStats._defense}
    \tconsistency: ${this._racingStats._consistency}
    \texperience: ${this._racingStats._experience}\n\n""" );
  }

  //setters
  void set personalInfo(PersonalInfo value) => this._personalInfo = value;
  void set racingStats(RacingStats value) => this._racingStats = value;

  //getters
  PersonalInfo get personalInfo => this._personalInfo;
  RacingStats get racingStats => this._racingStats;
}





//FUNCTIONS
double randomStat(AbilityEnum? ability, {double mean = 0.75, double variance = 0.005}) {
  var temp = min(max(0.50, getGaussianDouble(mean, variance)), 0.99);
  double factor = getUniformDouble(0.9, 1.1);   // to get more randomization

  switch(ability) {
    case AbilityEnum.bad:
      temp = factor * (temp - pow(0.4 * temp, 2));
      break;
    case AbilityEnum.lacking:
      temp = factor * (temp - pow(0.2 * temp, 2));
      break;
    case AbilityEnum.decent:
      temp = min(0.99, factor * (temp + pow(0.075 / temp, 2)));
      break;
    case AbilityEnum.good:
      temp = min(0.99, factor * (temp + pow(0.125 / temp, 2)));
      break;
    default:
      break;

  }
  
  return roundTo2Decimals(temp);
}

AbilityEnum potentialToAbilityEnum(double? potential) {
  potential!;
  if(potential >= 0.90)
    return AbilityEnum.good;
  if(potential >= 0.85)
    return AbilityEnum.decent;
  if(potential >= 0.80)
    return AbilityEnum.mediocre;
  if(potential >= 0.75)
    return AbilityEnum.lacking;
  
  return AbilityEnum.bad;
}

double experienceCalc(int years) {
  if(years >= 15) return 0.99;
  return roundTo2Decimals(sqrt(156538.92 - pow(years - 20.68, 2)) - 394.61);
}

double randomPotential() => roundTo2Decimals(min(max(0.70, getGaussianDouble(0.825, 0.008)), 0.99));

List<Driver> createRandomDriversList(int driversAmount) {
  List<Driver> list = [];
  Driver? dr;

  for(int i = 0, j = -1; i < driversAmount; i++) {
    if(i % 2 == 0) j += 1;
    dr = Driver.Random(currentTeam: Team(officialTeamNames[j]));
    list.add(dr);
  }

  return list;
}

