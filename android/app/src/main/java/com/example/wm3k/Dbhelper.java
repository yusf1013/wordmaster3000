package com.example.wm3k;

import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.Nullable;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class Dbhelper extends SQLiteOpenHelper {

    String DB_PATH = null;
    private static String DB_NAME = "WMK3000.db";
    private SQLiteDatabase myDataBase;
    private final Context myContext;

    public Dbhelper(Context context) {
        super(context, DB_NAME, null, 10);
        this.myContext = context;
       this.DB_PATH = "/data/data/" + context.getPackageName() + "/" + "databases/";
        //this.DB_PATH =context.getDatabasePath(DB_NAME).getAbsolutePath();
       // Log.e("Path 1", DB_PATH);
    }

    public void createDataBase() throws IOException {
        this.getReadableDatabase();
        try {
            copyDataBase();
            System.out.println("database is copied");
        } catch (IOException e) {
            throw new Error("Error copying database");
        }
        boolean dbExist = checkDataBase();
        System.out.println("result of check for db is "+dbExist);
        if (dbExist) {
        } else {

        }
    }

    public boolean checkDataBase() {
        SQLiteDatabase checkDB = null;
        try {
            String myPath = DB_PATH + DB_NAME;
            checkDB = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READONLY);
        } catch (SQLiteException e) {
            System.out.println(e.toString());
        }
        if (checkDB != null) {
            checkDB.close();
        }
        return checkDB != null ? true : false;
    }

    private void copyDataBase() throws IOException {
        InputStream myInput = myContext.getAssets().open(DB_NAME);
        String outFileName = DB_PATH + DB_NAME;
        OutputStream myOutput = new FileOutputStream(outFileName);
        byte[] buffer = new byte[1024];
        int length;
        while ((length = myInput.read(buffer)) > 0) {
            myOutput.write(buffer, 0, length);
            System.out.println("data base is being copied");
        }
        myOutput.flush();
        myOutput.close();
        myInput.close();

    }

    public void openDataBase() throws SQLException {
        String myPath = DB_PATH + DB_NAME;
        myDataBase = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READONLY);
        System.out.println("Db is opened");

    }

    @Override
    public synchronized void close() {
        if (myDataBase != null)
            myDataBase.close();
        super.close();
    }


    @Override
    public void onCreate(SQLiteDatabase db) {
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }

    public boolean UpdateWordData(String search) {
        String maintainserach=search.toLowerCase();
        String word,pos,meaning,submeaning="";
        boolean b=false;
        int id;
        Cursor res = this.getReadableDatabase().rawQuery("select * from Word where word='"+maintainserach+"'",null);
        if(res != null){
            if(res.moveToFirst()){
                b=true;
                word=res.getString(0);
                pos=res.getString(2);
                meaning=res.getString(3);
                id= Integer.parseInt(res.getString(1));
                Cursor submeanres= this.getReadableDatabase().rawQuery("select * from SubMeaning where id="+id,null);
                if(submeanres.moveToFirst()){
                    submeaning=submeanres.getString(2);
                }
                MainActivity.word=word;
                MainActivity.parts_of_speech=pos;
                MainActivity.meaning=meaning;
                MainActivity.submeaning=submeaning;
            }
        }
        return b;
    }
}
