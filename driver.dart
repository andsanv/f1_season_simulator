import 'dart:io';
import 'dart:math';
import 'distribution.dart';
import 'team.dart';
import 'car.dart';



//DATA STRUCTURES
List<String> names = [], surnames = [];
enum ability_enum {bad, lacking, mediocre, decent, good}
List<ability_enum> ability_levels = ability_enum.values;
const int drivers_amount = 20, min_age = 18, max_age = 32, min_height = 160, max_height = 195;
const double min_weight = 55, max_weight = 75;
List<Driver> drivers_list = [];




//CLASSES
class PaceStats {
  //attributes
  double? _race;
  double? _qualifying;
  double? _dry;
  double? _wet;

  //constructors
  PaceStats({double? race, double? qualifying, double? dry, double? wet}) {
    this._race = race;
    this._qualifying = qualifying;
    this._dry = dry;
    this._wet = wet;
  }

  //setters
  void set race(double? value) => this._race = value;
  void set qualifying(double? value) => this._qualifying = value;
  void set dry(double? value) => this._dry = value;
  void set wet(double? value) => this._wet = value;
  
  //getters
  double? get race => this._race;
  double? get qualifying => this._qualifying;
  double? get dry => this._dry;
  double? get wet => this._wet;
}



class RacingStats {
  //attributes
  ability_enum? _ability;
  double? _potential;
  double? _cornering;
  double? _braking;
  late PaceStats _pace;
  double? _attack;
  double? _defense;
  double? _consistency;
  double? _experience;
  
  //constructors
  RacingStats({ability_enum? ability, double? potential, double? cornering, double? braking,
              double? race_pace, double? qualifying_pace, double? dry_pace, double? wet_pace, double? attack, double? defense,
              double? consistency, double? experience}) {
    PaceStats pace_stats = PaceStats(race: race_pace, qualifying: qualifying_pace, dry: dry_pace, wet: wet_pace);
    this._ability = ability;
    this._potential = potential;
    this._cornering = cornering;
    this._braking = braking;
    this._pace = pace_stats;
    this._attack = attack;
    this._defense = defense;
    this._consistency = consistency;
    this._experience = experience;
  }

  //methods
  void random_init({int? career_years}) {
    if(this._potential == null) this._potential = random_potential(); 
    if(this._experience == null && career_years != null) this._experience = experience_calc(career_years); 
    if(this._ability == null) this._ability = potential_to_ability_enum(this._potential);
    if(this.cornering == null) this._cornering = random_stat(this._ability);
    if(this.braking == null) this.braking = random_stat(this._ability);
    if(this._attack == null) this._attack = random_stat(this._ability);
    if(this._defense == null) this._defense = random_stat(this._ability);
    if(this._consistency == null) this._consistency = random_stat(this._ability);

    double? r = 0, q = 0, d = 0, w = 0;
    if(this._pace._race == null) r = random_stat(this._ability);
    else r = _pace._race;
    if(this._pace._qualifying == null) q = random_stat(this._ability);
    else q = _pace._qualifying;
    if(this._pace._dry == null) d = random_stat(this._ability);
    else d = _pace._dry;
    if(this._pace._wet == null) w = random_stat(this._ability);
    else w = _pace._wet;
    this._pace = PaceStats(race: r, qualifying: q, dry: d, wet: w);
  }
  
  //setters
  void set ability(ability_enum? value) => this._ability = value;
  void set potential(double? value) => this._potential = value;
  void set cornering(double? value) => this._cornering = value;
  void set braking(double? value) => this._braking = value;
  void set pace(PaceStats value) => this._pace = value;
  void set race_pace(double? value) => this._pace._race = value;
  void set qualifying_pace(double? value) => this._pace._qualifying = value;
  void set dry_pace(double? value) => this._pace._dry = value;
  void set wet_pace(double? value) => this._pace._wet = value;
  void set attack(double? value) => this._attack = value;
  void set defense(double? value) => this._defense = value;
  void set consistency(double? value) => this._consistency = value;
  void set experience(double? value) => this._experience = value;
  
  //getters
  ability_enum? get ability => this._ability;
  double? get potential => this._potential;
  double? get cornering => this._cornering;
  double? get braking => this._braking;
  PaceStats get pace => this._pace;
  double? get race_pace => this.pace.race;
  double? get qualifying_pace => this._pace.qualifying;
  double? get dry_pace => this._pace.dry;
  double? get wet_pace => this._pace.wet;
  double? get attack => this._attack;
  double? get defense => this._defense;
  double? get consistency => this._consistency;
  double? get experience => this._experience;
}


class PersonalInfo {
  //attributes
  String? _name;
  String? _surname;
  String? _gender;
  String? _nationality;
  int? _age;
  int? _career_years;
  double? _height;
  double? _weight;
  Team? _current_team;
  
  //constructors
  PersonalInfo({String? name, String? surname, String? gender, String? nationality, int? age,
                int? career_years, double? height, double? weight, Team? current_team}) {
    this._name = name;
    this._surname = surname;
    this._gender = gender;
    this._nationality = nationality;
    this._age = age;
    this._career_years = career_years;
    this._height = height;
    this._weight = weight;
    this._current_team = current_team;
  }

  //methods
  void random_init() {
    if(this._name == null) this._name = random_from_list(names);
    if(this._surname == null) this._surname = random_from_list(surnames);
    if(this._gender == null) this._gender = "Male";
    if(this._nationality == null) this._nationality = "Italian";
    if(this._age == null) this._age = min(max(min_age, get_gaussian_double(21.5, 3.5).round()), max_age);
    if(this._height == null) this._height = min(max(min_height, get_gaussian_double(178.5, 15).round()), max_height)/100;
    if(this._weight == null) this._weight = min(max(min_weight, (100 * get_gaussian_double(65, 15)).round() / 100), max_weight);
    if(this._career_years == null) this._career_years = 0;
    if(this._current_team == null) this._current_team = Team(random_from_list(official_team_names));
  }

  //setters
  void set name(String? value) => this._name = value;
  void set surname(String? value) => this._surname = value;
  void set gender(String? value) => this._gender = value;
  void set nationality(String? value) => this._nationality = value;
  void set age(int? value) => this._age = value;
  void set career_years(int? value) => this._career_years = value;
  void set height(double? value) => this._height = value;
  void set weight(double? value) => this._weight = value;
  void set current_team(Team? value) => this._current_team = value;

  //getters
  String? get name => this._name;
  String? get surname => this._surname;
  String? get gender => this._gender;
  String? get nationality => this._nationality;
  int? get age => this._age;
  int? get career_years => this._career_years;
  double? get height => this._height;
  double? get weight => this._weight;
  Team? get current_team => this._current_team;
}


class Driver {
  //attributes
  late PersonalInfo _personal_info;
  late RacingStats _racing_stats;

  //constructors
  Driver({String? name, String? surname, String? gender, String? nationality, int? age, int? career_years, double? height,
          double? weight, ability_enum? ability, double? potential, double? cornering, double? braking, double? race_pace,
          double? qualifying_pace, double? dry_pace, double? wet_pace, double? attack, double? defense, double? consistency,
          double? experience, Team? current_team}) {
    this._personal_info = PersonalInfo(name: name, surname: surname, gender: gender, nationality: nationality, age: age,
                                       career_years: career_years, height: height, weight: weight, current_team: current_team);
    this._racing_stats = RacingStats(ability: ability, potential: potential, cornering: cornering, braking: braking,
                                     race_pace: race_pace, qualifying_pace: qualifying_pace, dry_pace: dry_pace, wet_pace: wet_pace,
                                     attack: attack, defense: defense, consistency: consistency, experience: experience);
  }

  Driver.Random({String? name, String? surname, String? gender, String? nationality, int? age, int? career_years, double? height,
          double? weight, ability_enum? ability, double? potential, double? cornering, double? braking, double? race_pace,
          double? qualifying_pace, double? dry_pace, double? wet_pace, double? attack, double? defense, double? consistency,
          double? experience, Team? current_team}) {
    (this._personal_info = PersonalInfo(name: name, surname: surname, gender: gender, nationality: nationality, age: age,
                                       career_years: career_years, height: height, weight: weight, current_team: current_team)).random_init();
    (this._racing_stats = RacingStats(ability: ability, potential: potential, cornering: cornering, braking: braking,
                                     race_pace: race_pace, qualifying_pace: qualifying_pace, dry_pace: dry_pace, wet_pace: wet_pace,
                                     attack: attack, defense: defense, consistency: consistency, experience: experience)).random_init(career_years: personal_info.career_years);
  }

  //methods
  void print() {
    stdout.write("${this._personal_info._surname}, ${this._personal_info.name}\n");
    stdout.write("- info:\n\tgender = ${this._personal_info._gender}\n\tage = ${this._personal_info._age}\n\tnationality = ${this._personal_info._nationality}\n\theight = ${this._personal_info._height}m\n\tweight = ${this._personal_info._weight}kg\n\tcurrent team = ${this._personal_info.current_team!.team_name}\n");
    stdout.write("- stats:\n\tPotential: ${this._racing_stats._potential} (${this._racing_stats._ability})\n\t");
    stdout.write("cornering: ${this._racing_stats._cornering}\n\tbraking: ${this._racing_stats._braking}\n\t");
    stdout.write("pace: race = ${this._racing_stats._pace._race}, qualifying = ${this._racing_stats._pace._qualifying}, dry = ${this._racing_stats._pace._dry}, wet = ${this._racing_stats._pace._wet}\n\t");
    stdout.write("attack: ${this._racing_stats._attack}\n\tdefense: ${this._racing_stats._defense}\n\t");
    stdout.write("consistency: ${this._racing_stats._consistency}\n\texperience: ${this._racing_stats._experience}\n\n");
  }

  //setters
  void set personal_info(PersonalInfo value) => this._personal_info = value;
  void set racing_stats(RacingStats value) => this._racing_stats = value;

  //getters
  PersonalInfo get personal_info => this._personal_info;
  RacingStats get racing_stats => this._racing_stats;
}





//FUNCTIONS
String random_from_list(List<String> list) {
  return list[Random().nextInt(list.length)];
}




double random_stat(ability_enum? ability, {double mean = 0.75, double variance = 0.005}) {
  var temp = min(max(0.50, get_gaussian_double(mean, variance)), 0.99);
  double factor = get_uniform_double(0.9, 1.1);   // to get more randomization

  switch(ability) {
    case ability_enum.bad:
      temp = factor *(temp - pow(0.4 * temp, 2));
      break;
    case ability_enum.lacking:
      temp = factor * (temp - pow(0.2 * temp, 2));
      break;
    case ability_enum.decent:
      temp = min(0.99, factor * (temp + pow(0.075 / temp, 2)));
      break;
    case ability_enum.good:
      temp = min(0.99, factor * (temp + pow(0.125 / temp, 2)));
      break;
    default:
      break;

  }
  
  return (temp * 100).round() / 100;
}



ability_enum potential_to_ability_enum(double? potential) {
  potential!;
  if(potential >= 0.90)
    return ability_enum.good;
  if(potential >= 0.85)
    return ability_enum.decent;
  if(potential >= 0.80)
    return ability_enum.mediocre;
  if(potential >= 0.75)
    return ability_enum.lacking;
  
  return ability_enum.bad;
}



double experience_calc(int years) {
  if(years >= 15) return 0.99;
  return ((sqrt(156538.92 - pow(years - 20.68, 2)) - 394.61) * 100).round() / 100;
}



double random_potential() => (min(max(0.70, get_gaussian_double(0.825, 0.008)), 0.99) * 100).round() / 100;



List<Driver> create_random_drivers_list(int drivers_number) {
  List<Driver> list = [];

  for(int i = 0; i < drivers_number; i++) {
    Driver dr = Driver.Random();
    list.add(dr);
  }

  return list;
}

