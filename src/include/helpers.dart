import 'dart:math';
import 'package:sample_statistics/sample_statistics.dart';


//basic constants
const double defaultStat = 0.75;

//paths
const String officialCarsCsvPath = "../../data/cars.csv";



//basic helper functions
bool isValid(double stat) => 0.5 <= stat && stat <= 1;

double roundTo2Decimals(double value) => (value * 100).round() / 100;
double roundTo3Decimals(double value) => (value * 1000).round() / 1000;

bool inList(list, element) {
  for (var val in list)
    if(val == element) return true;

  return false;
}



//randomization
double getRandomStat(double avg)
  => (isValid(avg)) ?
      (100 * min(max(0.50, getGaussianDouble(avg, 0.005)), 0.99)).round() / 100 :
      (100 * min(max(0.50, getGaussianDouble(defaultStat, 0.005)), 0.99)).round() / 100 ;

double getGaussianDouble(double mean, double variance) => normalSample(1, mean, sqrt(variance))[0];

double getUniformDouble(double min, double max) => uniformSample(1, min, max)[0];

double getExponentialDouble(double lambda) => exponentialSample(1, 1 / lambda)[0];

String randomFromList(List<String> list) => list[Random().nextInt(list.length)];

