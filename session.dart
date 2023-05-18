import 'dart:math';
import 'dart:io';
import 'environment.dart';
import 'distribution.dart';
import 'driver.dart';
import 'car.dart';


const double average_stat = 0.75;
const double race_delta_factor = 2;
const double qualifying_delta_factor = 0.02;
const double dry_delta_factor = 0.8;
const double wet_delta_factor = 2;



// Year {
//   Standings {
//     Positions[20] {
//       driver
//       team
//       points
//     }
//   }
//
//   events[20] {
//     track
//     weather
//     qualifying {
//        leaderboard

//     }
//     race {
//      
//     }
//   }
// }


class Position {
  //attributes
  Driver? _driver;
  double? _laptime;

  //constructors
  Position({Driver? driver, double? laptime}) {
    if(driver != null) this._driver = driver;
    if(laptime != null) this._laptime = laptime;
  }

  //setters
  void set driver(Driver? value) { if(value != null) this._driver = value; }
  void set laptime(double? value) { if(value != null) this._laptime = value; }

  //getters
  Driver? get driver => this._driver;
  double? get laptime => this._laptime;
}


class SingleLapLeaderboard {
  //attributes
  List<Position> _positions = [];
  bool _initialized = false;

  //constructors

  //methods
  void init(List<Driver> drivers_list) {
    for(int i = 0; i < drivers_amount; i++) this._positions.add(Position(driver: drivers_list[i], laptime: 0));

    for(int i = 0; i < drivers_amount - 1; i++)
      for(int j = i + 1; j < drivers_amount; j++) {
        if((this._positions[i].driver?.personal_info.surname!.compareTo((this._positions[j].driver?.personal_info.surname)!))! > 0) {
          Position temp = Position(driver: this._positions[j]._driver, laptime: this._positions[j]._laptime);
          this._positions[j]._driver = this._positions[i]._driver;
          this._positions[j]._laptime = this._positions[i]._laptime;
          this._positions[i]._driver = temp.driver;
          this._positions[i]._laptime = temp.laptime;
        }
        else if((this._positions[i].driver?.personal_info.surname!.compareTo((this._positions[j].driver?.personal_info.surname)!))! == 0) {
          if((this._positions[i].driver?.personal_info.name!.compareTo((this._positions[j].driver?.personal_info.name)!))! > 0) {
            Position temp = Position(driver: this._positions[j]._driver, laptime: this._positions[j]._laptime);
            this._positions[j]._driver = this._positions[i]._driver;
            this._positions[j]._laptime = this._positions[i]._laptime;
            this._positions[i]._driver = temp.driver;
            this._positions[i]._laptime = temp.laptime;
          }
          else continue;
        }
      }

    this._initialized = true;
  }

  void update(Position new_laptime) {
    if(this._positions[0].driver == new_laptime.driver) {
      if(new_laptime.laptime! <= this._positions[0].laptime! || positions[0].laptime == 0) this._positions[0].laptime = new_laptime.laptime;
    }
    else {
      int target_bottom = 0;
      for(Position position in this._positions) {
        if(position.driver != new_laptime.driver) target_bottom += 1;
        else break;
      }

      int target_top = 0;
      for(Position position in this._positions) {
        if(position.laptime! <= new_laptime.laptime! && position.laptime != 0) target_top += 1;
        else break;
      }

      if(target_top < target_bottom) {
        for(int i = target_bottom; i > target_top; i--) positions[i] = positions[i - 1]; 
        this._positions[target_top] = new_laptime;
      }
      else if(target_top == target_bottom) this._positions[target_top].laptime = new_laptime.laptime;
    }
  }

  void print() {
    stdout.write("LEADERBOARD\n");
    int counter = 1;

    for(Position position in this._positions) {
      stdout.write("$counter: ${position.driver?.personal_info.name![0]}. ");
      stdout.write("${position.driver?.personal_info.surname}\n\t");
      stdout.write("${position.laptime}\n");
      counter++;
    }
    stdout.write("\n");
  }

  //setters

  //getters
  List<Position> get positions => this._positions;
  bool get initialized => this._initialized;
}

// class OnTrackGapLeaderboard {}


class Qualifying {
  //attributes
  late List<Driver> _drivers_list;
  late Track _track;
  late Weather _weather;
  SingleLapLeaderboard _leaderboard = SingleLapLeaderboard();


  //constructors
  Qualifying(List<Driver> drivers_list, Track track, Weather weather, ) {
    for(Driver driver in this._drivers_list) {
      _leaderboard.update(get_laptime(driver, this._track, this._weather)) {

      }
    }
  }

  //methods
  void start() {

  }

  double get_laptime(Driver driver, Track track, Weather weather) {
    double get_random_time(double mean, double variance) => min(max(get_gaussian_double(mean, variance), mean - 0.2), mean + 0.2);
    double corners_delta = 0, straights_delta = 0;
    for(int i = 0; i < track.corners.slow_corners_amount!; i++) {
      corners_delta += (average_stat - driver.racing_stats.cornering!) * get_random_time(0.16, 0.0002) + (average_stat - driver.personal_info.current_team!.car.chassis) * get_random_time(0.24, 0.0002) + weather.wet! * ((average_stat - driver.racing_stats.wet_pace!) / 0.25) * 0.1;
    }
    for(int i = 0; i < track.corners.medium_corners_amount!; i++) {
      corners_delta += (average_stat - driver.racing_stats.cornering!) * get_random_time(0.16, 0.0002) + (average_stat * 2 - driver.personal_info.current_team!.car.chassis - driver.personal_info.current_team!.car.downforce) * get_random_time(0.24, 0.0002) + weather.wet! * ((average_stat - driver.racing_stats.wet_pace!) / 0.25) * 0.1;
    }
    for(int i = 0; i < track.corners.slow_corners_amount!; i++) {
      corners_delta += (average_stat - driver.racing_stats.cornering!) * get_random_time(0.16, 0.0002) + (average_stat - driver.personal_info.current_team!.car.downforce) * get_random_time(0.24, 0.0002) + weather.wet! * ((average_stat - driver.racing_stats.wet_pace!) / 0.25) * 0.1;;
    }
    for(int i = 0; i < track.straights_amount!; i++) {
      straights_delta += (average_stat * 2 - driver.personal_info.current_team!.car.engine - driver.personal_info.current_team!.car.efficiency) * track.straights_length[i] * get_random_time(0.8, 0.00005);
    }
    
  }


  //setters
  //getters
}



// class Event {
//   int year = 0;
//   Track track = NullTrack;
//   Weather weather = NullWeather;
//   String session = "";

//   Event(int year, Track track, String session) {
//     this.year = year;
//     this.track = track;
//     this.weather = Weather(this.track);
//     this.session = session;
//   }


//   get_laptime(Driver driver) {
//     double? delta_based_on_session = 0, delta_based_on_weather = 0, total_delta = 0;
//     if(session == "race")
//       delta_based_on_session = (average_stat - driver.racing_stats.pace.race!) * race_delta_factor;
//     else
//       delta_based_on_session = (average_stat - driver.racing_stats.pace.qualifying!) * qualifying_delta_factor;

//     delta_based_on_weather = weather.dry * ((average_stat - driver.racing_stats.pace.dry!) * dry_delta_factor) + weather.wet * ((average_stat - driver.racing_stats.pace.wet!) * wet_delta_factor);
//     total_delta = delta_based_on_session + delta_based_on_weather;

//     double perfect_time = 0;
//     if(weather.dry == 1)
//       perfect_time = track.average_dry_time + total_delta;
//     else
//       perfect_time = track.average_wet_time + total_delta;
    
    
//     double variance_based_on_consistency = /* (2 / driver.racing_stats.consistency) */ 0.02 / pow(driver.racing_stats.consistency!, 5);
//     double probabilistic_time = get_gaussian_double(perfect_time, variance_based_on_consistency);
//     double real_time = (1000 * (perfect_time + (perfect_time - probabilistic_time).abs())).round() / 1000;

//     return [perfect_time, total_delta, Laptime(driver, real_time)];
//   }
// }