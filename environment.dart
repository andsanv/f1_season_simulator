import 'distribution.dart';
import 'dart:io';
import 'dart:math';

int tracks_amount = 6;



class Corners {
  //attributes
  int? slow_corners_amount;
  int? medium_corners_amount;
  int? fast_corners_amount;

  //constructors
  Corners({slow_corners_amount = null, medium_corners_amount = null, fast_corners_amount = null}) {
    this.slow_corners_amount = slow_corners_amount;
    this.medium_corners_amount = medium_corners_amount;
    this.fast_corners_amount = fast_corners_amount;
  }
}



class Track {
  //attributes
  String? _name;
  String? _nation;
  double? _length;
  double? _rain_probability;
  double? _average_rain_intensity;

  double? _average_dry_time;
  double? _average_wet_time;

  int? _straights_amount;
  List<double> _straights_length = [];
  int? _braking_zones_amount;
  late Corners _corners;

  //constructors
  Track({String? track_name}) {
    if(track_name != null) {
      List<String>? words;
      int counter = 0;
      File fp = File("tracks.csv");
      List<String> lines = fp.readAsLinesSync();

      for(counter = 1; counter < lines.length; counter++) {
        words = lines[counter].split(',');
        if(words[1].toLowerCase() == track_name.toLowerCase()) break;
      }
    
      if(counter < lines.length) {
        init(counter);
      }
    }
  }

  Track.Random() { init(get_uniform_double(1, tracks_amount.toDouble()).round()); }

  //methods
  void init(int counter) {
    File fp = File("tracks.csv");
    List<String> lines = fp.readAsLinesSync(), words = lines[counter].split(',');

    this._name = words[1];
    this._nation = words[2];
    this._length = double.parse(words[3]);
    this._rain_probability = double.parse(words[4]);
    this._average_rain_intensity = double.parse(words[5]);
    this._average_dry_time = double.parse(words[6]);
    this._average_wet_time = (((_average_dry_time! * 1.15) * 1000).round()) / 1000;
    this._straights_amount = int.parse(words[7]);
    for(int i = 8; i < 8 + straights_amount!; i++)
      this._straights_length.add(double.parse(words[i]));
    this._braking_zones_amount = int.parse(words[8 + straights_amount!]);
    this._corners = Corners(slow_corners_amount: int.parse(words[8 + straights_amount! + 1]),
                            medium_corners_amount: int.parse(words[8 + straights_amount! + 2]),
                            fast_corners_amount: int.parse(words[8 + straights_amount! + 3]));
  }

  void print() {
    stdout.write("${this._name}, ${this._nation}\n");
    stdout.write("- weather:\n\train probability = ${this._rain_probability}\n\train intensity = ${this._average_rain_intensity}, ");
    stdout.write("\n\taverage dry laptime = ${this._average_dry_time}s\n\taverage wet laptime = ${this._average_wet_time}s\n");
    stdout.write("- characteristics:\n\ttrack length = ${this._length}\n\tstraights amount = ${this._straights_amount}, lengths = ${this._straights_length}");
    stdout.write("\n\tbraking zones amount = ${this._braking_zones_amount}\n\t");
    stdout.write("corners: slow = ${this._corners.slow_corners_amount}, medium = ${this._corners.medium_corners_amount}, ");
    stdout.write("fast = ${this._corners.fast_corners_amount}\n");
  }

  //setters
  void set name(String? track_name) {
    if(track_name == null) init(get_uniform_double(1, tracks_amount.toDouble()).round());
    else {
      List<String>? words;
      int counter = 0;
      File fp = File("tracks.csv");
      List<String> lines = fp.readAsLinesSync();

      for(counter = 1; counter < lines.length; counter++) {
        words = lines[counter].split(',');
        if(words[1].toLowerCase() == track_name.toLowerCase()) break;
      }
    
      if(counter < lines.length) init(counter);
    }
  }
  
  //getters
  String? get name => _name;
  String? get nation => _nation;
  double? get length => _length;
  double? get rain_probability => _rain_probability;
  double? get average_rain_intensity => _average_rain_intensity;
  double? get average_dry_time => _average_dry_time;
  double? get average_wet_time => _average_wet_time;
  int? get straights_amount => _straights_amount;
  List<double> get straights_length => _straights_length;
  int? get braking_zones_amount => _braking_zones_amount;
  Corners get corners => _corners;
}



class Weather {
  //attributes
  double? _dry;
  double? _wet;

  //constructors
  Weather(Track track, {double? wet}) {
    if(wet == null) {
      if(get_uniform_double(0, 1) < track.rain_probability!) {
        this._wet = ((min(max(get_gaussian_double(track.average_rain_intensity!, 0.035), 0.1), 1) * 100).round()) / 100;
        this._dry = ((1 - this._wet!) * 100).round() / 100;
        return;
      }
    }
    else {
      if(0 <= wet && wet <= 1) {
        this._wet = wet;
        this._dry = ((1 - this._wet!) * 100).round() / 100;
        return;
      }
    }   
    this._wet = 0;
    this._dry = 1;
  }
  
  Weather.Null() {}

  //methods
  void print() {
    stdout.write("weather: dry level = ${this._dry}, wet level = ${this._wet}\n");
  }

  //setters
  void set wet(double? value) {
    if(0 <= value! && value <= 1) {
      this._wet = value;
      this._dry = 1 - value;
    }
  }
  
  void set dry(double? value) {
    if(0 <= value! && value <= 1) {
      this._dry = value;
      this._wet = 1 - value;
    }
  }

  //getters
  double? get wet => this._wet;
  double? get dry => this._dry;
}