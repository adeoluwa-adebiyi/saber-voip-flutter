package com.vanillaapps.saber;

import android.app.AlertDialog;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.net.sip.SipProfile;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;
import android.provider.ContactsContract;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.Nullable;

import java.text.ParseException;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.reactivex.rxjava3.annotations.NonNull;
import io.reactivex.rxjava3.core.Observable;
import io.reactivex.rxjava3.core.Observer;
import io.reactivex.rxjava3.disposables.Disposable;


public class MainActivity extends FlutterActivity {


    BackgroundService backgroundService;

    Boolean mBound;

    ServiceConnection serviceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder binder) {
            backgroundService = ((BackgroundService.LocalBinder)binder).getService();
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            backgroundService = null;
        }
    };

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        Intent bgServiceIntent = new Intent(this,
                BackgroundService.class);
//        bgServiceIntent.putExtra(Constants.getInstance().signedInUserId,"");
//        bgServiceIntent.putExtra(Constants.getInstance().passwordId,"");
//        startService(bgServiceIntent);
        mBound = bindService(bgServiceIntent, serviceConnection, Context.BIND_AUTO_CREATE);



        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if(!Settings.canDrawOverlays(getContext() )){
                AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(this);
                AlertDialog alertDialog = dialogBuilder
                        .setTitle("Permission Required")
                        .setCancelable(false)
                        .setMessage("You need to enable the \"Display over other apps\" permission for \"Rioja Red Fijo\" continue")
                        .setPositiveButton("Proceed", (dialog, which) -> {
                            RequestPermission();
                        }).setNegativeButton("Cancel",(dialog, which)->{stopService(bgServiceIntent);finish();}).create();
                alertDialog.show();
            }
        }

        new MethodChannel(this.getFlutterEngine().getDartExecutor().getBinaryMessenger(), "methods").setMethodCallHandler((call, result) -> {
            switch(call.method){

                case "loginSIP":
                    String username = call.argument("username");
                    String password = call.argument("password");
                    String serverURI = call.argument("serverURI");
                    AuthDetail.getInstance().setUsername(username);
                    AuthDetail.getInstance().setPassword(password);
                    backgroundService.loginSIP(AuthDetail.getInstance().getUsername(), AuthDetail.getInstance().getPassword(), serverURI==null?ServerConnectionDetails.getInstance().serverDomain:serverURI, result);
                    break;

                case "makeSIPCall":
                    System.out.printf("USERNAME: %s", call.argument("callerUsername").toString());
                    initiateAudioCallActivity(call.argument("callerUsername"));
                    break;

                case "endSIPCall":
                    backgroundService.endCall(result);
                    break;


                case "makeSIPVideoCall":
                    System.out.printf("USERNAME: %s", call.argument("callerUsername").toString());
                    initiateVideoCallActivity(call.argument("callerUsername"));
                    break;


                case "sendChat":
                    String chatMessage = call.argument("message");
                    String chatUsername = call.argument("username");
                    backgroundService.sendMessage(chatUsername, chatMessage, result);
                    break;


                case "resetAccount":
                    backgroundService.endSession(result);
                    break;


                case  "getCallHistory":
                    backgroundService.fetchCallHistory(result);
                    break;

                default:
                    Log.d("INVALID_METHOD", "Specify a valid method call!");
                    break;

            }
        });
    }

    void initiateVideoCallActivity(String callerUserName){
        try {
            SipProfile profile = new SipProfile.Builder(callerUserName, new ServerConnectionDetails().serverDomain).build();
            Intent videoCallActivityIntent = new Intent(this, VideoCallActivity.class);
            videoCallActivityIntent.putExtra(Constants.getInstance().callerUsernameId, callerUserName);
            startActivity(videoCallActivityIntent);
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    void initiateAudioCallActivity(String callerUserName){
        try {
            SipProfile profile = new SipProfile.Builder(callerUserName, new ServerConnectionDetails().serverDomain).build();
            Intent audioCallActivityIntent = new Intent(this, AudioCallerActivity.class);
            audioCallActivityIntent.putExtra(Constants.getInstance().callerUsernameId, callerUserName);
            startActivity(audioCallActivityIntent);
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    private void launchContactActivity() {
        Intent intent = new Intent(Intent.ACTION_INSERT);
        intent.setType(ContactsContract.Contacts.CONTENT_TYPE);
        startActivityForResult(intent,0);
    }


    public static int ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE= 2323;

    private void RequestPermission() {
        // Check if Android M or higher
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            // Show alert dialog to the user saying a separate permission is needed
            // Launch the settings activity if the user prefers
            Intent myIntent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION);
            startActivity(myIntent);
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (!Settings.canDrawOverlays(getContext())) {
                    PermissionDenied();
                }
                else
                {
                    // Permission Granted-System will work
                }

            }
        }
    }

    private void PermissionDenied() {
        RequestPermission();
    }


    @Override
    protected void onResume() {
        super.onResume();
        Intent bgServiceIntent = new Intent(this,
                BackgroundService.class);
        mBound = bindService(bgServiceIntent, serviceConnection, Context.BIND_AUTO_CREATE);
    }

    @Override
    protected void onPause() {
        super.onPause();
        System.out.println("Activity paused");
        if(mBound) {
            unbindService(serviceConnection);
            mBound = false;
        }
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