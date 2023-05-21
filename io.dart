import 'dart:io';
import 'driver.dart';

void writeDriversToFile(String path) {
  File file = File(path);
  var sink = file.openWrite();

  sink.write("#,name,surname,gender,age,nationality,height,weight,potential,ability,cornering,braking,");
  sink.write("race_pace,qualifying_pace,dry_pace,wet_pace,attack,defense,consistency,experience\n");

  for(int i = 0; i < driversAmount; i++) {
    sink.write("$i,${driversList[i].personalInfo.name},${driversList[i].personalInfo.surname},");
    sink.write("${driversList[i].personalInfo.gender},${driversList[i].personalInfo.nationality},");
    sink.write("${driversList[i].personalInfo.height},${driversList[i].personalInfo.weight},");
    sink.write("${driversList[i].racingStats.potential},${driversList[i].racingStats.ability},");
    sink.write("${driversList[i].racingStats.cornering},${driversList[i].racingStats.braking},");
    sink.write("${driversList[i].racingStats.pace.race},${driversList[i].racingStats.pace.qualifying},");
    sink.write("${driversList[i].racingStats.pace.dry},${driversList[i].racingStats.pace.wet},");
    sink.write("${driversList[i].racingStats.attack},${driversList[i].racingStats.defense},");
    sink.write("${driversList[i].racingStats.consistency},${driversList[i].racingStats.experience}\n");
  }

  sink.close();
}



List<String> buildListFromCsv(String path, {int row = 0, int column = 0}) {
  File file = File(path);
  List<String> lines = file.readAsLinesSync(), list = [];

  for(int i = row; i < lines.length; i++) {
    var words = lines[i].split(',');
    list.add(words[column]);
  }

  return list;
}