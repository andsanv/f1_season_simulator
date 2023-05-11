import 'distribution.dart';
import 'dart:io';

class Corners {
  int slow_corners_amount = 0;
  int medium_corners_amount = 0;
  int fast_corners_amount = 0;

  Corners(slow_corners_amount, medium_corners_amount, fast_corners_amount) {
    this.slow_corners_amount = slow_corners_amount;
    this.medium_corners_amount = medium_corners_amount;
    this.fast_corners_amount = fast_corners_amount;
  }
}

class Track {
  String? _name;
  String? _nation;
  double? _length;
  double? _rain_probability;
  double? _rain_intensity;

  double? _average_dry_time;
  double? _average_wet_time;

  int? _straights_amount;
  List<double> _straights_length = [];
  int? _braking_zones;
  late Corners _corners;

  Track({String? track_name}) {
    if(track_name == null) random_init();
    else {
      File fp = File("tracks.csv");
      List<String> lines = fp.readAsLinesSync();
      int? counter;
      List<String>? words;
      
      for(counter = 1; counter! < lines.length; counter++) {
        words = lines[counter].split(',');
        if(words[1].toLowerCase() == track_name.toLowerCase()) break;
      }

      this._name = words![1];
      this._nation = words[2];
      this._length = double.parse(words[3]);
      this._rain_probability = double.parse(words[4]);
      this._rain_intensity = double.parse(words[5]);
      this._average_dry_time = double.parse(words[6]);
      this._average_wet_time = _average_dry_time! * 1.15;
      this._straights_amount = int.parse(words[7]);
      
      for(int i = 8; i < 8 + _straights_amount!; i++)
        _straights_length.add(double.parse(words[i]));
      
      this._braking_zones = int.parse(words[words.length - 4]);
      this._corners = Corners(int.parse(words[words.length - 3]), int.parse(words[words.length - 2]), int.parse(words[words.length - 1]));
    }
  }

  void random_init()
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