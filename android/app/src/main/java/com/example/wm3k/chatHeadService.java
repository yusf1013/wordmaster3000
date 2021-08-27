package com.example.wm3k;

import android.app.Dialog;
import android.app.Service;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.os.IBinder;
import android.view.GestureDetector;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import androidx.annotation.Nullable;

public class chatHeadService extends Service {

    private View chatHeadView;
    private WindowManager windowManager;
    Button closePopUp;
    Dialog popUp;

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate(){
        super.onCreate();

        chatHeadView= LayoutInflater.from(this).inflate(R.layout.chathead,null);
        final Button button= new Button(chatHeadService.this);
        button.setText("close");
        final RelativeLayout layout=chatHeadView.findViewById(R.id.chat_head_root);

        popUp=new Dialog(this);

        final WindowManager.LayoutParams params = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT);

        params.gravity= Gravity.TOP | Gravity.LEFT;
        params.x=0;
        params.y=100;


        windowManager= (WindowManager) getSystemService(WINDOW_SERVICE);
        windowManager.addView(chatHeadView,params);

        final ImageView chatHeadImage= chatHeadView.findViewById(R.id.chat_head_profile);
        chatHeadImage.setOnTouchListener(new View.OnTouchListener() {

            private int initialx;
            private int initialy;
            private float touchedx;
            private float touchedy;
            private int lastaction;
            private int chk=1;
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if(event.getAction() == MotionEvent.ACTION_DOWN){
                    initialx=params.x;
                    initialy=params.y;
                    touchedx=  event.getRawX();
                    touchedy=  event.getRawY();

                    lastaction= event.getAction();
                    System.out.println("it is in down");

                    return true;
                }

                else if(event.getAction() == MotionEvent.ACTION_UP){
                    if(lastaction == MotionEvent.ACTION_DOWN || lastaction == MotionEvent.ACTION_MOVE){
                        System.out.println("it is in up");

                        if(chk==1){
                            layout.addView(button);
                            showPOPup();
                            chk=2;
                        }

                        else if(chk==2){
                            layout.removeView(button);
                            chk=1;
                        }
                        System.out.println(chk);
                        button.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                stopSelf();
                            }
                        });

                    }

                    lastaction = event.getAction();
                    System.out.println("it has finished up");

                    return true;
                }

                else if(event.getAction() == MotionEvent.ACTION_MOVE){

                    params.x = initialx + (int) (event.getRawX() - touchedx);
                    params.y = initialy + (int) (event.getRawY() - touchedy);

                    windowManager.updateViewLayout(chatHeadView, params);
                    lastaction = event.getAction();
                    System.out.println("it is in move");

                    return true;
                }
                return false;
            }

        });
    }

    public void showPOPup(){
        System.out.println("it is being called");
        //popUp.setContentView(R.layout.dialouge);
        startService(new Intent(chatHeadService.this, popUpCard.class));
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (chatHeadView != null) windowManager.removeView(chatHeadView);
    }
}
