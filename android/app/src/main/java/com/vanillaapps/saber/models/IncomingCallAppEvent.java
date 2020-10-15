package com.vanillaapps.saber.models;

public class IncomingCallAppEvent implements AppEvent {
    public String from;
    public String to;
    IncomingCallAppEvent() {}

    public IncomingCallAppEvent(String from, String to){
        this.from = from;
        this.to = to;
    }
}
