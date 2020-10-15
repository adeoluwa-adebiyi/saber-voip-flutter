package com.vanillaapps.saber.models;

public class ChatMessageEvent implements AppEvent {
    private Long time;
    private String from;
    private String to;
    private String message;

    public ChatMessageEvent(Long time, String from, String to, String message){
        this.time = time;
        this.from = from;
        this.to = to;
        this.message = message;
    }

    public Long getTime() {
        return time;
    }

    public void setTime(Long time) {
        this.time = time;
    }

    public String getFrom() {
        return from;
    }

    public void setFrom(String from) {
        this.from = from;
    }

    public String getTo() {
        return to;
    }

    public void setTo(String to) {
        this.to = to;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
