package com.vanillaapps.saber;

public class AuthDetail {

    static AuthDetail INSTANCE = null;

    private String username = "";
    private String password = "";

    static AuthDetail getInstance(){
        if(INSTANCE == null){
            INSTANCE = new AuthDetail();
            return INSTANCE;
        }
        return INSTANCE;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
