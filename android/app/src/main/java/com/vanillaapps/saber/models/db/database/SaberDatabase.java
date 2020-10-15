package com.vanillaapps.saber.models.db.database;

import android.content.Context;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;

import com.vanillaapps.saber.models.db.entities.Call;
import com.vanillaapps.saber.models.db.daos.CallDao;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


@Database(entities = {Call.class}, version = 3, exportSchema = false)
abstract public class SaberDatabase extends RoomDatabase {

    public abstract CallDao callDao();

    private static volatile SaberDatabase INSTANCE;
    private static final int NUMBER_OF_THREADS = 4;
    public static final ExecutorService databaseWriteExecutor =
            Executors.newFixedThreadPool(NUMBER_OF_THREADS);

    private static final String DB_NAME = "saber_db";
    private static final String DB_PATH = String.format("%s", DB_NAME);

    public static SaberDatabase getDatabase(final Context context) {

        if (INSTANCE == null) {
            synchronized (SaberDatabase.class) {
                if (INSTANCE == null) {
                    INSTANCE = Room.databaseBuilder(context.getApplicationContext(),
                            SaberDatabase.class, DB_PATH)
                            .build();
                }
            }
        }
        return INSTANCE;
    }
}
