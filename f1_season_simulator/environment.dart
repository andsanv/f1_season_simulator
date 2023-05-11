import 'distribution.dart';

class Corners {
  int slow_corners_amount = 0;
  int medium_corners_amount = 0;
  int fast_corners_amount = 0;

  Corners(sca, mca, fca) {
    this.slow_corners_amount = sca;
    this.medium_corners_amount = mca;
    this.fast_corners_amount = fca;
  }
}

class Track {
  String name = "";
  String nation = "";
  double length = 0;
  double rain_probability = 0;
  double rain_intensity = 0;

  double average_dry_time = 0;
  double average_wet_time = 0;

  int straights_amount = 0;
  List<double> straights_length = [];
  int braking_zones = 0;
  Corners corners = Corners(0, 0, 0);

  Track() {
    this.name = "Monza";
    this.nation = "Italy";
    this.length = 5793;
    this.rain_probability = 0;
    this.rain_intensity = 0.5;
    this.average_dry_time = 80.161;
    this.average_wet_time = 1.15 * average_dry_time;
    this.straights_amount = 5;
    this.straights_length = [0.7,0.5,0.15,0.4,0.4];
    this.braking_zones = 6;
    this.corners = Corners(4, 2, 4);
  }
}


class Weather {
  double dry = 0;
  double wet = 0;

  Weather(Track t) {
    if(get_uniform_double(0, 1) < t.rain_probability)
      wet = 1;
    else dry = 1;
  }
}

Track NullTrack = Track();
Weather NullWeather = Weather(NullTrack);