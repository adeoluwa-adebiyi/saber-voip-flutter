package com.vanillaapps.saber;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.vanillaapps.saber.models.AppEvent;
import com.vanillaapps.saber.models.db.entities.Call;
import com.vanillaapps.saber.models.db.daos.CallDao;
import com.vanillaapps.saber.models.db.database.SaberDatabase;

import java.util.Date;

import butterknife.BindView;
import butterknife.ButterKnife;
import io.flutter.plugin.common.MethodChannel;
import io.reactivex.rxjava3.annotations.NonNull;
import io.reactivex.rxjava3.core.Observer;
import io.reactivex.rxjava3.disposables.CompositeDisposable;
import io.reactivex.rxjava3.disposables.Disposable;
import io.reactivex.rxjava3.subjects.PublishSubject;

public class IncomingCallActivity extends AppCompatActivity {

    @BindView(R2.id.microphone_btn)
    protected LinearLayout muteToggleButton;

    @BindView(R2.id.end_call_btn)
    protected LinearLayout endCallBtn;

    @BindView(R2.id.accept_call_btn)
    protected LinearLayout acceptToggleButton;

    @BindView(R2.id.video_call_btn)
    protected LinearLayout videoCamToggleButton;

    @BindView(R2.id.in_contact_phone_display)
    protected TextView callingUser;

    EventQueue appEventQueue;

    boolean mBound = false;

    boolean mute = false;

    boolean video = false;

    boolean accept = false;

    String callerUsername = "";

    BackgroundService backgroundService;

    Observer<AppEvent> appEventObserver = new Observer<AppEvent>() {
        @Override
        public void onSubscribe(@NonNull Disposable d) {

        }

        @Override
        public void onNext(@NonNull AppEvent appEvent) {
            handleEndCallEvent();
        }

        @Override
        public void onError(@NonNull Throwable e) {

        }

        @Override
        public void onComplete() {

        }
    };

    ServiceConnection backgroundServiceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            backgroundService = ((BackgroundService.LocalBinder)service).getService();

            muteToggleButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    toggleMute(backgroundService);
                }
            });

            acceptToggleButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    callAccpted = true;
                    toggleAccept(backgroundService);
                    acceptToggleButton.setVisibility(View.GONE);
                }
            });

            endCallBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    backgroundService.endCall(new MethodChannel.Result() {
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
            });

            videoCamToggleButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    toggleVideo(backgroundService);
                }
            });

            ((SIPEventsReactor)backgroundService).registerAppNotifierObserver(appEventObserver);

            callerUsername = backgroundService.getCurrentCallerUsername();

            callingUser.setText(callerUsername);

        }

        @Override
        public void onServiceDisconnected(ComponentName name) {

        }
    };

    PublishSubject<AppEvent> serviceEventStream;

    SaberDatabase db;

    CallDao callDao;


    CompositeDisposable disposable = new CompositeDisposable();
    private boolean callAccpted = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_incoming_call_fullscreen);
        ButterKnife.bind(this);
        Intent backgroundServiceIntent = new Intent(this, BackgroundService.class);
        appEventQueue = EventQueue.getInstance();
        mBound = bindService(backgroundServiceIntent, backgroundServiceConnection, Context.BIND_AUTO_CREATE);
        db = SaberDatabase.getDatabase(getApplicationContext());
        callDao = db.callDao();
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onPause() {
        super.onPause();
        if(mBound) {
            unbindService(backgroundServiceConnection);
        }
    }

    void logAccepted(){
        SaberDatabase.databaseWriteExecutor.execute(() -> {
            Date date = new Date();
            //This method returns the time in millis
            long timeMilli = date.getTime();
            Call call = new Call();
            call.phone = callerUsername;
            call.missed = false;
            call.rejected = false;
            call.synced = false;
            call.userMade = false;
            call.timestamp = timeMilli;
            callDao.insertCall(call);
        });
    }

    void logMissed(){
        SaberDatabase.databaseWriteExecutor.execute(() -> {
            Date date = new Date();
            //This method returns the time in millis
            long timeMilli = date.getTime();
            Call call = new Call();
            call.phone = callerUsername;
            call.missed = true;
            call.rejected = false;
            call.synced = false;
            call.userMade = false;
            call.timestamp = timeMilli;
            callDao.insertCall(call);
        });
    }

    void logRejected(){
        SaberDatabase.databaseWriteExecutor.execute(() -> {
            Date date = new Date();
            //This method returns the time in millis
            long timeMilli = date.getTime();
            Call call = new Call();
            call.phone = callerUsername;
            call.missed = false;
            call.rejected = true;
            call.synced = false;
            call.userMade = false;
            call.timestamp = timeMilli;
            callDao.insertCall(call);
        });
    }

    void
    toggleAccept(BackgroundService service){
        accept = !accept;
        if(accept){
            callAccpted = true;
            service.acceptCall();
//            logAccepted();
            return;
        }
    }

    void toggleMute(BackgroundService service){
        mute = !mute;
        if(mute){
            service.muteLine();
            muteToggleButton.findViewById(R.id.mic_off_icon).setVisibility(View.GONE);
            muteToggleButton.findViewById(R.id.mic_on_icon).setVisibility(View.VISIBLE);
            return;
        }
        muteToggleButton.findViewById(R.id.mic_on_icon).setVisibility(View.GONE);
        muteToggleButton.findViewById(R.id.mic_off_icon).setVisibility(View.VISIBLE);
        service.unMuteLine();
    }

    void toggleVideo(BackgroundService service){
        video = !video;
        if(video){
            service.enableVideo();
            videoCamToggleButton.findViewById(R.id.video_on_icon).setVisibility(View.GONE);
            videoCamToggleButton.findViewById(R.id.video_off_icon).setVisibility(View.VISIBLE);
            return;
        }
        videoCamToggleButton.findViewById(R.id.video_off_icon).setVisibility(View.GONE);
        videoCamToggleButton.findViewById(R.id.video_on_icon).setVisibility(View.VISIBLE);
        service.disableVideo();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        disposable.dispose();
    }

    public void handleEndCallEvent() {

        if(!callAccpted)
            logMissed();

        if(callAccpted)
            logAccepted();
            toggleAccept(backgroundService);


        finish();
    }
}