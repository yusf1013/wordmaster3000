package com.example.wm3k;

import android.app.Service;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.os.IBinder;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.Nullable;

public class popUpCard extends Service {
    private WindowManager wm;
    private View dialougeview;
    Button closePopUp,detailsbutton;
    TextView t1,t2,t3;


    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        dialougeview= LayoutInflater.from(this).inflate(R.layout.dialouge,null);

        final WindowManager.LayoutParams params = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT);

        params.gravity= Gravity.TOP | Gravity.LEFT;
        params.x=35;
        params.y=400;

        wm= (WindowManager) getSystemService(WINDOW_SERVICE);
        wm.addView(dialougeview,params);


        t1=(TextView) dialougeview.findViewById(R.id.word_text_id);
        t1.setText(MainActivity.word);
        String t2_view="{ "+MainActivity.parts_of_speech+" } : "+MainActivity.meaning;
        t2=(TextView) dialougeview.findViewById(R.id.pos_mean);
        t2.setText(t2_view);
        t3=(TextView) dialougeview.findViewById(R.id.meaning_details);
        t3.setText(MainActivity.submeaning);


        closePopUp= (Button) dialougeview.findViewById(R.id.closeButton);
        closePopUp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                System.out.println("close button clicked");
                wm.removeView(dialougeview);
                stopSelf();

            }
        });
    }
}
