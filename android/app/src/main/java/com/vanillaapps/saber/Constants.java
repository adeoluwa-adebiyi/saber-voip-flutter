package com.vanillaapps.saber;

public class Constants{

    static Constants INSTANCE = null;

    String packageName = "com.vanillaapps.saber";
    String noitfyChannelId = "saber-notify";

    String signedInUserId = "USER_ID";
    String passwordId = "PASSWORD";
    String callerUsernameId = "CALLER_USER_NAME_ID";

    public static Constants getInstance() {
        if(INSTANCE == null){
            INSTANCE = new Constants();
        }
        return INSTANCE;
    }
}