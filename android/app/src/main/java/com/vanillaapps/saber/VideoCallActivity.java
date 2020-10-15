package com.vanillaapps.saber;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;

import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.snackbar.Snackbar;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.fragment.app.FragmentActivity;

import android.os.IBinder;

import io.flutter.plugin.common.MethodChannel;

public class VideoCallActivity extends FragmentActivity {

    BackgroundService backgroundService;
    String callUsername;
    FragmentActivity fragmentActivity;
    Boolean mBound;

    ServiceConnection serviceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            backgroundService = ((BackgroundService.LocalBinder)service).getService();
            backgroundService.makeCall(callUsername, new MethodChannel.Result() {
                @Override
                public void success(@Nullable Object result) {

                }

                @Override
                public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {

                }

                @Override
                public void notImplemented() {

                }
            });
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            backgroundService = null;
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_call);
        fragmentActivity = this;
        callUsername = getIntent().getExtras().getString(Constants.getInstance().callerUsernameId);
        Intent backgroundServiceIntent = new Intent(this, BackgroundService.class);
        startService(backgroundServiceIntent);
        mBound = bindService(backgroundServiceIntent, serviceConnection, Context.BIND_AUTO_CREATE);
//        if(mBound){
//            System.out.println("BACKGROUND_SERVICE: "+backgroundService);
//            System.out.println("BACKGROUND_SERVICE MJSIP: "+backgroundService.mjSipCallerUtility);
////            backgroundService.makeVideoCall("100", R.id.user_video_view, this);
//        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        if(mBound) {
            unbindService(serviceConnection);
            mBound = false;
        }
    }
}