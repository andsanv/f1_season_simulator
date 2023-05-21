import '../include/driver.dart';
import '../include/io.dart';
import '../include/session.dart';
import '../include/environment.dart';


const String namesCsvPath = "../../data/ita_names.csv";
const String surnamesCsvPath = "../../data/ita_surnames.csv";


void main() {
  surnames = buildListFromCsv(surnamesCsvPath, row: 1, column: 1);
  names = buildListFromCsv(namesCsvPath, row: 1, column: 0);

  driversList = createRandomDriversList(driversAmount);
  
  Track tr = Track("Sakhir");
  Weather weather = Weather(tr, wet: 0);
  Qualifying quali = Qualifying(driversList, tr, weather);

  quali.start();
  quali.leaderboard.print();

  return;
}