package com.example.wm3k;

import android.app.Service;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Intent;
import android.database.SQLException;
import android.os.Build;
import android.os.IBinder;

import androidx.core.app.NotificationCompat;

import java.io.IOException;

public class ClipBoard extends Service {
    private ClipboardManager clipcheckmanager;
    private boolean dbchker=false;
    IBinder mBinder;
    int mStartMode;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        System.out.println("Ok we are starting");
        clipcheckmanager = (ClipboardManager) getSystemService(CLIPBOARD_SERVICE);
        clipcheckmanager.addPrimaryClipChangedListener(new ClipboardManager.OnPrimaryClipChangedListener() {

            @Override
            public void onPrimaryClipChanged() {
                System.out.println("okkk we have changed");
               // String newClip = clipcheckmanager.getText().toString();
                //Toast.makeText(getApplicationContext(), newClip.toString(),  Toast.LENGTH_LONG).show();
                //Log.i("LOG", newClip.toString() + "");
                String clipdata="";
                ClipData a=clipcheckmanager.getPrimaryClip();
                ClipData.Item item=a.getItemAt(0);
                clipdata=item.getText().toString();
                System.out.println("data has been newly copied *******" + clipdata);
                if(clipdata.length()<=40){
                    System.out.println("data has been newly copied *******" +clipdata.length());
                    if(clipdata.contains("#") || clipdata.contains("$") || clipdata.contains("*")) {
                        System.out.println("got out due to # $ *");
                    } else{
                        System.out.println("word is " + clipdata);
                        //MainActivity.word=clipdata;
                        Dbhelper myDbHelper= new Dbhelper(ClipBoard.this);

                        try {
                            myDbHelper.openDataBase();
                            dbchker=true;
                        } catch (SQLException sqle) {
                            throw new Error("Unable to open db");
                        }
                        if(myDbHelper.UpdateWordData(clipdata)){
                            System.out.println("word found ********************************************");
                            startService(new Intent(ClipBoard.this,popUpCard.class));
                        }
                        else{
                            System.out.println("Word not found");
                            startService(new Intent(ClipBoard.this,popUpCard.class));

                        }
                        if(dbchker==true) myDbHelper.close();
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
