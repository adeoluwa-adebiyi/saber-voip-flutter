package com.vanillaapps.saber;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.net.sip.SipAudioCall;
import android.net.sip.SipProfile;
import android.os.Binder;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.PowerManager;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.LinearLayout;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.core.app.NotificationCompat;
import androidx.fragment.app.FragmentActivity;

import com.google.gson.Gson;
import com.vanillaapps.saber.models.AppEvent;
import com.vanillaapps.saber.models.CallEndedAppEvent;
import com.vanillaapps.saber.models.IncomingCallAppEvent;
import com.vanillaapps.saber.models.IncomingVideoCallAppEvent;
import com.vanillaapps.saber.models.db.database.SaberDatabase;


import butterknife.BindView;
import butterknife.ButterKnife;
import io.flutter.plugin.common.MethodChannel;
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers;
import io.reactivex.rxjava3.annotations.NonNull;
import io.reactivex.rxjava3.core.Observable;
import io.reactivex.rxjava3.core.Observer;
import io.reactivex.rxjava3.core.Scheduler;
import io.reactivex.rxjava3.disposables.CompositeDisposable;
import io.reactivex.rxjava3.disposables.Disposable;
import io.reactivex.rxjava3.functions.Consumer;
import io.reactivex.rxjava3.schedulers.Schedulers;
import io.reactivex.rxjava3.subjects.PublishSubject;


interface SIPEventsReactor{
    void handleIncomingCallAppEvent(IncomingCallAppEvent event);
    void registerAppNotifierObserver(Observer<AppEvent> eventObserver);
}


public class BackgroundService extends Service implements SIPEventsReactor {

    private PowerManager.WakeLock wakeLock;

    public LocalBinder binder;

    private String userId;

    static MjSipCallUtility mjSipCallerUtility;

    static PublishSubject<AppEvent> appEventStream;

    CompositeDisposable disposable = new CompositeDisposable();

    static PublishSubject<AppEvent> appEventNotifierStream;

    private static boolean userBusy = false;

    private IncomingCallSessionActor incomingCallSessionActor = null;

    Observer<AppEvent> observer = new io.reactivex.rxjava3.core.Observer<AppEvent>() {

        @Override
        public void onSubscribe(@NonNull Disposable d) {

        }

        @Override
        public void onNext(@NonNull AppEvent appEvent) {

            if(appEvent instanceof IncomingCallAppEvent){
                handleIncomingCallAppEvent((IncomingCallAppEvent)appEvent);
            }

            if(appEvent instanceof CallEndedAppEvent){
                handleCallEndedAppEvent((CallEndedAppEvent)appEvent);
            }
        }

        @Override
        public void onError(@NonNull Throwable e) {

        }

        @Override
        public void onComplete() {

        }

    };


    public BackgroundService() {
        binder = new LocalBinder(this);
    }

    @Override
    public void onCreate() {
        super.onCreate();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Action launch_app = new Notification.Action.Builder(null, "Launch App",
                    PendingIntent.getActivity(getApplicationContext(), 102,
                            new Intent(this,com.vanillaapps.saber.MainActivity.class ), 0)).build();
            startForeground(101,
                    new Notification.Builder(getApplicationContext())
                            .setChannelId(Constants.getInstance().packageName)
                            .setContentTitle("saber")
                            .setContentText("Offline")
                            .setActions(launch_app)
                            .build());
        }
        appEventStream = PublishSubject.create();
        appEventNotifierStream = PublishSubject.create();

        mjSipCallerUtility = MjSipCallUtility.getInstance(this);
        mjSipCallerUtility.listenForNotifications(appEventStream);
        ((Observable<AppEvent>)appEventStream).subscribe(observer);

    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            wakeLock = ((PowerManager)getSystemService(POWER_SERVICE))
                    .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK |PowerManager.ACQUIRE_CAUSES_WAKEUP |PowerManager.ON_AFTER_RELEASE, "BackgroundService::Lock");
            wakeLock.acquire();
        }
        try {
            String userId = intent.getExtras().getString(Constants.getInstance().signedInUserId);
            Log.d("BG_CALL_SERVICE","USER_ID: "+userId);

        }catch (Exception e){
            Log.d("BG_CALL_SERVICE.E",e.toString());
        }
        return START_STICKY;
    }


    void loginSIP(String username, String password, String serverURI, MethodChannel.Result result){
        try{
            boolean status = mjSipCallerUtility.loginAndAllowIncoming(username, password, serverURI, getApplicationContext());
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    result.success(mjSipCallerUtility.isUserLoggedIn());
                }
            },6000);

        }catch (Exception e){
            Log.d("LOGINSIP_EXCEPTION", e.toString());
        }

    }

    void makeCall(String callerUserName, MethodChannel.Result result){
        try {
            SipProfile profile = new SipProfile.Builder(callerUserName,
                    new ServerConnectionDetails().serverDomain)
                    .setAuthUserName(callerUserName)
                    .build();
            mjSipCallerUtility.callUser(profile, new SIPAudioCallStatusListener(){

                @Override
                void onCallEstablishedCallback(SipAudioCall sipAudioCall) {

                    result.success(true);
                }

                @Override
                void onCallFailed() {
                    result.success(false);
                }
            });
        }catch (Exception e){
            result.success(false);
        }
    }

    void makeVideoCall(String callerUserName, int frameId, FragmentActivity fragmentActivity){
        try {
            SipProfile profile = new SipProfile.Builder(callerUserName).setAuthUserName(callerUserName).build();
            mjSipCallerUtility.videoCallUser(profile, frameId, fragmentActivity,new SIPAudioCallStatusListener(){

                @Override
                void onCallEstablishedCallback(SipAudioCall sipAudioCall) {
                }

                @Override
                void onCallFailed() {
                }
            });
        }catch (Exception e){

        }
    }

    void endCall(MethodChannel.Result result){
        boolean endedCall = mjSipCallerUtility.mysipclient.Hangup();
        result.success(endedCall);
        EventQueue.getInstance().enqueue(new CallEndedAppEvent());
    }

    @Override
    public IBinder onBind(Intent intent) {
        return binder;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    private void handleIncomingVideoCallEvent(IncomingVideoCallAppEvent object) {

    }

    public void handleIncomingCallAppEvent(IncomingCallAppEvent event) {
        Intent incomingCallIntent = new Intent(this, IncomingCallActivity.class);
        incomingCallIntent.putExtra("from",event.from);
        incomingCallIntent.putExtra("to",event.to);

        PendingIntent pendingIncomingCallIntent = PendingIntent.getActivity(this, 0, incomingCallIntent, 0);


//        if(!userBusy) {
//            userBusy = true;
//        }else{
//            notifyCallerUserBusy();
//        }

        if(Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.O)
            startActivity(incomingCallIntent);

        if(Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O)
            showIncomingCallOverlay();

//        showIncomingCallNotification(event, pendingIncomingCallIntent);

    }

    protected void showIncomingCallOverlay() {
        try {
            WindowManager mWindowManager = (WindowManager) getApplicationContext().getSystemService(Context.WINDOW_SERVICE);
            WindowManager.LayoutParams mLayoutParams = new WindowManager.LayoutParams(
                    WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON,
                    PixelFormat.TRANSLUCENT);
            mLayoutParams.gravity = Gravity.CENTER_HORIZONTAL | Gravity.CENTER_VERTICAL;
            LayoutInflater layoutInflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            ViewGroup mTopView = (ViewGroup) layoutInflater.inflate(R.layout.activity_incoming_call, new LinearLayout(this));
            incomingCallSessionActor = new IncomingCallSessionActor((View)mTopView, this, getApplicationContext());
            mWindowManager.addView(mTopView, mLayoutParams);
        }catch (Exception e){
            System.out.println("EXCEPTION: "+e.getMessage());
        }
    }

    private void showIncomingCallNotification(IncomingCallAppEvent event, PendingIntent pendingIncomingCallIntent) {
        NotificationChannel mChannel = null;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            mChannel = notificationManager.getNotificationChannel(Constants.getInstance().noitfyChannelId);
            if (mChannel == null) {
                mChannel = new NotificationChannel(Constants.getInstance().noitfyChannelId, "INCOMING_CALL", NotificationManager.IMPORTANCE_HIGH);
                notificationManager.createNotificationChannel(mChannel);
            }

            NotificationCompat.Builder builder = new NotificationCompat.Builder(this, Constants.getInstance().noitfyChannelId);

            builder.setSmallIcon(R.drawable.ic_baseline_call_24)
                    .setContentTitle(String.format("Incoming Call",event.from))
                    .setContentText("Tap to answer call")
                    .setPriority(NotificationCompat.PRIORITY_HIGH)
                    .setCategory(NotificationCompat.CATEGORY_CALL)
                    .setFullScreenIntent(pendingIncomingCallIntent, true)
                    .setAutoCancel(true)
                    .setOngoing(true);

            Notification notification = builder.build();
            notificationManager.notify(104, notification);
        }
    }

    public void sendMessage(String username, String message,MethodChannel.Result result){
        boolean messageSent = mjSipCallerUtility.sendMessage(username, message);
        result.success(messageSent);
    }

    private void notifyCallerUserBusy() {

    }

    private void handleCallEndedAppEvent(CallEndedAppEvent object) {
        ((NotificationManager)(getSystemService(Context.NOTIFICATION_SERVICE))).cancel(104);
//        incomingCallSessionActor = null;
        appEventNotifierStream.onNext(object);
    }

    public void acceptCall() {
        mjSipCallerUtility.acceptUserCall();
    }

    public void muteLine() {
        mjSipCallerUtility.muteLine();
    }

    public void unMuteLine() {
        mjSipCallerUtility.unMuteLine();
    }

    public void enableVideo() {
        mjSipCallerUtility.enableVideo();
    }

    public void disableVideo() {
        mjSipCallerUtility.disableVideo();
    }

    public String getCurrentCallerUsername() {
        return mjSipCallerUtility.getCurrentCallerUsername();
    }

    public void fetchCallHistory(MethodChannel.Result result){
        String json;
        boolean setvalue;
        Observable.fromCallable(()-> SaberDatabase.getDatabase(getApplicationContext()).callDao().getAll())
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread()).
                subscribe(calls -> result.success(new Gson().toJson(calls)));
    }

    public void endSession(MethodChannel.Result result) {
        AuthDetail.getInstance().setUsername("");
        AuthDetail.getInstance().setPassword("");
        mjSipCallerUtility.endSession();
        SaberDatabase.databaseWriteExecutor.execute(()-> SaberDatabase.getDatabase(getApplicationContext()).callDao().deleteAll());
        result.success(true);
    }

    public class LocalBinder extends Binder {
        private BackgroundService service;

        BackgroundService getService(){
            return service;
        }

        LocalBinder(BackgroundService service){
            this.service = service;
        }
    }

    @Override
    public void onDestroy() {
        disposable.dispose();
        super.onDestroy();
    }

    @Override
    public boolean onUnbind(Intent intent) {
        return super.onUnbind(intent);
    }


    public void registerAppNotifierObserver(Observer<AppEvent> observer){
        appEventNotifierStream.subscribe(observer);
    }



}
