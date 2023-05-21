import 'dart:io';
import 'dart:math';

import 'driver.dart';
import 'helpers.dart';
import 'io.dart';
import 'session.dart';
import 'environment.dart';
//import 'team.dart';



void main() {
  surnames = buildListFromCsv("ita_surnames.csv", row: 1, column: 1);
  names = buildListFromCsv("ita_names.csv", row: 1, column: 0);

  driversList = createRandomDriversList(driversAmount);
  
  Track tr = Track("Sakir");
  Weather weather = Weather(tr, wet: 0);
  Qualifying quali = Qualifying(driversList, tr, weather);

  quali.start();
  quali.leaderboard.print();

  return;
}