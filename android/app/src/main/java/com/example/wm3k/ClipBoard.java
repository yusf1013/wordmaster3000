package com.example.wm3k;

import android.app.Service;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Intent;
import android.database.SQLException;
import android.os.IBinder;

import java.io.IOException;

public class ClipBoard extends Service {
    private ClipboardManager clipcheckmanager;
    IBinder mBinder;
    int mStartMode;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        clipcheckmanager = (ClipboardManager) getSystemService(CLIPBOARD_SERVICE);
        clipcheckmanager.addPrimaryClipChangedListener(new ClipboardManager.OnPrimaryClipChangedListener() {

            @Override
            public void onPrimaryClipChanged() {
               // String newClip = clipcheckmanager.getText().toString();
                //Toast.makeText(getApplicationContext(), newClip.toString(),  Toast.LENGTH_LONG).show();
                //Log.i("LOG", newClip.toString() + "");
                String clipdata="";
                ClipData a=clipcheckmanager.getPrimaryClip();
                ClipData.Item item=a.getItemAt(0);
                clipdata=item.getText().toString();
                if(clipdata.length()<=40){
                    if(clipdata.contains("#") || clipdata.contains("$") || clipdata.contains("*")) {

                    } else{
                        System.out.println("word is " + clipdata);
                        //MainActivity.word=clipdata;
                        Dbhelper myDbHelper= new Dbhelper(ClipBoard.this);

                        try {
                            myDbHelper.openDataBase();
                        } catch (SQLException sqle) {
                            throw new Error("Unable to open db");
                        }
                        if(myDbHelper.UpdateWordData(clipdata)){
                            System.out.println("word found ********************************************");
                            startService(new Intent(ClipBoard.this,chatHeadService.class));
                        }
                        else{
                            System.out.println("Word not found");
                            startService(new Intent(ClipBoard.this,chatHeadService.class));

                        }
                        //System.out.println(MainActivity.word);
                    }
                }
            }
        });
        return mStartMode;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
