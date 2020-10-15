package com.vanillaapps.saber;

public class ServerConnectionDetails{

    String serverDomain = "vpbx-eu.netelip.com";

    static ServerConnectionDetails INSTANCE = null;

    public static ServerConnectionDetails getInstance() {
        if(INSTANCE == null){
            INSTANCE = new ServerConnectionDetails();
        }
        return INSTANCE;
    }
}