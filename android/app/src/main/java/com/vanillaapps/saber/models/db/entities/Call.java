package com.vanillaapps.saber.models.db.entities;

import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity(tableName = "call_table")
public class Call {

    @PrimaryKey(autoGenerate = true)

    public Integer id;

    public String phone;

    public String contactReferenceId;

    public Boolean missed;

    public Boolean rejected;

    public Long timestamp;

    public Boolean synced;

    public Boolean userMade;
}
