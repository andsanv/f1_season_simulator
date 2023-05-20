import 'dart:math';
import 'dart:io';
import 'environment.dart';
import 'distribution.dart';
import 'driver.dart';
import 'car.dart';


const double average_stat = 0.75;



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
    int counter = 1, tabs_needed = 2;

    for(Position position in this._positions) {
      tabs_needed = 2;
      if(counter < 10) stdout.write("0");
      stdout.write("$counter: ${position.driver?.personal_info.name![0]}. ");
      stdout.write("${position.driver?.personal_info.surname}");
      if(position.driver!.personal_info.surname!.length >= 9) tabs_needed = 1;
      stdout.write("\t" * tabs_needed);
      stdout.write("${position.laptime}");
      stdout.write("\t \t(${position.driver!.racing_stats.braking}, ${position.driver!.racing_stats.cornering})\t\t${position.driver!.personal_info.current_team!.team_name}\n");
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
    this._drivers_list = drivers_list;
    this._track = track;
    this._weather = weather;
    (this._leaderboard = SingleLapLeaderboard()).init(this._drivers_list);
  }

  //methods
  void start() {
    for(Driver driver in drivers_list) {
      this._leaderboard.update(Position(driver: driver, laptime: get_laptime(driver, this._track, this._weather)));
    }
    for(Driver driver in drivers_list) {
      this._leaderboard.update(Position(driver: driver, laptime: get_laptime(driver, this._track, this._weather)));
    }
  }

  double get_laptime(Driver driver, Track track, Weather weather) {
    //double get_random_time(double mean, double variance) => min(max(get_gaussian_double(mean, variance), mean - 0.2), mean + 0.2);
    double corners_delta = 0, straights_delta = 0, braking_delta = 0;
    for(int i = 0; i < track.corners.slow_corners_amount!; i++) {
      corners_delta += (average_stat - driver.racing_stats.cornering!) * 0.16 + (average_stat - driver.personal_info.current_team!.car.chassis) * 0.24 + weather.wet! * ((average_stat - driver.racing_stats.wet_pace!) / 0.25) * 0.1;
    }
    for(int i = 0; i < track.corners.medium_corners_amount!; i++) {
      corners_delta += (average_stat - driver.racing_stats.cornering!) * 0.16 + (average_stat * 2 - driver.personal_info.current_team!.car.chassis - driver.personal_info.current_team!.car.downforce) * 0.24 + weather.wet! * ((average_stat - driver.racing_stats.wet_pace!) / 0.25) * 0.1;
    }
    for(int i = 0; i < track.corners.slow_corners_amount!; i++) {
      corners_delta += (average_stat - driver.racing_stats.cornering!) * 0.16 + (average_stat - driver.personal_info.current_team!.car.downforce) * 0.24 + weather.wet! * ((average_stat - driver.racing_stats.wet_pace!) / 0.25) * 0.1;;
    }
    for(int i = 0; i < track.straights_amount!; i++) {
      straights_delta += (average_stat * 2 - driver.personal_info.current_team!.car.engine - driver.personal_info.current_team!.car.efficiency) * track.straights_length[i] * 0.8;
    }
    for(int i = 0; i < track.braking_zones_amount!; i++) {
      braking_delta += (average_stat - driver.racing_stats.braking!) * 0.16 + (average_stat * 2 - driver.personal_info.current_team!.car.chassis - driver.personal_info.current_team!.car.downforce) * 0.24 +  weather.wet! * ((average_stat - driver.racing_stats.wet_pace!) / 0.25) * 0.1;
    }

    double track_delta = corners_delta + straights_delta + braking_delta;
    double perfect_time = track.average_dry_time! * weather.dry! + track.average_wet_time!  * weather.wet! + track_delta;
    double actual_time = perfect_time + (track_delta - get_gaussian_double(corners_delta + straights_delta + braking_delta, (39 - 38 * driver.racing_stats.consistency!) / 200)).abs();


    return (1000 * actual_time).round() / 1000;
  }


  //setters

  //getters
  SingleLapLeaderboard get leaderboard => this._leaderboard;
}
