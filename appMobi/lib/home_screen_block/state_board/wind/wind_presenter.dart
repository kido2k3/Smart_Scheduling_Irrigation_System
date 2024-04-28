import 'dart:convert';

import '../../../model/adafruit_server.dart';
import '../../../model/network/http_help.dart';
import '../../../mvp/presenter.dart';
import 'package:app_mobi/home_screen_block/state_board/wind/wind_view.dart';

WindPresenter windPresenter = WindPresenter();

class WindPresenter extends Presenter<WindView>{
  void changeValue(double val){
    isViewAttached ? getView().updateData(val) : null;
  }
  Future<void> getValue() async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 5));
    String url = "https://io.adafruit.com/api/v2/kido2k3/feeds/iot-humidity";
    var response = await adafruitServer.httpHelper.fetchText(url);
    if (NetworkUtils.isReqSuccess(response)) {
      String text = response.body;
      final jsonData = await json.decode(text);
      final val = jsonData["last_value"];
      print(val);
      isViewAttached ? getView().updateData(double.parse(val)) : null;
    } else {
      isViewAttached ? getView().onFailLoadUpdate() : null;
    }
  }
}