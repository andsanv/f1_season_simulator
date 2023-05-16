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
  surnames = build_list_from_csv("ita_surnames.csv", row: 1, column: 1);
  names = build_list_from_csv("ita_names.csv", row: 1, column: 0);

  drivers_list = create_random_drivers_list(drivers_amount);
  
  

  return;
}