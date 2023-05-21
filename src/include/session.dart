import 'dart:math';
import 'dart:io';

import 'car.dart';
import 'driver.dart';
import 'environment.dart';
import 'helpers.dart';




// Year {
//   Standings {
//     Positions[20] {
//       driver
//       team
//       points
//     }
//   }
//
//   events[20] {
//     track
//     weather
//     qualifying {
//        leaderboard

//     }
//     race {
//      
//     }
//   }
// }


class Position {
  //attributes
  late Driver _driver;
  late double _laptime;

  //constructors
  Position({Driver? driver, double? laptime}) {
    this._driver = (driver != null) ? driver : Driver();
    this._laptime = (laptime != null) ? laptime : -1;
  }

  //setters
  void set driver(Driver value) => this._driver = value;
  void set laptime(double value) => this._laptime = (value > 0) ? value : -1;

  //getters
  Driver get driver => this._driver;
  double get laptime => this._laptime;
}


class SingleLapLeaderboard {
  //attributes
  List<Position> _positions = [];
  bool _initialized = false;

  //constructors

  //methods
  void init(List<Driver> driversList) {
    for(int i = 0; i < driversAmount; i++) this._positions.add(Position(driver: driversList[i], laptime: 0));

    for(int i = 0; i < driversAmount - 1; i++)
      for(int j = i + 1; j < driversAmount; j++) {
        if((this._positions[i].driver.personalInfo.surname.compareTo(this._positions[j].driver.personalInfo.surname)) > 0) {
          Position temp = Position(driver: this._positions[j]._driver, laptime: this._positions[j]._laptime);
          this._positions[j]._driver = this._positions[i]._driver;
          this._positions[j]._laptime = this._positions[i]._laptime;
          this._positions[i]._driver = temp.driver;
          this._positions[i]._laptime = temp.laptime;
        }
        else if((this._positions[i].driver.personalInfo.surname.compareTo(this._positions[j].driver.personalInfo.surname)) == 0) {
          if((this._positions[i].driver.personalInfo.name.compareTo(this._positions[j].driver.personalInfo.name)) > 0) {
            Position temp = Position(driver: this._positions[j]._driver, laptime: this._positions[j]._laptime);
            this._positions[j]._driver = this._positions[i]._driver;
            this._positions[j]._laptime = this._positions[i]._laptime;
            this._positions[i]._driver = temp.driver;
            this._positions[i]._laptime = temp.laptime;
          }
          else continue;
        }
      }

    this._initialized = true;
  }

  void update(Position new_laptime) {
    if(this._positions[0].driver == new_laptime.driver) {
      if(0 <= new_laptime.laptime && new_laptime.laptime <= this._positions[0].laptime || positions[0].laptime == -1) this._positions[0].laptime = new_laptime.laptime;
    }
    else {
      int target_bottom = 0;
      for(Position position in this._positions) {
        if(position.driver != new_laptime.driver) target_bottom += 1;
        else break;
      }

      int target_top = 0;
      for(Position position in this._positions) {
        if(0 <= new_laptime.laptime && position.laptime <= new_laptime.laptime && position.laptime != 0) target_top += 1;
        else break;
      }

      if(target_top < target_bottom) {
        for(int i = target_bottom; i > target_top; i--) positions[i] = positions[i - 1]; 
        this._positions[target_top] = new_laptime;
      }
      else if(target_top == target_bottom) this._positions[target_top].laptime = new_laptime.laptime;
    }
  }

  void print() {
    stdout.write("LEADERBOARD\n");
    int counter = 1, tabs_needed = 2;

    for(Position position in this._positions) {
      tabs_needed = 2;
      if(counter < 10) stdout.write("0");
      stdout.write("$counter: ${position.driver.personalInfo.name[0]}. ");
      stdout.write("${position.driver.personalInfo.surname}");
      if(position.driver.personalInfo.surname.length >= 9) tabs_needed = 1;
      stdout.write("\t" * tabs_needed);
      stdout.write("${roundTo3Decimals(position.laptime)}");
      stdout.write("\t \t(${position.driver.racingStats.braking}, ${position.driver.racingStats.cornering})\t\t${position.driver.personalInfo.currentTeam!.teamName}\n");
      counter++;
    }
    stdout.write("\n");
  }

  //setters

  //getters
  List<Position> get positions => this._positions;
  bool get initialized => this._initialized;
}

// class OnTrackGapLeaderboard {}


class Qualifying {
  //attributes
  late List<Driver> _driversList;
  late Track _track;
  late Weather _weather;
  SingleLapLeaderboard _leaderboard = SingleLapLeaderboard();


  //constructors
  Qualifying(List<Driver> driversList, Track track, Weather weather) {
    this._driversList = driversList;
    this._track = track;
    this._weather = weather;
    (this._leaderboard = SingleLapLeaderboard()).init(this._driversList);
  }

  //methods
  void simulate() {
    for(Driver driver in driversList) {
      this._leaderboard.update(Position(driver: driver, laptime: get_laptime(driver,
                                                                             this._track,
                                                                             this._weather)));
    }
    for(Driver driver in driversList) {
      this._leaderboard.update(Position(driver: driver, laptime: get_laptime(driver, this._track, this._weather)));
    }
  }

  double get_laptime(Driver driver, Track track, Weather weather) {
    double cornersDelta = 0, straightsDelta = 0, brakingDelta = 0;

    for(int isc = 0, imc = 0, ifc = 0, ist = 0, ibz = 0;
        isc < track.corners.slowCornersAmount || imc < track.corners.mediumCornersAmount || ifc < track.corners.fastCornersAmount
        || ist < track.straightsAmount || ibz < track.brakingZonesAmount;
        isc++, imc++, ifc++, ist++, ibz++) {
      cornersDelta += (isc < track.corners.slowCornersAmount) ?
        (defaultStat - driver.racingStats.cornering) * 0.16 + (defaultStat - driver.personalInfo.currentTeam!.car.chassis) * 0.24
        + weather.wet * ((defaultStat - driver.racingStats.pace.wet) / 0.25) * 0.1 : 0;

      cornersDelta += (imc < track.corners.mediumCornersAmount) ? 
        (defaultStat - driver.racingStats.cornering) * 0.16 +
        (defaultStat * 2 - driver.personalInfo.currentTeam!.car.chassis - driver.personalInfo.currentTeam!.car.downforce) * 0.24
        + weather.wet * ((defaultStat - driver.racingStats.pace.wet) / 0.25) * 0.1 : 0;

      cornersDelta += (ifc < track.corners.fastCornersAmount) ? 
        (defaultStat - driver.racingStats.cornering) * 0.16 + (defaultStat - driver.personalInfo.currentTeam!.car.downforce) * 0.24
        + weather.wet * ((defaultStat - driver.racingStats.pace.wet) / 0.25) * 0.1 : 0;
      
      straightsDelta += (ist < track.straightsAmount) ?
        (defaultStat * 2 - driver.personalInfo.currentTeam!.car.engine - driver.personalInfo.currentTeam!.car.efficiency) *
        track.straightsLength[ist] * 0.8 : 0;

      brakingDelta += (ibz < track.brakingZonesAmount) ? 
        (defaultStat - driver.racingStats.braking) * 0.16 +
        (defaultStat * 2 - driver.personalInfo.currentTeam!.car.chassis - driver.personalInfo.currentTeam!.car.downforce) * 0.24 +
        weather.wet * ((defaultStat - driver.racingStats.pace.wet) / 0.25) * 0.1 : 0;
    }

    double trackDelta = cornersDelta + straightsDelta + brakingDelta;
    double perfectTime = track.averageDryTime * weather.dry + track.averageWetTime  * weather.wet + trackDelta;
    double actualTime = perfectTime + (trackDelta - getGaussianDouble(cornersDelta + straightsDelta + brakingDelta, (39 - 38 * driver.racingStats.consistency) / 200)).abs();

    return roundTo3Decimals(actualTime);
  }


  //setters

  //getters
  SingleLapLeaderboard get leaderboard => this._leaderboard;
}
