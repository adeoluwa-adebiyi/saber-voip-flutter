package com.vanillaapps.saber;

import androidx.annotation.Nullable;
import android.content.ComponentName;
import android.content.ContentResolver;
import android.content.Intent;
import android.content.ServiceConnection;
import android.database.Cursor;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.os.IBinder;

import butterknife.BindView;
import butterknife.ButterKnife;
import io.flutter.plugin.common.MethodChannel;
import io.reactivex.rxjava3.annotations.NonNull;
import io.reactivex.rxjava3.core.Observer;
import io.reactivex.rxjava3.disposables.Disposable;

import android.content.Context;
import android.provider.ContactsContract;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.vanillaapps.saber.models.AppEvent;
import com.vanillaapps.saber.models.CallAcceptedEvent;
import com.vanillaapps.saber.models.CallEndedAppEvent;
import com.vanillaapps.saber.models.db.database.SaberDatabase;
import com.vanillaapps.saber.models.db.entities.Call;

import java.util.Date;


public class AudioCallerActivity extends AppCompatActivity {

        BackgroundService backgroundService;
        String callUsername;
        Boolean mBound;

        @BindView(R2.id.microphone_btn)
        LinearLayout microphoneBtn;

        @BindView(R2.id.end_call_btn)
        LinearLayout callBtn;

        @BindView(R2.id.calling_user_text)
        TextView callingUserTextView;

        @BindView(R2.id.calling_user_ended_text)
        TextView callingUserEndedTextView;

        String callerName;

        boolean mute = false;

        boolean accepted = false;

        boolean callEnded = false;

        @BindView(R2.id.contact_phone_display)
        TextView callerUserNameTextView;

        ServiceConnection serviceConnection = new ServiceConnection() {
            @Override
            public void onServiceConnected(ComponentName name, IBinder service) {
                backgroundService = ((BackgroundService.LocalBinder)service).getService();
                ((SIPEventsReactor)backgroundService).registerAppNotifierObserver(appEventObserver);
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

                SaberDatabase.databaseWriteExecutor.execute(() -> {
                    Date date = new Date();
                    //This method returns the time in millis
                    long timeMilli = date.getTime();
                    Call call = new Call();
                    call.phone = callUsername;
                    call.missed = false;
                    call.rejected = false;
                    call.synced = false;
                    call.userMade = true;
                    call.timestamp = timeMilli;
                    SaberDatabase.getDatabase(getApplicationContext()).callDao().insertCall(call);
                });
            }

            @Override
            public void onServiceDisconnected(ComponentName name) {
                backgroundService = null;
            }
        };

        Observer<AppEvent> appEventObserver = new Observer<AppEvent>() {
            @Override
            public void onSubscribe(@NonNull Disposable d) {

            }

            @Override
            public void onNext(@NonNull AppEvent appEvent) {

                if(appEvent instanceof CallAcceptedEvent){
                    handleCallAcceptedEvent();
                }

                if(appEvent instanceof CallEndedAppEvent){
                    handleCallEndedEvent();
                }

            }

            @Override
            public void onError(@NonNull Throwable e) {

            }

            @Override
            public void onComplete() {

            }
        };


        @Override
        protected void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.activity_call);
            ButterKnife.bind(this);
            callUsername = getIntent().getExtras().getString(Constants.getInstance().callerUsernameId);

            callerName = callUsername;


            ContentResolver localContentResolver = this.getContentResolver();
            Cursor contactLookupCursor =
                    localContentResolver.query(
                            Uri.withAppendedPath(ContactsContract.PhoneLookup.CONTENT_FILTER_URI,
                                    Uri.encode(callUsername)),
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


            callerUserNameTextView.setText(callerName);
            Intent backgroundServiceIntent = new Intent(this, BackgroundService.class);
            mBound = bindService(backgroundServiceIntent, serviceConnection, Context.BIND_AUTO_CREATE);

            callBtn.setOnClickListener(v -> {
                if(callEnded){
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
                    callBtn.setBackgroundColor(Color.parseColor("#F40149"));
                    callBtn.findViewById(R.id.call_icon_view).setVisibility(View.GONE);
                    callBtn.findViewById(R.id.end_call_icon_view).setVisibility(View.VISIBLE);
                    callingUserTextView.setVisibility(View.VISIBLE);
                    callingUserEndedTextView.setVisibility(View.GONE);
                    callEnded = false;
                    return;
                }
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
            });

            microphoneBtn.setOnClickListener(v -> {
                mute = !mute;
                if(mute){
                    backgroundService.muteLine();microphoneBtn.findViewById(R.id.mute_icon).setVisibility(View.GONE);
                    microphoneBtn.findViewById(R.id.unmute_icon).setVisibility(View.VISIBLE);
                    return;
                }
                backgroundService.unMuteLine();microphoneBtn.findViewById(R.id.mute_icon).setVisibility(View.VISIBLE);
                microphoneBtn.findViewById(R.id.unmute_icon).setVisibility(View.GONE);
            });
        }

        @Override
        protected void onStop() {
            super.onStop();
            if(mBound) {
                unbindService(serviceConnection);
                mBound = false;
            }
        }

        private void handleCallAcceptedEvent() {
//            accepted = true;
//            if(accepted){
//                callBtn.findViewById(R.id.call_icon_view).setVisibility(View.GONE);
//                callBtn.findViewById(R.id.end_call_icon_view).setVisibility(View.VISIBLE);
//            }
        }

        private void handleCallEndedEvent() {
            accepted = false;
            callEnded = true;
            if(!accepted){
                callBtn.setBackgroundColor(Color.GREEN);
                callBtn.findViewById(R.id.call_icon_view).setVisibility(View.VISIBLE);
                callBtn.findViewById(R.id.end_call_icon_view).setVisibility(View.GONE);
                callingUserTextView.setVisibility(View.INVISIBLE);
                callingUserEndedTextView.setVisibility(View.VISIBLE);
            }
        }
}