import 'dart:io';
import 'driver.dart';

void write_drivers_to_file(String path) {
  File file = File(path);
  var sink = file.openWrite();

  sink.write("#,name,surname,gender,age,nationality,height,weight,potential,ability,cornering,braking,");
  sink.write("race_pace,qualifying_pace,dry_pace,wet_pace,attack,defense,consistency,experience\n");

  for(int i = 0; i < drivers_amount; i++) {
    sink.write("$i,${drivers_list[i].personal_info.name},${drivers_list[i].personal_info.surname},");
    sink.write("${drivers_list[i].personal_info.gender},${drivers_list[i].personal_info.nationality},");
    sink.write("${drivers_list[i].personal_info.height},${drivers_list[i].personal_info.weight},");
    sink.write("${drivers_list[i].racing_stats.potential},${drivers_list[i].racing_stats.ability},");
    sink.write("${drivers_list[i].racing_stats.cornering},${drivers_list[i].racing_stats.braking},");
    sink.write("${drivers_list[i].racing_stats.pace.race},${drivers_list[i].racing_stats.pace.qualifying},");
    sink.write("${drivers_list[i].racing_stats.pace.dry},${drivers_list[i].racing_stats.pace.wet},");
    sink.write("${drivers_list[i].racing_stats.attack},${drivers_list[i].racing_stats.defense},");
    sink.write("${drivers_list[i].racing_stats.consistency},${drivers_list[i].racing_stats.experience}\n");
  }

  sink.close();
}



List<String> build_list_from_csv(String path, {int row = 0, int column = 0}) {
  File file = File(path);
  List<String> lines = file.readAsLinesSync(), list = [];

  for(int i = row; i < lines.length; i++) {
    var words = lines[i].split(',');
    list.add(words[column]);
  }

  return list;
}