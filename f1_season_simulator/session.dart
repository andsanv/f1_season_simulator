import 'dart:math';
import 'dart:io';
import 'environment.dart';
import 'distribution.dart';
import 'driver.dart';


const double average_stat = 0.75;
const double race_delta_factor = 2;
const double qualifying_delta_factor = 0.02;
const double dry_delta_factor = 0.8;
const double wet_delta_factor = 2;



class Laptime {
  Driver driver = Driver.Null();
  double time = 0;

  Laptime(Driver d, double time) {
    this.driver = d;
    this.time = time;
  }
}


class QualifyingLeaderboard {
  List<Laptime> positions = [];
  bool initialized = false;

  Ranking() {}

  void initialize(List<Driver> drivers_list) {
    for(int i = 0; i < drivers_amount; i++) {
      positions.add(Laptime(drivers_list[i], 0));
    }

    for(int i = 0; i < drivers_amount - 1; i++) {
      for(int j = i + 1; j < drivers_amount; j++) {
        if(positions[i].driver.personal_info.surname.compareTo(positions[j].driver.personal_info.surname) > 0) {
          Laptime temp = Laptime(positions[j].driver, positions[j].time);
          positions[j].driver = positions[i].driver;
          positions[j].time = positions[i].time;
          positions[i].driver = temp.driver;
          positions[i].time = temp.time;
        }
        else if(positions[i].driver.personal_info.surname.compareTo(positions[j].driver.personal_info.surname) == 0) {
          if(positions[i].driver.personal_info.name.compareTo(positions[j].driver.personal_info.name) > 0) {
            Laptime temp = Laptime(positions[j].driver, positions[j].time);
            positions[j].driver = positions[i].driver;
            positions[j].time = positions[i].time;
            positions[i].driver = temp.driver;
            positions[i].time = temp.time;
          }
          else continue;
        }

      }
    }  

    this.initialized = true;
  }

  void print_all() {
    if(this.initialized == false) {
      print("ranking is empty.");
      return;
    }
    for(Laptime position in this.positions) {
      stdout.write("[${position.driver.personal_info.surname} ${position.driver.personal_info.name},  \t${position.time},\t");
      stdout.write("${(((position.driver.racing_stats.pace.race + position.driver.racing_stats.pace.dry) * 100) / 2).round()}]\n");
    }
  }


  void update(Laptime new_laptime) {
    if(positions[0].driver == new_laptime.driver) {
      if(new_laptime.time <= positions[0].time || positions[0].time == 0)
        positions[0].time = new_laptime.time;
      }
    else {
      int target_bottom = 0;
      for(Laptime position in positions) {
        if(position.driver != new_laptime.driver) {
          target_bottom += 1;
        }
        else break;
      }

      int target_top = 0;
      for(Laptime position in positions) {
        if(position.time <= new_laptime.time && position.time != 0) {
          target_top += 1;
        }
        else break;
      }

      if(target_top < target_bottom) {
        for(int i = target_bottom; i > target_top; i--) {
          positions[i] = positions[i - 1];
        }
        positions[target_top] = new_laptime;
      }
      else if(target_top == target_bottom) positions[target_top].time = new_laptime.time;
    }
  }
}



class Event {
  int year = 0;
  Track track = NullTrack;
  Weather weather = NullWeather;
  String session = "";

  Event(int year, Track track, String session) {
    this.year = year;
    this.track = track;
    this.weather = Weather(this.track);
    this.session = session;
  }


  get_laptime(Driver driver) {
    double? delta_based_on_session = 0, delta_based_on_weather = 0, total_delta = 0;
    if(session == "race")
      delta_based_on_session = (average_stat - driver.racing_stats.pace.race) * race_delta_factor;
    else
      delta_based_on_session = (average_stat - driver.racing_stats.pace.qualifying) * qualifying_delta_factor;

    delta_based_on_weather = weather.dry * ((average_stat - driver.racing_stats.pace.dry) * dry_delta_factor) + weather.wet * ((average_stat - driver.racing_stats.pace.wet) * wet_delta_factor);
    total_delta = delta_based_on_session + delta_based_on_weather;

    double perfect_time = 0;
    if(weather.dry == 1)
      perfect_time = track.average_dry_time + total_delta;
    else
      perfect_time = track.average_wet_time + total_delta;
    
    
    double variance_based_on_consistency = /* (2 / driver.racing_stats.consistency) */ 0.02 / pow(driver.racing_stats.consistency, 5);
    double probabilistic_time = get_gaussian_double(perfect_time, variance_based_on_consistency);
    double real_time = (1000 * (perfect_time + (perfect_time - probabilistic_time).abs())).round() / 1000;

    return [perfect_time, total_delta, Laptime(driver, real_time)];
  }
}