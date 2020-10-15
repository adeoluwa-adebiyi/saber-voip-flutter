package com.vanillaapps.saber.models.db.daos;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;

import com.vanillaapps.saber.models.db.entities.Call;

import java.util.List;

@Dao
public interface CallDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void insertCall(Call call);

    @Query("SELECT * FROM call_table ORDER BY timestamp DESC")
    List<Call> getAll();

    @Query("DELETE FROM call_table")
    void deleteAll();
}
