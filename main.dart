import 'dart:io';
import 'dart:math';
import 'driver.dart';
import 'distribution.dart';
import 'io.dart';
import 'session.dart';
import 'environment.dart';
import 'team.dart';



void main() {
  surnames = build_list_from_csv("ita_surnames.csv", row: 1, column: 1);
  names = build_list_from_csv("ita_names.csv", row: 1, column: 0);

  drivers_list = create_random_drivers_list(drivers_amount);

  Track tr = Track(track_name: "monza");
  Weather weather = Weather(tr, wet: 0);
  Qualifying quali = Qualifying(drivers_list, tr, weather);

  
  quali.start();

  quali.leaderboard.print();

  return;
}