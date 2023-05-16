import 'dart:math';
import 'package:sample_statistics/sample_statistics.dart';

double get_gaussian_double(double mean, double variance) {
  return normalSample(1, mean, sqrt(variance))[0];
}



double get_uniform_double(double min, double max) {
  return uniformSample(1, min, max)[0];
}

double get_exponential_double(double lambda) {
  return exponentialSample(1, 1 / lambda)[0];
}