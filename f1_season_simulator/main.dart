import 'dart:io';
import 'dart:math';
import 'driver.dart';
import 'distribution.dart';
import 'io.dart';
//import 'session.dart';
import 'environment.dart';


const double average_stat = 0.75;
const double race_delta_factor = 2;
const double qualifying_delta_factor = 0.02;
const double dry_delta_factor = 0.8;
const double wet_delta_factor = 2;



void main() {
  surnames = build_list_from_csv("ita_surnames.csv", 1, 1);
  names = build_list_from_csv("ita_names.csv", 1, 0);

  // drivers_list = create_random_drivers_list(drivers_amount);
  

  // Driver dr = Driver();
  // Track track = Track();
  // Ranking ranks = Ranking();

  // ranks.print_all();
  // ranks.initialize(drivers_list);
  // ranks.print_all();

  // Event event = Event(2023, track, "race");
  // ranks.update(lap);
  
  // double sum = 0;

  // int tests = 100000;

  // dr.racing_stats.consistency = 0.99;
  // dr.racing_stats.pace.dry = 0.5;
  // dr.racing_stats.pace.race = 0.50;
  // double p_t = 0, t_d = 0;

  // for(int i = 0; i < tests; i++) {
  //   var return_value = event.get_laptime(dr);
  //   p_t = return_value[0];
  //   Laptime lap = return_value[2];
  //   print(lap.time);
  //   sum += lap.time;
  // }

  // dr.print_info();
  // print("\ntrack time: ${track.average_dry_time}\nperfect time: ${p_t}\naverage time: ${sum / tests}\ndelta: ${sum / tests - p_t}");

  
  Driver dr = Driver.Random();
  dr.print_info();

  // ranks.print_all();

  return;
}