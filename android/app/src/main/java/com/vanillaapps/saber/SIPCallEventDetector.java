package com.vanillaapps.saber;

public class SIPCallEventDetector {

    static SIPCallEventDetector INSTANCE = null;

    static SIPCallEventDetector getInstance(){
        if(INSTANCE == null){
            INSTANCE = new SIPCallEventDetector();
        }
        return INSTANCE;
    }

    String incomingMarker = "Incoming...";

    Boolean eventIsIncomingCall(String notification){
        String[] params = notification.split(",");
        return params[2].equals(incomingMarker) && (Integer.parseInt(params[1])==-1);
    }

    Boolean eventIsCallEnded(String notification){
        return notification.contains("Open,Available") || notification.contains("-1,Hangup");
    }

    Boolean eventIsCallAccepted(String notification){
        return notification.contains("-1,Accepted") || notification.contains("-1,Hangup");
    }


    public boolean eventIsMessageReceived(String notification) {
        return false;
    }
}
