package com.vanillaapps.saber;

import android.content.ComponentName;
import android.content.ContentResolver;
import android.content.Context;
import android.content.ServiceConnection;
import android.database.Cursor;
import android.net.Uri;
import android.os.IBinder;
import android.provider.ContactsContract;
import android.view.View;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.vanillaapps.saber.models.AppEvent;
import com.vanillaapps.saber.models.db.daos.CallDao;
import com.vanillaapps.saber.models.db.database.SaberDatabase;
import com.vanillaapps.saber.models.db.entities.Call;

import java.util.Date;

import io.flutter.plugin.common.MethodChannel;
import io.reactivex.rxjava3.annotations.NonNull;
import io.reactivex.rxjava3.core.Observer;
import io.reactivex.rxjava3.disposables.CompositeDisposable;
import io.reactivex.rxjava3.disposables.Disposable;
import io.reactivex.rxjava3.subjects.PublishSubject;

class IncomingCallSessionActor {

    protected LinearLayout muteToggleButton;

    protected LinearLayout endCallBtn;

    protected LinearLayout acceptToggleButton;

    protected LinearLayout videoCamToggleButton;

    protected TextView callingUser;

    EventQueue appEventQueue;

    boolean mBound = false;

    boolean mute = false;

    boolean video = false;

    boolean accept = false;

    boolean endedCall = false;

    String callerUsername = "";

    String callerName = "";

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

        }

        @Override
        public void onServiceDisconnected(ComponentName name) {

        }
    };

    PublishSubject<AppEvent> serviceEventStream;

    SaberDatabase db;

    CallDao callDao;

    View screenView = null;

    CompositeDisposable disposable = new CompositeDisposable();

    private boolean callAccpted = false;

    public IncomingCallSessionActor(View topView, BackgroundService bgService, Context context) {

        backgroundService = bgService;

        muteToggleButton = topView.findViewById(R.id.microphone_btn);

        endCallBtn = topView.findViewById(R.id.end_call_btn);

        screenView = topView;

        acceptToggleButton = topView.findViewById(R.id.accept_call_btn);

        videoCamToggleButton = topView.findViewById(R.id.video_call_btn);

        callingUser = topView.findViewById(R.id.in_contact_phone_display);

        appEventQueue = EventQueue.getInstance();

        db = SaberDatabase.getDatabase(context);

        callDao = db.callDao();

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
                logAccepted();
                toggleAccept(backgroundService);
                acceptToggleButton.setVisibility(View.GONE);
            }
        });

        endCallBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                endedCall = true;

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

                if(!callAccpted && endedCall)
                    logRejected();
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

        ContentResolver localContentResolver = this.backgroundService.getContentResolver();
        Cursor contactLookupCursor =
                localContentResolver.query(
                        Uri.withAppendedPath(ContactsContract.PhoneLookup.CONTENT_FILTER_URI,
                                Uri.encode(callerUsername)),
                        new String[] {ContactsContract.PhoneLookup.DISPLAY_NAME, ContactsContract.PhoneLookup._ID},
                        null,
                        null,
                        null);
        try {
            while(contactLookupCursor.moveToNext()){
                callerName = contactLookupCursor.getString(contactLookupCursor.getColumnIndexOrThrow(ContactsContract.PhoneLookup.DISPLAY_NAME));
                String contactId = contactLookupCursor.getString(contactLookupCursor.getColumnIndexOrThrow(ContactsContract.PhoneLookup._ID));
            }
        } finally {
            contactLookupCursor.close();
        }

        callingUser.setText(callerName);

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

    void toggleAccept(BackgroundService service){
        accept = !accept;
        if(accept){
            callAccpted = true;
            service.acceptCall();
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

    protected void endSession() {
//        disposable.dispose();
    }

    public void handleEndCallEvent() {

        if(!callAccpted && !endedCall)
            logMissed();

//        if(callAccpted)
//            logAccepted();

//        toggleAccept(backgroundService);

        try {
            ((WindowManager) backgroundService.getSystemService(Context.WINDOW_SERVICE)).removeView(screenView);
        }catch (Exception e){
            System.out.println("CALL_EVENT_EXCEPTION: "+e.toString());
        }

        endSession();

    }
}