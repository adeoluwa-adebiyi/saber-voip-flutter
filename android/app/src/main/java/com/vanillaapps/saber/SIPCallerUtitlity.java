package com.vanillaapps.saber;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.net.sip.SipAudioCall;
import android.net.sip.SipException;
import android.net.sip.SipManager;
import android.net.sip.SipProfile;
import android.net.sip.SipRegistrationListener;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import androidx.fragment.app.FragmentActivity;

import com.mizuvoip.jvoip.SipStack;
import com.vanillaapps.saber.models.AppEvent;
import com.vanillaapps.saber.models.CallEndedAppEvent;
import com.vanillaapps.saber.models.ChatMessageEvent;
import com.vanillaapps.saber.models.IncomingCallAppEvent;

import java.util.Calendar;
import java.util.TimeZone;

import io.reactivex.rxjava3.subjects.PublishSubject;

public abstract class SIPCallerUtitlity {

    SipProfile sipProfile;

    SipManager sipManager;

//    static SIPCallerUtitlity getInstance(){
//        if(INSTANCE == null){
//            INSTANCE = new SIPCallerUtitlity();
//            return INSTANCE;
//        }
//        return INSTANCE;
//    }

    boolean loginAndAllowIncoming(String username, String password, String domain,Context context, SIPCallerUtilityRegistrationListener sipCallerUtilityRegistrationListener){
        try {
            if (sipManager == null) {
                sipManager = SipManager.newInstance(context);
            }
            SipProfile.Builder builder = new SipProfile.Builder(username, domain);
            builder.setPassword(password);
            sipProfile = builder.build();
            Intent intent = new Intent();
            PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, intent, Intent.FILL_IN_DATA);
            sipManager.open(sipProfile, pendingIntent, new SipRegistrationListener() {
                public void onRegistering(String localProfileUri) {
                    sipCallerUtilityRegistrationListener.onRegisteringCallback(localProfileUri);
                }

                public void onRegistrationDone(String localProfileUri, long expiryTime) {
                    sipCallerUtilityRegistrationListener.onRegistrationDoneCallback(localProfileUri, expiryTime);
                }

                public void onRegistrationFailed(String localProfileUri, int errorCode,
                                                 String errorMessage) {
                    sipCallerUtilityRegistrationListener.onRegistrationFailedCallback(localProfileUri, errorCode, errorMessage);
                }
            });
            return true;
        }catch (Exception e){
            return false;
        }
    }

    void setRegistrationListener(SIPCallerUtilityRegistrationListener sipCallerUtilityRegistrationListener){

        try {
            sipManager.setRegistrationListener(sipProfile.getUriString(), new SipRegistrationListener() {

                public void onRegistering(String localProfileUri) {
                    sipCallerUtilityRegistrationListener.onRegisteringCallback(localProfileUri);
                }

                public void onRegistrationDone(String localProfileUri, long expiryTime) {
                    sipCallerUtilityRegistrationListener.onRegistrationDoneCallback(localProfileUri, expiryTime);
                }

                public void onRegistrationFailed(String localProfileUri, int errorCode,
                                                 String errorMessage) {
                    sipCallerUtilityRegistrationListener.onRegistrationFailedCallback(localProfileUri, errorCode, errorMessage);
                }
            });
        }catch (Exception e){
        }
    }

    void logout(){
        if (sipManager == null) {
            return;
        }
        try {
            if (sipProfile != null) {
                sipManager.close(sipProfile.getUriString());
            }
        } catch (Exception ee) {
        }
    }

    void callUser(SipProfile profile, SIPAudioCallStatusListener sipAudioCallStatusListener){

        SipAudioCall.Listener listener = new SipAudioCall.Listener() {

            @Override
            public void onCallEstablished(SipAudioCall call) {
                sipAudioCallStatusListener.onCallEstablishedCallback(call);
            }

            @Override

            public void onCallEnded(SipAudioCall call) {
                sipAudioCallStatusListener.onCallEnded(call);
            }
        };

        try {
            sipManager.makeAudioCall(sipProfile, profile, listener, 0);
        }catch (SipException e){
            Log.d("SIP_EXCEPTION", e.toString());
        }

    }

    void listenForNotifications(){}
}


class  MjSipCallUtility {

    static PublishSubject<AppEvent> appEventStream;

    static MjSipCallUtility INSTANCE = null;

    static MjSipCallUtility getInstance(BackgroundService service){
        if(INSTANCE == null) {
            instance = service;
            INSTANCE = new MjSipCallUtility();
        }
        return INSTANCE;
    }

    private static final String LOGTAG = "NOTIFICATIONS";
    SipStack mysipclient = new SipStack();
    private boolean terminateNotifThread = false;
    GetNotificationsThread notifThread = null;
    static BackgroundService instance = null;


    boolean loginAndAllowIncoming(String username, String password, String domain, Context context) {
        mysipclient.Init(context);
        mysipclient.SetParameter("serveraddress", domain);
        mysipclient.SetParameter("username", username);
        mysipclient.SetParameter("password", password);
        mysipclient.Start();
        boolean start = mysipclient.IsRegistered();
        if(!start){
            mysipclient.Stop();
        }
        return start;
    }

    boolean isUserLoggedIn(){
        return mysipclient.IsRegistered();
    }

    void callUser(SipProfile profile, SIPAudioCallStatusListener sipAudioCallStatusListener) {
        boolean callSuccessful = mysipclient.Call(-1, profile.getAuthUserName());

        if(callSuccessful){
            sipAudioCallStatusListener.onCallEstablishedCallback(null);
        }else {
            sipAudioCallStatusListener.onCallFailed();
        }

    }

    void videoCallUser(SipProfile profile, int frameId, FragmentActivity fragmentActivity, SIPAudioCallStatusListener sipAudioCallStatusListener) {
        boolean callSuccessful = mysipclient.VideoCall(profile.getAuthUserName(), frameId, fragmentActivity);
        if(callSuccessful){
            sipAudioCallStatusListener.onCallEstablishedCallback(null);
        }else {
            sipAudioCallStatusListener.onCallFailed();
        }
    }

    void acceptUserCall(){
        mysipclient.Accept(-1);
    }

    boolean sendMessage(String username, String message){
        return mysipclient.SendChat(-1, username, message);
    }

    void listenForNotifications(PublishSubject<AppEvent> publishSubject){
        appEventStream = publishSubject;
        notifThread = new GetNotificationsThread();
        notifThread.start();
    }

    public static Handler NotifThreadHandler = new Handler()
    {
        public void handleMessage(android.os.Message msg)
        {
            try {
                if (msg == null || msg.getData() == null) return;;
                Bundle resBundle = msg.getData();

                String receivedNotif =  msg.getData().getString("notifmessages");

                if (receivedNotif != null && receivedNotif.length() > 0)
                    ReceiveNotifications(receivedNotif);

            } catch (Throwable e) { Log.e(LOGTAG, "NotifThreadHandler handle Message"); }
        }
    };

    //process notificatins phrase 1: split by line (we can receive multiple notifications separated by \r\n)
    static String[] notarray = null;
    static public void ReceiveNotifications(String notifs)
    {
        if (notifs == null || notifs.length() < 1) return;
        notarray = notifs.split("\r\n");

        if (notarray == null || notarray.length < 1) return;

        for (int i = 0; i < notarray.length; i++)
        {
            if (notarray[i] != null && notarray[i].length() > 0)
            {
                if(notarray[i].indexOf("WPNOTIFICATION,") == 0) notarray[i] = notarray[i].substring(15); //remove the WPNOTIFICATION, prefix
                ProcessNotifications(notarray[i]);
            }
        }
    }

    //process notificatins phrase 2: processing notification strings
    static public void ProcessNotifications(String notification)
    {
        DisplayStatus(notification); //we just display them in this simple test application
        //see the Notifications section in the documentation about the possible messages (parse the notification string and process them after your needs)



        if (notification.indexOf("WPNOTIFICATION,") == 0)  //remove WPNOTIFICATION prefix
        {
            notification = notification.substring(("WPNOTIFICATION,").length());
        }

        String[] params = notification.split(",");
        if(params.length < 2) return;
        notification = notification.substring(notification.indexOf(','));
        params = IncreaseArray(params,20);


        if(SIPCallEventDetector.getInstance().eventIsIncomingCall(notification)){
            appEventStream.onNext(new IncomingCallAppEvent(null, null));
        }

        if(SIPCallEventDetector.getInstance().eventIsCallEnded(notification)){
            appEventStream.onNext(new CallEndedAppEvent());
        }

        if(SIPCallEventDetector.getInstance().eventIsMessageReceived(notification)){
            String from="", to="", message="";
            appEventStream.onNext(new ChatMessageEvent(System.currentTimeMillis()/100L, from, to, message));
        }

        if(params[0].equals("STATUS"))
        {
            int line = StringToInt(params[1],0);
            if(line != -1) return;  //we handle only the global state. See the "Multiple lines" FAQ point in the documentation if you wish to handle individual lines explicitely
            int endpointtype = Integer.parseInt(params[5],0);
            if(endpointtype == 2) //incoming call
            {
                DisplayStatus("Incoming call from "+params[3]+" "+params[6]);
            }
        }
        else if(params[0].equals("POPUP"))
        {
//            Toast.makeText(this, notification, Toast.LENGTH_LONG).show();
        }
    }

    public static int StringToInt(String str, int def) //helper function for ProcessNotifications example code
    {
        try
        {
            return Integer.parseInt(str);
        }
        catch (Throwable e)
        {
        }
        return def;
    }


    private static String[] IncreaseArray(String[] strarray, int len) //helper function for ProcessNotifications example code
    {
        if(strarray.length >= len) return strarray;

        String[] newstrarray = new String[len];
        for(int i=0;i<strarray.length;i++)
        {
            if(strarray[i] != null)
                newstrarray[i] = strarray[i];
            else
                newstrarray[i] = "";
        }

        for(int i=strarray.length;i<len;i++)
        {
            newstrarray[i] = "";
        }
        return newstrarray;
    }

//    public void SetParameters()
//    {
//        String params = mParams.getText().toString();
//        if (params == null || mysipclient == null) return;
//        params = params.trim();
//
//        DisplayLogs("SetParameters: " + params);
//
//        mysipclient.SetParameters(params);
//    }

    static public void DisplayStatus(String stat)
    {
        if (stat == null) return;;
        DisplayLogs("SIP_Status: " + stat);
    }

    static public void DisplayLogs(String logmsg)
    {
        if (logmsg == null || logmsg.length() < 1) return;

        if ( logmsg.length() > 2500) logmsg = logmsg.substring(0,300)+"...";
        logmsg = "["+ new java.text.SimpleDateFormat("HH:mm:ss:SSS").format(Calendar.getInstance(TimeZone.getTimeZone("GMT")).getTime()) +  "] " + logmsg + "\r\n";

        Log.v(LOGTAG, logmsg);
//        if (mNotifications != null) mNotifications.append(logmsg);
    }

    public void muteLine() {
        mysipclient.Mute(-1, true,2);
    }

    public void unMuteLine(){
        mysipclient.Mute(-1, false, 2);
    }

    void enableVideo(){
        mysipclient.MuteVideo(-1, 0, 2);
    }

    void disableVideo(){
        mysipclient.MuteVideo(-1, 1, 2);
    }

    public String getCurrentCallerUsername() {
        String currentCallDetails = mysipclient.GetLineDetails(-1);
        String[] params = currentCallDetails.split(",");
        return params[4];
    }

    public void endSession() {
        mysipclient.ClearCredentials();
        mysipclient.ClearSettings();
        mysipclient.Stop();
    }


    public class GetNotificationsThread extends Thread
    {
        String sipnotifications = "";

        public void run()
        {
            try{
                try { Thread.currentThread().setPriority(4); } catch (Throwable e) { }  //we are lowering this thread priority a bit to give more chance for our main GUI thread

                while (!terminateNotifThread)
                {

                    try{
                        sipnotifications = "";
                        if (mysipclient != null)
                        {
                            //get notifications from the SIP stack
                            sipnotifications = mysipclient.GetNotificationsSync();

                            if (sipnotifications != null && sipnotifications.length() > 0)
                            {
                                // send notifications to Main thread using a Handler
                                Message messageToMainThread = new Message();
                                Bundle messageData = new Bundle();
                                messageToMainThread.what = 0;
                                messageData.putString("notifmessages", sipnotifications);
                                messageToMainThread.setData(messageData);

                                NotifThreadHandler.sendMessage(messageToMainThread);
                            }
                        }

                        if ((sipnotifications == null || sipnotifications.length() < 1) && !terminateNotifThread)
                        {
                            //some error occured. sleep a bit just to be sure to avoid busy loop
                            GetNotificationsThread.sleep(1);
                        }

                        continue;
                    }catch(Throwable e){  Log.e(LOGTAG, "ERROR, WorkerThread on run()intern", e); }
                    if(!terminateNotifThread)
                    {
                        GetNotificationsThread.sleep(10);
                    }
                }
            }catch(Throwable e){ Log.e(LOGTAG, "WorkerThread on run()"); }
        }
    }

}


class SIPCallerUtilityRegistrationListener {

     void onRegisteringCallback(String localProfileUri){

     }

     void onRegistrationDoneCallback(String localProfileUri, long expiryTime){

     }

    void onRegistrationFailedCallback(String localProfileUri, int errorCode, String errorMessage){

    }
}


class SIPAudioCallStatusListener{
    void onCallEstablishedCallback(SipAudioCall sipAudioCall){
//        sipAudioCall.startAudio();
//        sipAudioCall.setSpeakerMode(true);
    }

    void onCallEnded(SipAudioCall sipAudioCall){

    }

    void onCallFailed(){

    }
}