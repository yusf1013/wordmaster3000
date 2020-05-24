package com.example.wm3k;

import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.widget.Toast;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
//import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "samples.flutter.dev/bubblehead";
  private static final int PERMISSION_REQUEST_CODE = 2084;

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    //GeneratedPluginRegistrant.registerWith(flutterEngine);
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                    (call, result) -> {
                      // Note: this method is invoked on the main thread.
                      if (call.method.equals("openchathead")) {
                        System.out.println("need to ask permission");
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
                          Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:" + getPackageName()));
                          startActivityForResult(intent, PERMISSION_REQUEST_CODE);
                        }
                        else {
                          showChatHead();
                        }                      }
                    }
            );
  }


  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == PERMISSION_REQUEST_CODE) {
      if (resultCode == RESULT_OK) {
        showChatHead();
        //System.out.println("it is reaching here");
      }
      else {
        Toast.makeText(this,
                "Draw over other app permission not available. Closing the application",
                Toast.LENGTH_SHORT).show();
        //finish();
      }
    }
  }

  public void showChatHead(){
    startService(new Intent(MainActivity.this,chatHeadService.class));
    //finish();
  }
}
