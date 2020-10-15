package com.vanillaapps.saber;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Intent;
import android.os.Build;
import io.flutter.app.FlutterApplication;

public class Application extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();
//        FlutterFirebaseMessagingService.setPluginRegistrant(this);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationManager notificationManager = (NotificationManager) getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(
                    new NotificationChannel(Constants.getInstance().packageName,
                            Constants.getInstance().noitfyChannelId,
                            NotificationManager.IMPORTANCE_LOW));
        }
        Intent bgServiceIntent = new Intent(this,
                BackgroundService.class);
        bgServiceIntent.putExtra(Constants.getInstance().signedInUserId,"");
        bgServiceIntent.putExtra(Constants.getInstance().passwordId,"");
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(bgServiceIntent);
        }
    }

//    @Override
//    public void registerWith(PluginRegistry registry) {
//        GeneratedPluginRegistrant.registerWith();
//    }

    @Override
    public void onTerminate() {
        super.onTerminate();
    }


}