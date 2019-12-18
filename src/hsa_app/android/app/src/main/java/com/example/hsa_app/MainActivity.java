package com.example.hsa_app;

import android.os.Bundle;

import com.umeng.analytics.MobclickAgent;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }

  public void onResume() {
    super.onResume();
    MobclickAgent.onResume(this);

  }

  public void onPause() {
    super.onPause();
    MobclickAgent.onPause(this);
  }


}
