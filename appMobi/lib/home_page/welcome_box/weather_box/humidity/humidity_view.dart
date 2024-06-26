
import 'package:app_mobi/mvp/mvp_view.dart';

abstract class DataView extends MvpView{
  void updateHumidityData(double value);
  void onFailUpdate();
}
abstract class BoolView extends MvpView{
  void updateBool(bool value);
  void onFailUpdate();
}
abstract class HumidityView  extends DataView{

}