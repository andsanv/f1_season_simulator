//import 'distribution.dart';
import 'dart:io';
import 'dart:math';

import 'helpers.dart';

int tracksAmount = 7;
const List<String> officialTrackNames = ["sakhir", "jeddah", "melbourne", "baku", "miami", "imola", "monza"];


class Corners {
  //attributes
  int slowCornersAmount = -1;
  int mediumCornersAmount = -1;
  int fastCornersAmount = -1;

  //constructors
  Corners({int slowCornersAmount = 0, int mediumCornersAmount = 0, int fastCornersAmount = 0}) {
    this.slowCornersAmount = (0 <= slowCornersAmount) ? slowCornersAmount : 0;
    this.mediumCornersAmount = (0 <= mediumCornersAmount) ? mediumCornersAmount : 0;
    this.fastCornersAmount = (0 <= fastCornersAmount) ? fastCornersAmount : 0;
  }
}



class Track {
  //attributes
  String _name = "";
  String _nation = "";
  double _length = -1;

  double _rainProbability = -1;
  double _averageRainIntensity = -1;

  double _averageDryTime = -1;
  double _averageWetTime = -1;

  int _straightsAmount = -1;
  List<double> _straightsLength = [];
  int _brakingZonesAmount = -1;
  late Corners _corners;


  //constructors
  Track(String trackName) {
    if(inList(officialTrackNames, trackName.replaceAll(" ", "").toLowerCase())) {
      List<String> words = [];
      int counter = 0;
      File fp = File("tracks.csv");
      List<String> lines = fp.readAsLinesSync();

      for(counter = 1; counter < lines.length; counter++) {
        words = lines[counter].split(',');
        if(words[1].toLowerCase() == trackName.toLowerCase()) break;
      }
    
      if(counter < lines.length) init(counter);
    }

    else init(getUniformDouble(1, tracksAmount.toDouble()).round()); 
  }

  Track.Random() { init(getUniformDouble(1, tracksAmount.toDouble()).round()); }


  //methods
  void init(int counter) {
    File fp = File("tracks.csv");
    List<String> lines = fp.readAsLinesSync(), words = lines[counter].split(',');

    this._name = words[1];
    this._nation = words[2];
    this._length = double.parse(words[3]);
    this._rainProbability = double.parse(words[4]);
    this._averageRainIntensity = double.parse(words[5]);
    this._averageDryTime = double.parse(words[6]);
    this._averageWetTime = (((_averageDryTime * 1.15) * 1000).round()) / 1000;
    this._straightsAmount = int.parse(words[7]);
    for(int i = 8; i < 8 + straightsAmount; i++)
      this._straightsLength.add(double.parse(words[i]));
    this._brakingZonesAmount = int.parse(words[8 + straightsAmount]);
    this._corners = Corners(slowCornersAmount: int.parse(words[8 + straightsAmount + 1]),
                            mediumCornersAmount: int.parse(words[8 + straightsAmount + 2]),
                            fastCornersAmount: int.parse(words[8 + straightsAmount + 3]));
  }

  void print() {
    stdout.write("${this._name}, ${this._nation}\n");
    stdout.write("""- weather:\n\train probability = ${this._rainProbability}
    \train intensity = ${this._averageRainIntensity}, """);
    stdout.write("""\n\taverage dry laptime = ${this._averageDryTime}s
    \taverage wet laptime = ${this._averageWetTime}s\n""");
    stdout.write("""- characteristics:\n\ttrack length = ${this._length}
    \tstraights amount = ${this._straightsAmount}, lengths = ${this._straightsLength}""");
    stdout.write("\n\tbraking zones amount = ${this._brakingZonesAmount}\n\t");
    stdout.write("corners: slow = ${this._corners.slowCornersAmount}, ");
    stdout.write("medium = ${this._corners.mediumCornersAmount}, ");
    stdout.write("fast = ${this._corners.fastCornersAmount}\n");
  }

  //setters
  void set name(String trackName) {
    if(inList(officialTrackNames, trackName.replaceAll(" ", "").toLowerCase())) {
      List<String> words = [];
      int counter = 0;
      File fp = File("tracks.csv");
      List<String> lines = fp.readAsLinesSync();

      for(counter = 1; counter < lines.length; counter++) {
        words = lines[counter].split(',');
        if(words[1].toLowerCase() == trackName.toLowerCase()) break;
      }
    
      if(counter < lines.length) init(counter);
    }

    else init(getUniformDouble(1, tracksAmount.toDouble()).round()); 
  }
  
  //getters
  String get name => _name;
  String get nation => _nation;
  double get length => _length;
  double get rainProbability => _rainProbability;
  double get averageRainIntensity => _averageRainIntensity;
  double get averageDryTime => _averageDryTime;
  double get averageWetTime => _averageWetTime;
  int get straightsAmount => _straightsAmount;
  List<double> get straightsLength => _straightsLength;
  int get brakingZonesAmount => _brakingZonesAmount;
  Corners get corners => _corners;
}



class Weather {
  //attributes
  double _dry = -1;
  double _wet = -1;

  //constructors
  Weather(Track track, {double wet = -1}) {
    if(wet == -1) {
      if(getUniformDouble(0, 1) < track.rainProbability) {
        this._wet = roundTo2Decimals(min(max(getGaussianDouble(track.averageRainIntensity, 0.035), 0.1), 1));
        this._dry = roundTo2Decimals(1 - this._wet);
        return;
      }
    }
    else {
      if(0 <= wet && wet <= 1) {
        this._wet = wet;
        this._dry = roundTo2Decimals(1 - this._wet);
        return;
      }
    }   
    this._wet = 0;
    this._dry = 1;
  }


  //methods
  void print() { stdout.write("weather: dry level = ${this._dry}, wet level = ${this._wet}\n"); }


  //setters
  void set wet(double? value) {
    if(0 <= value! && value <= 1) {
      this._wet = value;
      this._dry = roundTo2Decimals(1 - this._wet);
    }
  }
  
  void set dry(double? value) {
    if(0 <= value! && value <= 1) {
      this._dry = value;
      this._wet = roundTo2Decimals(1 - this._dry);
    }
  }

  //getters
  double get wet => this._wet;
  double get dry => this._dry;
}